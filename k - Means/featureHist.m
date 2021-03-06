function [ featHist ] = featureHist( img, train_aver,k, isPlot)
%calculate the histogram of visual tokens for an image

featHist = zeros(k,1);

for i = 1:size(img,2)
    %assign min distance 
    min = distance(img(:,i),train_aver(:,1),1);
    min_ind = 1;
    %Find min distance compared with other cluster centroids
    for j = 2:k
        dis = distance(img(:,i),train_aver(:,j),1);
        if(dis < min)
            min = dis;
            min_ind = j;
        end
    end 
    %Build features histogram of specified no of visual tokens
    featHist(min_ind) = featHist(min_ind) + 1;
end

%Plotting of Histogram
if isPlot
    figure;
    set(gcf, 'Name', 'Histogram of visual tokens');
    title('Histogram of visual tokens');

    bar(featHist);
    axis([0 200 0 inf])
    xlabel('Visual token vocabulary[1,200]');
    ylabel('Frequency');
end

end

