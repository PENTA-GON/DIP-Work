clear, close all;

%I = imread('mit.png');
I = imread('cameraman.png');
%I = imread('Monkey.png');

%I = rgb2gray(I);

Hs = 8;
Hr = 4;
M = 40;
wSize = 2;

if size(I, 3) == 3
    output = MeanShiftSegColor(I, Hs, Hr, M, wSize);
    %output = MeanShiftSeg(I, Hs, Hr, M);
else
    output = MeanShiftSegGrayscale(I, Hs, Hr, M, wSize);
end
