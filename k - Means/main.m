%% Q1.preparate the dataset
%
%{
clear;close all;clc;
addpath('DataSet(Paper3)');
train_sift_dir = './DataSet(Paper3)/bike-train-test-sift/train';
test_sift_dir = './DataSet(Paper3)/bike-train-test-sift/test';
train_img_dir = './DataSet(Paper3)/bike-train-test-img/train';
test_img_dir = './DataSet(Paper3)/bike-train-test-img/test';
%training dataset
train_filenames = dir(fullfile(train_sift_dir,'*.sift'));
train_filenames = {train_filenames.name};
train_n_samples = numel(train_filenames);
%testing dataset
test_filenames = dir(fullfile(test_sift_dir,'*.sift'));
test_filenames = {test_filenames.name};
test_n_samples = numel(test_filenames);
%Display SIFT features
for i=1 %: train_n_samples
    names = strsplit(char(train_filenames(i)),'.');
    display_features(char(fullfile(train_sift_dir, train_filenames(i))), char(fullfile(train_img_dir, strcat(names(1),'.bmp'))), 0,0);
    %pause;
end
nb_new = 100; %number of chosen features
train_data = featSelect(fullfile(train_sift_dir, num2str(cell2mat(train_filenames(1)))),nb_new);
test_data = featSelect(fullfile(test_sift_dir, num2str(cell2mat(test_filenames(1)))),nb_new);
%%{
for i=2:train_n_samples 
    train_feat = featSelect(fullfile(train_sift_dir, num2str(cell2mat(train_filenames(i)))),nb_new);
    train_data = [train_data, train_feat];
end
for i=2:test_n_samples   
    test_feat = featSelect(fullfile(test_sift_dir, num2str(cell2mat(test_filenames(i)))),nb_new);
    test_data = [test_data, test_feat];
end
save('train_data128.mat', 'train_data');
save('test_data128.mat', 'test_data');

return;
%}
%% Q2.k-means clustering
%
%{
clear;close all;clc;

load('train_data128.mat', 'train_data');
load('test_data128.mat', 'test_data');

k = 200;
tStart(1) = tic;
%best performance results with this clustering though 15 iterations
[train_counts, train_aver, train_record] = k_means( train_data,k );
tStop(1) = toc(tStart(1));

%medium performance results with no specified no of iterations; longer
convergence time
% tStart(2) = tic;
% [train_aver_2] = kMeansCluster(train_data', k);
% tStop(2) = toc(tStart(2));

% Best convergence time but poor results 
% tStart(3) = tic;
% [clusters, train_aver_3] = kmeans(train_data', k);
% tStop(3) = toc(tStart(3));
% train_aver_3 = train_aver_3';
% save('RunningTime_clustering.mat', 'tStop');

 save('train_aver.mat','train_aver');
% save('train_aver_2.mat','train_aver_2');
% save('train_aver_3.mat','train_aver_3');

return;
%}
%% Q3.Calculate the histogram of visual tokens
% Using cluster centroids from 3 different implementations
%
%{
clear;close all;clc;
k=200;
load('train_data128.mat');
load('test_data128.mat');
load('train_aver.mat');
load('train_aver_2.mat');
load('train_aver_3.mat');

test_n_samples = 100;
train_n_samples = 200;

clusters{1} = train_aver;
clusters{2} = train_aver_2;
clusters{3} = train_aver_3;
save_train_str = {'trainHist128_1.mat','trainHist128_2.mat','trainHist128_2.mat'};
save_test_str = {'testHist128_1.mat','testHist128_2.mat','testHist128_2.mat'};
for iCluster=1% : 3 %Only using the best clustering; Option to run all 3 cluster results
    start_idx = 1;
    for i=1:train_n_samples 
        img = train_data(:, start_idx : 100*i);
        if i == 1
            trainHist{i} = featureHist( img, clusters{iCluster},k, true);
        else
            trainHist{i} = featureHist( img, clusters{iCluster},k, false);
        end
        start_idx = 100*i + 1;    
    end
    %create features histogram of visual tokens for testing images
    start_idx = 1;
    for j=1:test_n_samples
        img = test_data(:, start_idx : 100*j);
        if j==1
            testHist{j} = featureHist( img, clusters{iCluster},k, true);
        else
            testHist{j} = featureHist( img, clusters{iCluster},k, false);
        end
        start_idx = 100*j + 1; 
    end
    save(save_train_str{iCluster}, 'trainHist');
    save(save_test_str{iCluster}, 'testHist');
end
return;
%}
%% Q4.Image retrieval
%%{
close all;clear;clc;
%load train and test image histogram
% Only using 15 iterations cluster (Best result)
load('testHist128_1.mat');
load('trainHist128_1.mat');

train_img_dir = './DataSet(Paper3)/bike-train-test-img/train';
test_img_dir = './DataSet(Paper3)/bike-train-test-img/test';
train_filenames = dir(fullfile(train_img_dir,'*.bmp'));
train_img = {train_filenames.name};
test_filenames = dir(fullfile(test_img_dir,'*.bmp'));
test_img = {test_filenames.name};
%define classes: 
class_id = [1, 2, 3]; %bike, person, background
class_label = {'bike', 'person','background'};
%training image class id groundtruth
train_class_gth = zeros(1, numel(train_img));
for i = 1 : numel(train_img)
   for j=1 : numel(class_label)-1
       if ~isempty( strfind(train_img{i}, class_label{j}))
            if strfind(train_img{i},class_label{j}) == 1
                train_class_gth(i) = class_id(j);
                break;
            else %background image
                train_class_gth(i) = 3;
            end
       end
   end
end
%testing image class id groundtruth
test_class_gth = zeros(1, numel(test_img));
for i = 1 : numel(test_img)
    for j=1 : numel(class_label)-1
         if ~isempty( strfind(test_img{i}, class_label{j}))
            if strfind(test_img{i},class_label{j}) == 1
                test_class_gth(i) = class_id(j);
                break;
            else %background image
                test_class_gth(i) = 3;
            end
        end
    end
end
%%{
train_n_samples = 200;
test_n_samples = 100;
max_match = 20; %top 20 matches out of available training images
simIndx = cell(test_n_samples, train_n_samples);
match_img_idx = zeros(test_n_samples, max_match);
match_img_dist= zeros(test_n_samples, max_match);

tDistMeasures = 5;
distPerfComp = [];
match_img_comp = cell(tDistMeasures,1);
for iDist=1 : tDistMeasures
     %To compare performance using different distance metrics
    for iTest=1 : test_n_samples
       for iTrain=1 : train_n_samples
           %1 -- Euclidean Distance
           %2 -- Chi-sq measurement
           %3 -- Cosine distance
           %4 -- Histogram intersection
           %5 -- Pair-wise Chi-square distance
           if iDist == 5
               dist = distance( testHist{iTest}, trainHist{iTrain},iDist);
               simIndx{iTest, iTrain} = sum(dist(:))/numel(dist(dist(:) == 0));
           else
               simIndx{iTest, iTrain} = distance( testHist{iTest}, trainHist{iTrain},iDist);
           end
       end  
       [chisq, idx] = sort([simIndx{iTest,:}]);%'ascend'
       match_img_idx(iTest,:) = idx(1:max_match);
       match_img_dist(iTest,:) = chisq(1:max_match);      
    end
%     match_img_comp{1}.name = 'chi-square';
    match_img_comp{iDist}.idx = match_img_idx;
    match_img_comp{iDist}.dist = match_img_dist;

    per_class_stats = [];
    tot_ConMat = zeros(numel(class_id));%confusion matrix for 3 classes
    %% Q-4 Extension. Evaluate image retrieval performance using confusion matrix
    for iTest=1 : test_n_samples
        test_img_gth = repmat(test_class_gth(iTest), 1, max_match);
        pred_res = train_class_gth(match_img_idx(iTest,:));
        ConfusionMat = confusionmat(test_img_gth, pred_res, 'order', class_id);
        [acc, sen, spec, rec, pre, fscore] = computePerformanceStats(test_class_gth(iTest), ConfusionMat);
        %assign to output statistics only using the test img class
        per_class_stats(iTest).Class = test_class_gth(iTest); %class id: 1,2,3
        per_class_stats(iTest).ConMat = ConfusionMat;
        per_class_stats(iTest).Accuracy = acc;
        per_class_stats(iTest).Sensitivity = sen;
        per_class_stats(iTest).Specificity = spec;    
        per_class_stats(iTest).Recall = rec; 
        per_class_stats(iTest).Precision = pre;
        per_class_stats(iTest).Fscore = fscore;
        tot_ConMat = tot_ConMat + ConfusionMat;
    end
    %Compute multi-classes performance statistics
    t_class_stats = [];
    for iClass=1 : numel(class_id)
        [Accuracy(iClass), Sensitivity(iClass), ...
         Specificity(iClass), Recall(iClass), ...
         Precision(iClass), Fscore(iClass) ] = computePerformanceStats(iClass, tot_ConMat); 
    end
    Accuracy= Accuracy.*[1 0.5 0.5]; %scaling over class imbalance
    t_class_stats.Accuracy = Accuracy;
    t_class_stats.Sensitivity = Sensitivity;
    t_class_stats.Specificity = Specificity;
    t_class_stats.Recall = Recall;
    t_class_stats.Precision = Precision;
    t_class_stats.Fscore = Fscore;
    %save performance
    distPerfComp(iDist).t_class_stats = t_class_stats;
    distPerfComp(iDist).per_class_stats = per_class_stats;
end
save('distPerfComparison_1.mat', 'distPerfComp');
figure;
for i=1 : 5
    acc(i,1:3) = distPerfComp(i).t_class_stats.Accuracy;
end
bar(acc);
title('Accuracy Comparison');
xlabel('Distance Measures');
legend('bike','person','background');
set(gca,'xticklabels',{'Euclidean','Chi-sq','Cosine','HistIntersect','Pair-wise Chi-sq'});
figure;
for i=1 : 5
    fscore(i,1:3) = distPerfComp(i).t_class_stats.Fscore;
end
bar(fscore);
title('F-Score Measure Comparison');
xlabel('Distance Measures');
legend('bike','person','background');
set(gca,'xticklabels',{'Euclidean','Chi-sq','Cosine','HistIntersect','Pair-wise Chi-sq'});

%Choose the Best result to display 
[v,i] = sort(mean(fscore,2),'descend');
match_img_idx = match_img_comp{i(1)}.idx;
Accuracy = distPerfComp(i(1)).t_class_stats.Accuracy;
Sensitivity= distPerfComp(i(1)).t_class_stats.Sensitivity;
Specificity= distPerfComp(i(1)).t_class_stats.Specificity;
Precision= distPerfComp(i(1)).t_class_stats.Precision;
Recall= distPerfComp(i(1)).t_class_stats.Recall;
Fscore= distPerfComp(i(1)).t_class_stats.Fscore;
per_class_stats = distPerfComp(i(1)).per_class_stats;
%Display top 20 matched training images per test image
figure('units','normalized','outerposition',[0 0 1 1]);
for iTest=1 : numel(test_img)    
    rnd_img = datasample([1:1:numel(test_img)],1,'Replace',false);
    M = fullfile(test_img_dir, test_img{rnd_img});
    disp(rnd_img);
    %Display overll class retrieval performance statistics (tot_ConMat)
    clf;
    h1 = subplot(5,5,1);
    xl = xlim(h1); 
    xPos = xl(1) + diff(xl) / 2; 
    yl = ylim(h1); 
    yPos = yl(1) + diff(yl) / 2; 
    t = text(xPos, yPos, sprintf('Overall Class ''%s'' Performance\nAccuracy: %.2f\nSensitivity: %.2f\nSpecificity: %.2f', ... 
        char(class_label(test_class_gth(rnd_img))), Accuracy(test_class_gth(rnd_img)), ...
        Sensitivity(test_class_gth(rnd_img)), Specificity(test_class_gth(rnd_img))), ...
        'Parent', h1);
    set(t, 'HorizontalAlignment', 'center'); axis off;
    h2 = subplot(5,5,2);
    xl = xlim(h2); 
    xPos = xl(1) + diff(xl) / 2; 
    yl = ylim(h2); 
    yPos = yl(1) + diff(yl) / 2; 
    t = text(xPos, yPos, sprintf('Precision: %.2f\nRecall: %.2f\nF-score: %.2f', ... 
        Precision(test_class_gth(rnd_img)), ...
        Recall(test_class_gth(rnd_img)), Fscore(test_class_gth(rnd_img))), ...
        'Parent', h2);
    set(t, 'HorizontalAlignment', 'center'); axis off;
    %Display per img retrieval performance statistics (ConMat)
    h3 = subplot(5,5,4);
    xl = xlim(h3); 
    xPos = xl(1) + diff(xl) / 2; 
    yl = ylim(h3); 
    yPos = yl(1) + diff(yl) / 2; 
     t = text(xPos, yPos, sprintf('Per Image Performance\nAccuracy: %.2f\nSensitivity: %.2f\nSpecificity: %.2f', ... 
        per_class_stats(rnd_img).Accuracy, ...
        per_class_stats(rnd_img).Sensitivity, per_class_stats(rnd_img).Specificity), ...
        'Parent', h3);
    set(t, 'HorizontalAlignment', 'center'); axis off;
    h4 = subplot(5,5,5);
     xl = xlim(h4); 
    xPos = xl(1) + diff(xl) / 2; 
    yl = ylim(h4); 
    yPos = yl(1) + diff(yl) / 2; 
     t = text(xPos, yPos, sprintf('Precision: %.2f\nRecall: %.2f\nF-score: %.2f', ... 
        per_class_stats(rnd_img).Precision, ...
        per_class_stats(rnd_img).Recall, per_class_stats(rnd_img).Fscore), ...
        'Parent', h4);
    set(t, 'HorizontalAlignment', 'center'); axis off;   
        
    subplot(5,5,3), imshow(M); title(strcat('Test Image: ',test_img{rnd_img}), 'Interpreter', 'none');
    iPlot = 6;
    for j=1 : max_match
        I = fullfile(train_img_dir, train_img{match_img_idx(rnd_img,j)});
        D = sprintf('%.2f', match_img_dist(rnd_img,j));
        subplot(5,5,iPlot), imshow(I);title(strcat(train_img{match_img_idx(rnd_img,j)},'(',num2str(D),')'), 'Interpreter', 'none');
        iPlot = iPlot+1;
    end
    set(gcf, 'NumberTitle', 'off');
    set(gcf, 'Name', 'Press Any Key to Show next Figure');
    pause;
end
%}
    
