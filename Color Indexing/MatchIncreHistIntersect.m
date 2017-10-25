function [ sIdx ] = MatchIncreHistIntersect( max_hist_model, test_hist, maxBins, nbins3d )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    %sort test image histogram by size    
    nModel = numel(max_hist_model);
    sIdx = zeros(1, nModel); %#_test_img x #_model_img (75x75)    
    %find # of max bins considered per color index
    nMaxBins = floor(nbins3d/min(nbins3d));
    tBins = sum(nMaxBins);
    for i = 1 : numel(nMaxBins)
        minBins = maxBins/tBins;
        if mod(maxBins,tBins) == 0
           bins_color = nMaxBins * minBins;
        else
            %specify # bins for each color index according to maxBins
        end
    end
    %sort test image histogram bins by size
    for i_rg = 1 : 16
         iBin = test_hist(i_rg,:,:); %matrix of 1x8x16 
         hist_bin_rg(i_rg,:) = sum(iBin(:))/sum(test_hist(:)); 
    end
    for i_wb = 1 : 8
         iBin = test_hist(:,i_wb,:);
         hist_bin_wb(i_wb,:) = sum(iBin(:))/sum(test_hist(:));   
    end
    for i_by = 1 : 16
        iBin = test_hist(:,:,i_by);
         hist_bin_by(i_by,:) = sum(iBin(:))/sum(test_hist(:));         
    end
    [sorted_rg_bin, sorted_rg_idx] = sort(hist_bin_rg,'descend');
    %go through each model comparison
    for i= 1 : nModel
        rg_idx = max_hist_model{i}(1:16,2); %index
    end

end

