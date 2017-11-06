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
         %sumHist = normTrain + normTest;
         %D = sum( diff(:) / normTrain(:));
         %D = 0.5 * sum(diff(:)/sumHist(:));
         
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
    
	%Pair-wise Chi-sq distance
	elseif(measMethod == 5)			
			m = size(trainHist,1);  n = size(testHist,1);
			mOnes = ones(1,m); D = zeros(m,n);
			for i=1:n
			  yi = testHist(i,:);  yiRep = yi( mOnes, : );
			  s = yiRep + trainHist;    d = yiRep - trainHist;
			  D(:,i) = sum( d.^2 ./ (s+eps), 2 );
			end
			D = D/2;	
    end

end