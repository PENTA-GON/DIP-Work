%I = imread('mit.png');
%I = imread('cameraman.png');
I = imread('Monkey.png');

output = MeanShiftSeg(I, 8, 6, 40);