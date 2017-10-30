function output = MeanShiftSeg(input, Hs, Hr, M)

ht=size(input,1);
wd=size(input,2);
output=input;

% store the location of mode
size_ = ht * wd;
limit = 4048;
modeX = [size_];
modeY = [size_];

clusterR = [size_];
clusterG = [size_];
clusterB = [size_];
clusterX = [size_];
clusterY = [size_];

clusterSize = 0;
clusterMemberSize = [size_];
clusterMember = repmat(0, [limit*2 limit 2]);

figure(1);

fprintf('\n Starting meanshift');
tic

for y=1:ht
    for x=1:wd
        % normalize with Hs & Hr
        newX = round(single(x) / Hs);
        newY = round(single(y) / Hs);
        newR = round(single(input(y,x,1)) / Hr);
        newG = round(single(input(y,x,2)) / Hr);
        newB = round(single(input(y,x,3)) / Hr);

        windowSize = Hs;
        shiftX = x; % newX * Hs;
        shiftY = y; % newY * Hs;
        r1 = shiftY - windowSize; r2 = shiftY + windowSize;
        c1 = shiftX - windowSize; c2 = shiftX + windowSize;

        % check boundaries of the region
        if (r1<1) r1 = 1 ; end
        if (c1<1) c1 = 1 ; end
        if (r2>ht) r2 = ht ; end
        if (c2>wd) c2 = wd ; end 

        patch=input(r1:r2,c1:c2,:);
        
        dist = 1;
        while(dist > 0.2)
            withinCount = 0;
            accumulateR = 0; accumulateG = 0; accumulateB = 0;
            accumulateX = 0; accumulateY = 0;
            for li=1:size(patch,1)
                for lj=1:size(patch,2)
                    % normalize with Hs & Hr
                    yi = single(r1 + li - 1) / Hs;
                    xi = single(c1 + lj - 1) / Hs;
                    xiR = single(patch(li, lj, 1)) / Hr;
                    xiG = single(patch(li, lj, 2)) / Hr;
                    xiB = single(patch(li, lj, 3)) / Hr;

                    difR = newR - xiR; difG = newG - xiG; difB = newB -xiB;
                    difX = newX - xi; difY = newY - yi;

                    % Epanechnikov kernel derivative, basically only consider
                    % point in the hypersphere of radius bandwidth
                    euclideanR = sqrt(difX*difX + difY*difY + difR*difR);
                    euclideanS = sqrt(difG*difG + difB*difB);
                    if euclideanR < Hr && euclideanS < Hs
                        accumulateR = accumulateR + xiR;
                        accumulateG = accumulateG + xiG;
                        accumulateB = accumulateB + xiB;
                        accumulateX = accumulateX + xi;
                        accumulateY = accumulateY + yi;
                        withinCount = withinCount + 1;
                    end
                end
            end
            
            % get the mean of each channel
            meanR = accumulateR / withinCount;
            meanG = accumulateG / withinCount;
            meanB = accumulateB / withinCount;
            meanX = accumulateX / withinCount;
            meanY = accumulateY / withinCount;
            
            % mean shift vec = mean - currentX
            meanshiftVecR = meanR - newR;
            meanshiftVecG = meanG - newG;
            meanshiftVecB = meanB - newB;
            meanshiftVecX = meanX - newX;
            meanshiftVecY = meanY - newY;
            
            % compute the distance of the meanshift vec as terminating
            % condition
            dist = sqrt(meanshiftVecR*meanshiftVecR + meanshiftVecG*meanshiftVecG + meanshiftVecB*meanshiftVecB + meanshiftVecX*meanshiftVecX + meanshiftVecY*meanshiftVecY);
            
            % apply the mean shift vec
            newR = newR + meanshiftVecR;
            newG = newG + meanshiftVecG;
            newB = newB + meanshiftVecB;
            newX = newX + meanshiftVecX;
            newY = newY + meanshiftVecY;
        end
       
        % set the result of the mean shift as final color
        output(y,x,1) = round(newR);
        output(y,x,2) = round(newG);
        output(y,x,3) = round(newB);
        modeX(y,x) = newX;
        modeY(y,x) = newY;
    end    
end

subplot(2,2,2),imshow(output .* Hr); title('Meanshift Filtered');

% do the clustering 
for y=1:ht
    for x=1:wd
        
        r = output(y,x,1);
        g = output(y,x,2);
        b = output(y,x,3);
        
        % check if the result can be combine into a existing cluster
        clusterFound = false;
        for ci=1:clusterSize
            cDifR = single(clusterR(ci) - r);
            cDifG = single(clusterG(ci) - g);
            cDifB = single(clusterB(ci) - b);
            cDifX = clusterX(ci) - modeX(y,x);
            cDifY = clusterY(ci) - modeY(y,x);
            
            cRDist = sqrt(cDifR*cDifR + cDifG*cDifG + cDifB*cDifB + cDifX*cDifX + cDifY*cDifY);
            if cRDist <= 0.5 
                output(y,x,1) = clusterR(ci) * Hr;
                output(y,x,2) = clusterG(ci) * Hr;
                output(y,x,3) = clusterB(ci) * Hr;
                
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
            output(y,x,1) = r * Hr;
            output(y,x,2) = g * Hr;
            output(y,x,3) = b * Hr;
        
            clusterSize = clusterSize + 1;
            clusterR(clusterSize) = r;
            clusterG(clusterSize) = g;
            clusterB(clusterSize) = b;
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
        r = clusterR(ci);
        g = clusterG(ci);
        b = clusterB(ci);
        x = clusterX(ci);
        y = clusterY(ci);
        
        % find the nearest cluster and merge with it
        newCluster = ci;
        nearestDist = 100000;
        for ci2=1:clusterSize
            if(ci ~= ci2 && clusterMemberSize(c2) ~= 0)
                difR = r - clusterR(ci2);
                difG = g - clusterG(ci2);
                difB = b - clusterB(ci2);
                difX = x - clusterX(ci2);
                difY = y - clusterY(ci2);

                euclidean = sqrt(difR*difR + difG*difG + difB*difB + difX*difX + difY*difY);    
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
                output(memberY,memberX,1) = clusterR(newCluster) * Hr;
                output(memberY,memberX,2) = clusterG(newCluster) * Hr;
                output(memberY,memberX,3) = clusterB(newCluster) * Hr;
                
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

fprintf('\n time taken for meanshift=%f',toc);

subplot(2,2,1),imshow(input); title('input image');
subplot(2,2,3),imshow(output); title('meanshift segmented image')

end