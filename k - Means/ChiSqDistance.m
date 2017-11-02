function [D] = ChiSqDistance( testHist, trainHist )


    %% Chi-sq measurement
   %{
    %normalize histogram
    normTest = (testHist - min(testHist))/(max(testHist) - min(testHist));
    normTrain = (trainHist - min(trainHist))/(max(trainHist) - min(trainHist));
    %compute distance
    diff = (normTrain - normTest).^2;
    D = sum( diff(:)) / sum(normTrain(:));
   %}

    %% vector measurement
    %%{
    dotprod = sum(testHist .* trainHist);
    dis = sqrt(sum(testHist.^2))*sqrt(sum(trainHist.^2));
    cosin = dotprod/dis;
    D = cosin;
   %}

    %% histogram intersection
    %{
    min_hist = min(testHist,trainHist);
    D = sum(min_hist(:)) / sum(testHist(:));
    %}

end