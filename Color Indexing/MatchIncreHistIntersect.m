function [ sIdx ] = MatchIncreHistIntersect( max_hist_model, test_hist, maxBins )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    %sort test image histogram by size    
    nModel = numel(max_hist_model);
    sIdx = zeros(1, nModel); %#_test_img x #_model_img (75x75)
    %sort test image histogram bins by size
    for i_rg = 1 : 16
         iBin = test_hist(i_rg,:,:); %matrix of 1x8x16 
         hist_bin_rg(i_rg,:) = sum(iBin(:)); 
    end
    for i_wb = 1 : 8
         iBin = test_hist(:,i_wb,:);
         hist_bin_wb(i_wb,:) = sum(iBin(:));   
    end
    for i_by = 1 : 16
        iBin = test_hist(:,:,i_by);
         hist_bin_by(i_by,:) = sum(iBin(:));         
    end
    sorted_rg_bin = sort(hist_bin_rg,'descend');
    %go through each model comparison
    for i= 1 : nModel
        
    end

end

