clear, close all;

%I = imread('mit.png');
%I = rgb2gray(imread('cameraman.png'));
I = imread('Monkey.png');

if size(I, 3) == 3
    output = MeanShiftSeg(I, 8, 6, 4);
else
    output = MeanShiftSegGrayscale(I, 8, 6, 4);
end
