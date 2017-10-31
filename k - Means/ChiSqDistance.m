function [D] = ChiSqDistance( testHist, trainHist )
    %normalize histogram
    normTest = (testHist - min(testHist))/(max(testHist) - min(testHist));
    normTrain = (trainHist - min(trainHist))/(max(trainHist) - min(trainHist));
    %compute distance
    diff = (normTrain - normTest).^2;
    D = sum( diff(:)) / sum(normTrain(:));
end