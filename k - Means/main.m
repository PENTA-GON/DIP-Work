clear;close all;clc;

addpath('DataSet(Paper3)');

train_sift_dir = './DataSet(Paper3)/bike-train-test-sift/train';
test_sift_dir = './DataSet(Paper3)/bike-train-test-sift/test';

train_img_dir = './DataSet(Paper3)/bike-train-test-img/train';
test_img_dir = './DataSet(Paper3)/bike-train-test-img/test';

%Display SIFT features
display_features(fullfile(train_sift_dir, 'bike_001.sift'), fullfile(train_img_dir, 'bike_001.bmp'), 0,0);