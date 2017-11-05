clear, close all;

option = 3;

if option == 1
    I = imread('mit.png');
    Hs = 6;
    Hr = 10;
elseif option == 2
    I = imread('cameraman.png');
    Hs = 8;
    Hr = 10;
else
    I = imread('Monkey.png');
    Hs = 12;
    Hr = 14;
end

M = 40;
wSize = 2;

if size(I, 3) == 3
    output = MeanShiftSegColor(I, Hs, Hr, M, wSize);
else
    output = MeanShiftSegGrayscale(I, Hs, Hr, M, wSize);
end

