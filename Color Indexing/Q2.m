clear;close all;clc;

%% To visualize similarity among training data sets
train_folder_name = '.\PP_Toys_03\Training';
% all files in training folder
filenames=dir(fullfile(train_folder_name,'*.jpg'));
filenames={filenames.name};
n_samples=numel(filenames);

%% Visualization of 3D and 2D plot
nbins3d = [16 8 16];
nbins2d = [8 8];
flag3d = 0;
flag2d = 1;

%% Basic Histogram Intersection
isPlot = false;
for i=1:n_samples 
    I = imread(fullfile(train_folder_name, num2str(cell2mat(filenames(i)))));
    [hist3d{i}, bin_3d] = histogram3d2d( I, nbins3d,flag3d, isPlot);
    [hist2d{i}, bin_2d] = histogram3d2d( I, nbins2d,flag2d, isPlot);
end
save('hist3d.mat', 'hist3d');
save('hist2d.mat', 'hist2d');

load('hist3d.mat');
nImg = numel(hist3d);
sResults3d = zeros(nImg, nImg);
for i= 1 : nImg
    for j=1 : nImg
        sResults3d(i,j) = HistIntersec_3D(hist3d{i}, hist3d{j});
    end
end
save('histResults3d.mat', 'sResults3d');

load('hist2d.mat');
nImg = numel(hist2d);
sResults2d = zeros(nImg, nImg);
for i= 1 : nImg
    for j=1 : nImg
        sResults2d(i,j) = HistIntersec(hist2d{i}, hist2d{j});
    end
end
save('histResults2d.mat', 'sResults2d');

% To plot histogram intersection results similar to Fig 7
ShowHistIntersectResults(sResults3d, 100);
ShowHistIntersectResults(sResults2d, 100);

%% Incremental Histogram Intersection
load('hist3d.mat');
nImg = numel(hist3d);
% off-line building of database

isPlot = false;
max_idx_hist = cell(1,75);
%inc_hist_model = cell(1,75);
for i= 1 : nImg
    [max_idx_hist{i}] = BuildHistIncrementIntersect(hist3d{i}, nbins3d);
end
save('max_idx_hist.mat','max_idx_hist');

%online matching of test image
load('max_idx_hist.mat');
maxBins = 10;
sMatch = zeros(nImg, nImg);
for i= 1 : nImg
    %% 1. Sort image histogram by bin size
    sorted_test_hist = SortedHistBySize(hist3d{i},'descend');
    %Specify # bin per index(color)
    color_bins = SetColorBins(maxBins, nbins3d);
    %% 2. Perform histogram matching
   sMatch(i,:) = MatchIncreHistIntersect(max_idx_hist, sorted_test_hist, color_bins);
end

ShowHistIntersectResults(sMatch, 100);