clear, close all;

option = 3;

if option == 1
    I = imread('mit.png');      %%color
    Hs = 6;
    Hr = 10;
elseif option == 1.2
    I = imread('mit.png');      %%gray
    I = rgb2gray(I);
    Hs = 8;
    Hr = 4;
elseif option == 2
    I = imread('cameraman.png');    %%color
    Hs = 8;
    Hr = 10;
elseif option == 2.2
    I = imread('cameraman.png');    %%gray
    I = rgb2gray(I);
    Hs = 8;
    Hr = 4;
elseif option == 3
    I = imread('Monkey.png');      %%color
    Hs = 12;
    Hr = 14;
elseif option == 4              %%gray
    I = imread('Lena.bmp');
    I = imresize(I, 0.5);
    Hs = 8;
    Hr = 4;
elseif option == 5              %%gray
    I = imread('Peppers.bmp');
    I = imresize(I, 0.5);
    Hs = 8;
    Hr = 4;
elseif option == 6              %%color
    I = imread('build.png');
    I = imresize(I, 0.5);
    Hs = 8;
    Hr = 4;
elseif option == 7
    I = imread('boy.jpg');          %%gray
    Hs = 8;
    Hr = 4;
end


M = 40;
wSize = 2;

if size(I, 3) == 3
    output = MeanShiftSegColor(I, Hs, Hr, M, wSize);
else
    output = MeanShiftSegGrayscale(I, Hs, Hr, M, wSize);
end

