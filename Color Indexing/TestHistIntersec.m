clear;close all;clc;

flag = 0;

I_A = imread('77.jpg');
I_B = imread('104.jpg');

%% using 1D histogram intersection on separate RGB pixels
nbins = 50;
figure;
for iColor = 1 : 3
    [hist_A, bin_A] = imhist(I_A(:,:,iColor), nbins);
    [hist_B, bin_B] = imhist(I_B(:,:,iColor), nbins);

    subplot(3,1,iColor);
    plot(bin_A, hist_A, 'r-');
    hold on;
    plot(bin_B, hist_B, 'g-');
    %hold off;
    grid on;
    %simple metric for testing similiarity
    k(iColor) = HistIntersec_1D(hist_A, hist_B);
end
%% Using 3d histogram intersection on three opponent color axes
nbins = [16 8 16];
flag = 0;
%convert image into 3D histogram
n_A = histogram3d2d( I_A, nbins,flag);
n_B = histogram3d2d( I_B, nbins,flag);
%perform histogram intersection
[x,y,z] = HistIntersec_3D(n_A, n_B);
%mean of similiarity index using histogram intersection
sValue = mean([mean(x) mean(y) mean(z)]);
