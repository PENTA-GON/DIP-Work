clear; close all; clc;

%using 3d histogram
%M1:78 M2:92 M3:65 I:133
%M1:86 M2:93 M3:106 I:150
%M1:96 M2:14 M3:177 I:195
%M1:53 M2:63 M3:75 I:190
%M1:75 M2:53 M3:27 I:142
%M1:36 M2:44 M3:92 I:164
%M1:69 M2:83 M3:100 I:147
%M1:0,1(error) M2:4,6(error) M3:28 I:129

%using 2d histogram
%M1:96 M2:14 M3:177 I:195
%M1:34 M2:44 M3:92 I:164

%M1:78(error) M2:92 M3:65 I:133
%M1:53 M2:63(error) M3:75 I:190 #nbins
%M1:86 M2:93 M3:106(error) I:150
%M1:75(error) M2:53 M3:27 I:142
%M1:69 M2:83(error) M3:100(error) I:147
%M1:0,1 M2:4,6(error) M3:28 I:129
M1 = imread('.\PP_Toys_03\Training\69.jpg');
M2 = imread('.\PP_Toys_03\Training\83.jpg');
M3 = imread('.\PP_Toys_03\Training\171.jpg');
I = imread('.\PP_Toys_03\TestScenes\147.jpg');

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
