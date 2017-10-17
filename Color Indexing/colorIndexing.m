clear; close all; clc;


<<<<<<< HEAD
I = imread('77.jpg');
=======
I = imread('.\Training\38.jpg');

figure('NumberTitle', 'off', 'Name', '3D and 2D color histogram');
set(gcf, 'position', [100 100 1200 500]);
>>>>>>> 66a570cd2da637108aac93e5faf1b28461ff107e

% 3D histogram
nbins = [16 8 16];
flag = 0;
nbins3d = [16 8 16];
flag3d = 0;
subplot(1,2,1),histogram3d2d( I, nbins3d,flag3d);

% 2D histogram 
% nbins = [8 8];
% flag = 1;
=======
nbins2d = [8 8];
flag2d = 1;
subplot(1,2,2),histogram3d2d( I, nbins2d,flag2d);

>>>>>>> 66a570cd2da637108aac93e5faf1b28461ff107e

histogram3d2d( I, nbins,flag);

