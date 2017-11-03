%clear;close all;clc;

%% Q1.preparate the dataset
%%{
addpath('DataSet(Paper3)');
train_sift_dir = './DataSet(Paper3)/bike-train-test-sift/train';
test_sift_dir = './DataSet(Paper3)/bike-train-test-sift/test';
train_img_dir = './DataSet(Paper3)/bike-train-test-img/train';
test_img_dir = './DataSet(Paper3)/bike-train-test-img/test';

%Display SIFT features
%display_features(fullfile(train_sift_dir, 'bike_005.sift'), fullfile(train_img_dir, 'bike_001.bmp'), 0,0);

%training dataset
train_filenames = dir(fullfile(train_sift_dir,'*.sift'));
train_filenames = {train_filenames.name};
train_n_samples = numel(train_filenames);

%testing dataset
test_filenames = dir(fullfile(test_sift_dir,'*.sift'));
test_filenames = {test_filenames.name};
test_n_samples = numel(test_filenames);

nb_new = 100; %number of chosen features
%

train_data = featSelect(fullfile(train_sift_dir, num2str(cell2mat(train_filenames(1)))),nb_new);
test_data = featSelect(fullfile(test_sift_dir, num2str(cell2mat(test_filenames(1)))),nb_new);
%
%{
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
%}
%% Q2.k-means clustering
%
%{
load('train_data128.mat', 'train_data');
load('test_data128.mat', 'test_data');



tic;
k = 200;
[train_counts, train_aver, train_record] = k_means( train_data,k );
toc;

%test the accuracy of k-mean 
%
%{
a = test_data(:,test_record{1});
b = mean(a,2);
error = sum(test_aver(:,1)-b);
%}

%}
%% Q3.Calculate the histogram of visual tokens
%img = test_data(:,1:100); %1st test image
%featHist = featureHist( img, train_aver,k, true);
%create features histogram of visual tokens for training images
%
%{
test_n_samples = 100;
train_n_samples = 200;
start_idx = 1;
for i=1:train_n_samples 
    img = train_data(:, start_idx : 100*i);
    trainHist{i} = featureHist( img, train_aver,k, false);
    start_idx = 100*i + 1;    
end
%create features histogram of visual tokens for testing images
start_idx = 1;
for j=1:test_n_samples
    img = test_data(:, start_idx : 100*j);
    testHist{j} = featureHist( img, train_aver,k, false);
    start_idx = 100*j + 1; 
end
save('trainHist128.mat', 'trainHist');
save('testHist128.mat', 'testHist');
%}
%% Q4.Image retrieval
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
load('testHist128.mat');
load('trainHist128.mat');

match_img_comp = cell(3,1); %To compare performance using different distance metrics

for iTest=1 : test_n_samples
   for iTrain=1 : train_n_samples
       simIndx{iTest, iTrain} = ChiSqDistance( testHist{iTest}, trainHist{iTrain});
   end   
   [chisq, idx] = sort([simIndx{iTest,:}]);%'ascend'
   match_img_idx(iTest,:) = idx(1:max_match);
   match_img_dist(iTest,:) = chisq(1:max_match);   
end
match_img_comp{1}.name = 'chi-square';
match_img_comp{1}.idx = match_img_idx;
match_img_comp{1}.dist = match_img_dist;

per_class_stats = [];
tot_ConMat = zeros(numel(class_id));%confusion matrix for 3 classes
%% Evaluate image retrieval performance using confusion matrix
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
%Disply top 20 matched training images per test image
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
    
