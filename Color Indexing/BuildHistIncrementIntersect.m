function [ com_idx_hist ] = BuildHistIncrementIntersect(mod_hist, nbins3d)
%UNTITLED2 Summary of this function goes here
    tPixels =  sum(mod_hist(:)); %total # pixels
    com_idx_hist = zeros(sum(nbins3d), 2);
    end_idx = 0;
    for idx = 1 : numel(nbins3d)
       %change start and end indexes for each group
       start_idx = 1 + end_idx;
       end_idx = start_idx + nbins3d(idx) - 1;        
       BinProb = zeros(nbins3d(idx),1);%key per bin
       %2. Group the bins by index (color)
       for j= 1 : nbins3d(idx)
           switch(idx)
               case 1
                   iBin = mod_hist(j,:,:); %matrix of 1x8x16  
               case 2
                   iBin =  mod_hist(:,j,:); %matrix of 16x1x16
               case 3
                   iBin = mod_hist(:,:,j); %16x8 matrix
               otherwise
                   error('wrong input');
           end
           %1. Assign key(=#pixels per bin/# total pixels) for each bin in each group in each model
           BinProb(j,:) = sum(iBin(:))/tPixels;           
       end
       %3. Sort each group by key 'descending' order
       [com_idx_hist(start_idx:end_idx,1), com_idx_hist(start_idx:end_idx,2)] = sort(BinProb,'descend');
    end   
end

