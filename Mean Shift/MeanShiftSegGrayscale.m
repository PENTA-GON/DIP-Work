function output = MeanShiftSeg(input, Hs, Hr, M, windowSize)

ht=size(input,1);
wd=size(input,2);
output=input;

% store the location of mode
size_ = ht * wd;
limit = 4048;
modeX = [size_];
modeY = [size_];

clusterX = [size_];
clusterY = [size_];
clusterZ = [size_];


clusterSize = 0;
clusterMemberSize = [size_];
clusterMember = repmat(0, [limit*2 limit 2]);

figure(1);

fprintf('\n Starting meanshift');
tic
      
%windowSize = Hs;
        
for y=1:ht
    for x=1:wd
        % normalize with Hs & Hr
        newX = round(single(x) / Hs);
        newY = round(single(y) / Hs);
        newZ = round(single(input(y,x)) / Hr);
        
        shiftX = x; % newX * Hs;
        shiftY = y; % newY * Hs;
        r1 = shiftY - round(windowSize); r2 = shiftY + round(windowSize);
        c1 = shiftX - round(windowSize); c2 = shiftX + round(windowSize);
        
        % check boundaries of the region
        if (r1<1) r1 = 1 ; end
        if (c1<1) c1 = 1 ; end
        if (r2>ht) r2 = ht ; end
        if (c2>wd) c2 = wd ; end
        
        patch=input(r1:r2,c1:c2,:);
        
        dist = 1;
        while(dist > 0.2)
            withinCount = 0;
            accumulateZ = 0;
            accumulateX = 0; accumulateY = 0;
            for li=1:size(patch,1)
                for lj=1:size(patch,2)
                    % normalize with Hs & Hr
                    yi = single(r1 + li - 1) / Hs;
                    xi = single(c1 + lj - 1) / Hs;
                    xiZ = single(patch(li, lj)) / Hr;
                    
                    difZ = newZ - xiZ;
                    difX = newX - xi; difY = newY - yi;
                    
                    % Epanechnikov kernel derivative, basically only consider
                    % point in the hypersphere of radius bandwidth
                    euclideanD = sqrt(difX*difX + difY*difY + difZ*difZ);
                    
                    % If incribed hypersphere is the bound, then limit should be windowSize. However, if the superscribed
                    % hypershpere is the bound, then the limit should be distance from center to a vertex, i.e., sqrt(dim)*windowSize, where dim - dimesnions 
                    if euclideanD <= windowSize
                        accumulateZ = accumulateZ + xiZ;
                        accumulateX = accumulateX + xi;
                        accumulateY = accumulateY + yi;
                        withinCount = withinCount + 1;
                    end
                end
            end
            
            % get the mean of each channel
            meanZ = accumulateZ / withinCount;
            meanX = accumulateX / withinCount;
            meanY = accumulateY / withinCount;
            
            % mean shift vec = mean - currentX
            meanshiftVecZ = meanZ - newZ;
            meanshiftVecX = meanX - newX;
            meanshiftVecY = meanY - newY;
            
            % compute the distance of the meanshift vec as terminating
            % condition
            dist = sqrt(meanshiftVecZ*meanshiftVecZ + meanshiftVecX*meanshiftVecX + meanshiftVecY*meanshiftVecY);
            
            % apply the mean shift vec
            newZ = newZ + meanshiftVecZ;
            newX = newX + meanshiftVecX;
            newY = newY + meanshiftVecY;
        end
        
        % set the result of the mean shift as final color
        output(y,x) = round(newZ);
        modeX(y,x) = newX;
        modeY(y,x) = newY;
    end
end

subplot(2,2,2),imshow(output .* Hr); title('Meanshift Filtered');

% do the clustering
for y=1:ht
    for x=1:wd
        
        z = output(y,x);
        
        % check if the result can be combine into a existing cluster
        clusterFound = false;
        for ci=1:clusterSize
            cDifZ = single(clusterZ(ci) - z);
            cDifX = clusterX(ci) - modeX(y,x);
            cDifY = clusterY(ci) - modeY(y,x);
            
            cRDist = sqrt(cDifZ*cDifZ + cDifX*cDifX + cDifY*cDifY);
            if cRDist <= 0.5
                output(y,x,1) = clusterZ(ci) * Hr;
                
                % store membership id of cluster
                clusterMemberSize(ci) = clusterMemberSize(ci) + 1;
                clusterMember(ci,clusterMemberSize(ci), 1) = x;
                clusterMember(ci,clusterMemberSize(ci), 2) = y;
                
                clusterFound = true;
                break;
            end
        end
        
        if ~clusterFound
            % set the result of the mean shift as final color
            output(y,x) = z * Hr;
            
            clusterSize = clusterSize + 1;
            clusterZ(clusterSize) = z;
            clusterX(clusterSize) = modeX(y,x);
            clusterY(clusterSize) = modeY(y,x);
            
            % store membership id of cluster
            clusterMemberSize(clusterSize) = 1;
            clusterMember(clusterSize,1, 1) = x;
            clusterMember(clusterSize,clusterMemberSize(ci), 2) = y;
        end
    end
end

% merge the small cluster
for ci=1:clusterSize
    if(clusterMemberSize(ci) < M)
        z = clusterZ(ci);
        x = clusterX(ci);
        y = clusterY(ci);
        
        % find the nearest cluster and merge with it
        newCluster = ci;
        nearestDist = 100000;
        for ci2=1:clusterSize
            if(ci ~= ci2 && clusterMemberSize(c2) ~= 0)
                difZ = z - clusterZ(ci2);
                difX = x - clusterX(ci2);
                difY = y - clusterY(ci2);
                
                euclidean = sqrt(difZ*difZ + difX*difX + difY*difY);
                % this cluster is close by
                if(euclidean < nearestDist)
                    newCluster = ci2;
                    nearestDist = euclidean;
                end
            end
        end
        
        % found the new cluster to merge into
        for memberId=1 : clusterMemberSize(ci)
            memberX = clusterMember(ci, memberId, 1);
            memberY = clusterMember(ci, memberId, 2);
            
            if (memberX ~= 0 && memberY ~= 0)
                output(memberY,memberX,1) = clusterZ(newCluster) * Hr;
                
                % store membership id of cluster
                clusterMemberSize(newCluster) = clusterMemberSize(newCluster) + 1;
                clusterMember(newCluster,clusterMemberSize(newCluster), 1) = memberX;
                clusterMember(newCluster,clusterMemberSize(newCluster), 2) = memberY;
            end
        end
        
        % clear the old cluster
        clusterMemberSize(ci) = 0;
    end
end

    
fprintf('\n time taken for meanshift=%f \n',toc);

subplot(2,2,1),imshow(input); title('input image');
subplot(2,2,3),imshow(output); title('meanshift segmented image')

end