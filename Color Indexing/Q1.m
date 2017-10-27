clear; close all; clc;
%Plot the graph of respective 3d or 2d histogram
isPlot = true;
%Display All images from databases 1 by 1
train_folder_name = '.\PP_Toys_03\Training';
%train_folder_name = '.\GiuseppeToys\Train';
%train_folder_name = '.\PM_Gadgets_03\Training';
% all files in training folder
filenames=dir(fullfile(train_folder_name,'*.jpg'));
filenames={filenames.name};
n_samples=numel(filenames);
for i=1:n_samples  
    %% Display image
    I = imread(fullfile(train_folder_name, num2str(cell2mat(filenames(i)))));    
    figure(1); imshow(I);
    set(gcf, 'NumberTitle', 'off');
    set(gcf, 'Name', strcat('Image: ',cell2mat(filenames(i))));
    title(strcat('Image: ',cell2mat(filenames(i))));
    %% Display 3D & 2D histograms
    figure(2);%'NumberTitle', 'off', 'Name', '3D and 2D color histogram');
    set(gcf, 'NumberTitle', 'off');
    set(gcf, 'Name', strcat('Image: ',cell2mat(filenames(i))));
    set(gcf, 'position', [100 100 1200 500]);
    %% 3D histogram    
    nbins3d = [16 8 16]; %Specify bins for 3d histogram
    flag3d = 0;
    subplot(221),histogram3d2d_NoScaling( I, nbins3d,flag3d,isPlot); 
    subplot(222),histogram3d2d( I, nbins3d,flag3d,isPlot);
    %% 2D histogram 
    nbins2d = [8 8]; %Specify bins for 2d histogram
    flag2d = 1;
    subplot(223),histogram3d2d_NoScaling( I, nbins2d,flag2d,isPlot);
    subplot(224),histogram3d2d( I, nbins2d,flag2d,isPlot);    
    pause;
end