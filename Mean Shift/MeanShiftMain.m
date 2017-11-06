clear, close all;

%%% Params %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hs: Spatial Normalization
% Hr: Range Normalization
% wSize: window size
% M:  cluster rejection threshold
% RCdist:  Clustering distance in the range space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


option = 3;

%%%% default %%%%%%
M = 40;
wSize = 2;
RCdist = 1;


if option == 1
    I = imread('mit.png');      %%color
    Hs = 6;
    Hr = 10;
    M = 0;
elseif option == 1.2
    I = imread('mit.png');      %%gray
    I = rgb2gray(I);
    Hs = 8;
    Hr = 4;
    M = 50;
    wSize = 6;
    RCdist = 50;
    
elseif option == 2
    I = imread('cameraman.png');    %%color
    Hs = 8;
    Hr = 4;
elseif option == 2.2
    I = imread('cameraman.png');    %%gray
    I = rgb2gray(I);
    Hs = 8;
    Hr = 4;
    M = 20;
    wSize = 4;
    RCdist = 10;
    
elseif option == 3
    I = imread('Monkey.png');      %%color
    Hs = 12;
    Hr = 14;
    M = 150;
elseif option == 3.2
    I = imread('Monkey.png');      %%color
    I = rgb2gray(I);
    Hs = 8;
    Hr = 4;   
    M=150;
    wSize = 4;
    RCdist = 20;
   
elseif option == 4              %%color
    I = imread('build.png');
    I = imresize(I, 0.5);
    Hs = 8;
    Hr = 4;   

end


if size(I, 3) == 3
    output = MeanShiftSegColor(I, Hs, Hr, M, wSize, RCdist);
else
    output = MeanShiftSegGrayscale(I, Hs, Hr, M, wSize, RCdist);
end

