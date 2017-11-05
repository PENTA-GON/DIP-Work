function [D] = distance( testHist, trainHist, measMethod)

    % Euclidean Distance
    if(measMethod == 1)
        results = (testHist-trainHist).^2;
        D = sum(results);
        
    % Chi-sq measurement     
    elseif(measMethod == 2)
        %normalize histogram
         normTest = (testHist - min(testHist))/(max(testHist) - min(testHist));
         normTrain = (trainHist - min(trainHist))/(max(trainHist) - min(trainHist));
         %compute distance
         diff = (normTrain - normTest).^2;
         D = sum( diff(:)) / sum(normTrain(:));
         
    % Cosine distance     
    elseif(measMethod == 3)
         dotprod = sum(testHist .* trainHist);
         dis = sqrt(sum(testHist.^2))*sqrt(sum(trainHist.^2));
         cosin = dotprod/dis; 
         %D: 0 -- angle: 90
         %D: -1 -- angle: 0
         D = - cosin;
         
    % Histogram intersection
    elseif(measMethod == 4)
        min_hist = min(testHist,trainHist);
        D = 1 -(sum(min_hist(:)) / sum(testHist(:)));
        
    end

end