clear;close all;clc;

% Read 2 images
I_A = imread('77.jpg');
I_B = imread('75.jpg');

%% using 1D histogram intersection on  RGB color space
%{
nbins = 50;
figure;
for iColor = 1 : 3
    [hist_A, bin_A] = imhist(I_A(:,:,iColor), nbins);
    [hist_B, bin_B] = imhist(I_B(:,:,iColor), nbins);

    subplot(3,2,iColor+(iColor-1));
    plot(bin_A, hist_A, 'r-'); 
    hold on;
    plot(bin_B, hist_B, 'g-');
    grid on; legend('image-A','image-B');
    %simple metric for testing similiarity
    k(iColor) = HistIntersec_1D(hist_A, hist_B);
end
%}
%% using 1D histogram intersection on opponent color spaces
%{
[rg, by, wb] = rgb2opp(I_A);
[hist_rg_A, bin_rg_A] = imhist(rg, nbins);
[hist_by_A, bin_by_A] = imhist(by, nbins);
[hist_wb_A, bin_wb_A] = imhist(wb, nbins);
[rg, by, wb] = rgb2opp(I_B);
[hist_rg_B, bin_rg_B] = imhist(rg, nbins);
[hist_by_B, bin_by_B] = imhist(by, nbins);
[hist_wb_B, bin_wb_B] = imhist(wb, nbins);
%figure;
subplot(322),plot(bin_rg_A, hist_rg_A, 'r-'); hold on;plot(bin_rg_B, hist_rg_B, 'g-');
grid on; legend('image-A','image-B');
subplot(324),plot(bin_by_A, hist_by_A, 'r-'); hold on;plot(bin_by_B, hist_by_B, 'g-');
grid on; legend('image-A','image-B');
subplot(326),plot(bin_wb_A, hist_wb_A, 'r-'); hold on;plot(bin_wb_B, hist_wb_B, 'g-');
grid on; legend('image-A','image-B');
%}
%% Using 3d histogram intersection on three opponent color axes
%{
nbins = [16 8 16];
flag = 0;
%convert image into 3D histogram
figure;
isPlot = true;
n_A = histogram3d2d( I_A, nbins,flag, isPlot);
figure;
n_B = histogram3d2d( I_B, nbins,flag, isPlot);
%perform histogram intersection
[x,y,z, sValue] = HistIntersec_3D(n_A, n_B);
%mean of similiarity index using histogram intersection
sValue = mean([mean(x) mean(y) mean(z)]);
%}
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
%{
figure;
for i=1:n_samples    
    I = imread(fullfile(train_folder_name, num2str(cell2mat(filenames(i)))));
    subplot(121), imshow(I);
    %3D histogram
    subplot(122), histogram3d2d( I, nbins3d,flag3d, true);
    %2D histogram
    pause;
end
%}

%% Basic Histogram Intersection
%{
isPlot = false;
for i=1:n_samples 
    I = imread(fullfile(train_folder_name, num2str(cell2mat(filenames(i)))));
    hist3d{i} = histogram3d2d( I, nbins3d,flag3d, isPlot);
    hist2d{i} = histogram3d2d( I, nbins2d,flag2d, isPlot);
end
save('hist3d.mat', 'hist3d');
save('hist2d.mat', 'hist2d');
%}
%{
load('hist3d.mat');
nImg = numel(hist3d);
for i= 1 : nImg
    for j=1 : nImg
        sResults(i,j) = HistIntersec(hist3d{i}, hist3d{j});
    end
end

save('histResults3d.mat', 'sResults');

load('hist2d.mat');
nImg = numel(hist2d);
for i= 1 : nImg
    for j=1 : nImg
        sResults(i,j) = HistIntersec(hist2d{i}, hist2d{j});
    end
end
save('histResults2d.mat', 'sResults');

% To plot histogram intersection results similar to Fig 7

%% Incremental Histogram Intersection
load('hist3d.mat');
nImg = numel(hist3d);
% off-line building of database

isPlot = false;
max_idx_hist = cell(1,75);
inc_hist_model = cell(1,75);
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