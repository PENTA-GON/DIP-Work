clear;close all;clc;

%% Q1.preparate the dataset
%
%{
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

save('train_data.mat', 'train_data');
save('test_data.mat', 'test_data');
%}
%% Q2.k-means clustering
%%{
load('train_data.mat', 'train_data');
load('test_data.mat', 'test_data');

k = 200;
[train_counts, train_aver, train_record] = k_means( train_data,k );

%test the accuracy of k-mean 
%{
a = test_data(:,test_record{1});
b = mean(a,2);
error = sum(test_aver(:,1)-b);
%}

%}
%% Q3.Calculate the histogram of visual tokens

img = test_data(:,1:100);
featHist = featureHist( img, train_aver,k);

%% Q4.Image retrieval


    
