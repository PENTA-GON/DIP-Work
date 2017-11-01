%clear;close all;clc;

%% Q1.preparate the dataset
%%{
addpath('DataSet(Paper3)');
train_sift_dir = './DataSet(Paper3)/bike-train-test-sift/train';
test_sift_dir = './DataSet(Paper3)/bike-train-test-sift/test';
train_img_dir = './DataSet(Paper3)/bike-train-test-img/train';
test_img_dir = './DataSet(Paper3)/bike-train-test-img/test';

%Display SIFT features
%display_features(fullfile(train_sift_dir, 'bike_001.sift'), fullfile(train_img_dir, 'bike_001.bmp'), 0,0);

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
%{
train_data = featSelect(fullfile(train_sift_dir, num2str(cell2mat(train_filenames(1)))),nb_new);
test_data = featSelect(fullfile(test_sift_dir, num2str(cell2mat(test_filenames(1)))),nb_new);

for i=2:train_n_samples 
    train_feat = featSelect(fullfile(train_sift_dir, num2str(cell2mat(train_filenames(i)))),nb_new);
    train_data = [train_data, train_feat];
end
for i=2:test_n_samples   
    test_feat = featSelect(fullfile(test_sift_dir, num2str(cell2mat(test_filenames(i)))),nb_new);
    test_data = [test_data, test_feat];
end
save('train_data200.mat', 'train_data');
save('test_data200.mat', 'test_data');
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
%%{
train_n_samples = 200;
test_n_samples = 100;
max_match = 20; %top 20 matches out of available training images
simIndx = zeros(test_n_samples, train_n_samples);
match_img_idx = zeros(test_n_samples, max_match);
match_img_dist= zeros(test_n_samples, max_match);
load('testHist128.mat');
load('trainHist128.mat');
for iTest=1 : test_n_samples
   for iTrain=1 : train_n_samples
       simIndx(iTest, iTrain) = ChiSqDistance( testHist{iTest}, trainHist{iTrain});
   end
   [chisq, idx] = sort(simIndx(iTest,:), 'descend');
   match_img_idx(iTest,:) = idx(1:max_match);
   match_img_dist(iTest,:) = chisq(1:max_match);
end

%Disply top 20 matched training images per test image
train_filenames = dir(fullfile(train_img_dir,'*.bmp'));
train_img = {train_filenames.name};
test_filenames = dir(fullfile(test_img_dir,'*.bmp'));
test_img = {test_filenames.name};
figure('units','normalized','outerposition',[0 0 1 1]);
for iTest=1 : numel(test_img)
    rnd_img = datasample([1:1:numel(test_img)],1,'Replace',false);
    M = fullfile(test_img_dir, test_img{rnd_img});
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
    
