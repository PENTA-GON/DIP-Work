clear; close all; clc;

dir_train = '.\PP_Toys_03\Training';
dir_test = '.\PP_Toys_03\TestScenes';
%% Normal
%M1:78 M2:10 M3:65 I:133
%M1:86 M2:93 M3:106 I:150
%M1:96 M2:14 M3:177 I:195
%M1:53 M2:63 M3:75 I:190
%M1:75 M2:53 M3:27 I:142
nImg = 5;
m1_img = [78 86 96 53 75];
m2_img = [10 93 14 63 53];
m3_img = [65 106 177 75 27];
i_img = [133 150 195 190 142];
%
%%{
disp('Normal');
r = 100;
for i=1 %: nImg
    M1 = imread(fullfile(dir_train, strcat(num2str(m1_img(i)),'.jpg')));
    M2 = imread(fullfile(dir_train, strcat(num2str(m2_img(i)),'.jpg')));
    M3 = imread(fullfile(dir_train, strcat(num2str(m3_img(i)),'.jpg')));
    I = imread(fullfile(dir_test, strcat(num2str(i_img(i)),'.jpg')));
    [x1,y1] = HistBackProj( M1, I, r);
    [x2,y2] = HistBackProj( M2, I, r);
    [x3,y3] = HistBackProj( M3, I, r);
end
%%}
pause; 
close all;
%% Insensitive to the angle of view 
%M1:34,36 M2:41,44 M3:92 I:164
%M1:59,69,75,77 M2:83 M3:100 I:147
%M1:0,1 M2:4,6 M3:28,29 I:129
disp('Insensitive to Angle of View');
%%{
r = 100;
M1 = imread(fullfile(dir_train,'6.jpg'));
M2 = imread(fullfile(dir_train,'4.jpg'));
M3 = imread(fullfile(dir_train,'1.jpg'));
M4 = imread(fullfile(dir_train,'0.jpg'));
I = imread(fullfile(dir_test,'129.jpg'));
[x1,y1] = HistBackProj( M1, I, r);
[x2,y2] = HistBackProj( M2, I, r);
[x3,y3] = HistBackProj( M3, I, r);
[x4,y4] = HistBackProj( M4, I, r);
pause;
close all;
%}

%% Small objects 
disp('Small objects');
%%{
%M1:0,1 M2:4,6 M3:28,29 M4:14, M5:10,11,
%M6:78,81,82 M7:65  M8:16,17 I:135,136,137
r = 60;
M1 = imread('.\PP_Toys_03\Training\1.jpg');
M2 = imread('.\PP_Toys_03\Training\6.jpg');%mismatch
M3 = imread('.\PP_Toys_03\Training\28.jpg');
M4 = imread('.\PP_Toys_03\Training\14.jpg');
M5 = imread('.\PP_Toys_03\Training\78.jpg');
M6 = imread('.\PP_Toys_03\Training\10.jpg');
M7 = imread('.\PP_Toys_03\Training\65.jpg');
M8 = imread('.\PP_Toys_03\Training\16.jpg');
%M9 = imread('.\PP_Toys_03\Training\300.jpg');%background
I = imread('.\PP_Toys_03\TestScenes\136.jpg');

%[x1,y1] = HistBackProj( M1, I, r);
%[x2,y2] = HistBackProj( M2, I, r);
%[x3,y3] = HistBackProj( M3, I, r);
[x4,y4] = HistBackProj( M4, I, r);
[x5,y5] = HistBackProj( M5, I, r);
[x6,y6] = HistBackProj( M6, I, r);
% [x7,y7] = HistBackProj( M7, I, r);
% [x8,y8] = HistBackProj( M8, I, r);
%[x9,y9] = HistBackProj( M9, I, r);
%}
