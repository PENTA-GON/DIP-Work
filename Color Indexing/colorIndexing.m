clear; close all; clc;

I = imread('.\PP_Toys_03\Training\38.jpg');

figure;imshow(I);

figure('NumberTitle', 'off', 'Name', '3D and 2D color histogram');
set(gcf, 'position', [100 100 1200 500]);

isPlot = true;
% 3D histogram
nbins3d = [16 8 16];
flag3d = 0;
subplot(1,2,1),histogram3d2d( I, nbins3d,flag3d,isPlot);

% 2D histogram 
nbins2d = [8 8];
flag2d = 1;
subplot(1,2,2),histogram3d2d( I, nbins2d,flag2d,isPlot);