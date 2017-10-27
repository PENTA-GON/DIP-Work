clear; close all; clc;

%using 3d histogram
%M1:78 M2:10 M3:65 I:133
%M1:86 M2:93 M3:106 I:150
%M1:96 M2:14 M3:177 I:195
%M1:53 M2:63 M3:75 I:190
%M1:75 M2:53 M3:27 I:142

%invariant to angle of model image
%M1:34,36 M2:41,44 M3:92 I:164
%M1:59,69,75,77 M2:83 M3:100 I:147
%M1:0,1 M2:4,6 M3:28,29 I:129

M1 = imread('.\PP_Toys_03\Training\34.jpg');
M2 = imread('.\PP_Toys_03\Training\41.jpg');
M3 = imread('.\PP_Toys_03\Training\92.jpg');
I = imread('.\PP_Toys_03\TestScenes\164.jpg');

%{
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

%}

r = 100;
[x1,y1] = HistBackProj( M1, I, r);
[x2,y2] = HistBackProj( M2, I, r);
[x3,y3] = HistBackProj( M3, I, r);
