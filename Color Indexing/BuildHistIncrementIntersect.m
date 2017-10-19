function [ idx_mod_hist ] = BuildHistIncrementIntersect(mod_hist)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    idx_rg = 16;
    idx_by = 16;
    idx_wb = 8;
    
    %% assign key to each bin of 'rg' dimension
    for i = 1 : idx_rg
        iBin = mod_hist(i,:,:); %matrix of 1x8x16 
        fBin = reshape(iBin, size(iBin,1)*size(iBin,2), size(iBin,3)); %matrix of 8x16
        tPixels = sum(sum(fBin));
        Binkeys(1,i) = sum(fBin)/tPixels;
    end
    %sort group according to key values

end

