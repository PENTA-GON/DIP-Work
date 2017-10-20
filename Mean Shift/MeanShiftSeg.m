function output = MeanShiftSeg(input, Hs, Hr, Bandwidth)

ht=size(input,1);
wd=size(input,2);
output=input;

% store the location of mode
modeX = [ht * wd];
modeY = [ht * wd];

clusterR = [ht * wd];
clusterG = [ht * wd];
clusterB = [ht * wd];
clusterX = [ht * wd];
clusterY = [ht * wd];
clusterSize = 0;

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

        windowSize = 10;
        r1 = y - windowSize; r2 = y + windowSize;
        c1 = x - windowSize; c2 = x + windowSize;

        % check boundaries of the region
        if (r1<1) r1 = 1 ; end
        if (c1<1) c1 = 1 ; end
        if (r2>ht) r2 = ht ; end
        if (c2>wd) c2 = wd ; end 

        patch=input(r1:r2,c1:c2,:);

        dist = 1;
        while(dist > 0.5)
            withinCount = 0;
            accumulateR = 0; accumulateG = 0; accumulateB = 0;
            accumulateX = 0; accumulateY = 0;
            for li=1:size(patch,1)
                for lj=1:size(patch,2)
                    
                    yi = single(r1 + li - 1) / Hs;
                    xi = single(c1 + lj - 1) / Hs;
                    xiR = single(patch(li, lj, 1)) / Hr;
                    xiG = single(patch(li, lj, 2)) / Hr;
                    xiB = single(patch(li, lj, 3)) / Hr;

                    difR = newR - xiR; difG = newG - xiG; difB = newB -xiB;
                    difX = newX - xi; difY = newY - yi;

                    % Epanechnikov kernel derivative, basically only consider
                    % point in the hypersphere of radius bandwidth
                    euclidean = sqrt(difX*difX + difY*difY + difR*difR + difG*difG + difB*difB);
                    if euclidean < Hs
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
        end
    end
end

fprintf('\n time taken for meanshift=%f',toc);

subplot(2,2,1),imshow(input); title('input image');
subplot(2,2,3),imshow(output); title('meanshift segmented image')

end