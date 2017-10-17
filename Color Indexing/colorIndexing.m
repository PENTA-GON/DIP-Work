clear; close all; clc;


I = imread('77.jpg');

% 3D histogram
nbins = [16 8 16];
flag = 0;

% 2D histogram 
% nbins = [8 8];
% flag = 1;

histogram3d2d( I, nbins,flag);

