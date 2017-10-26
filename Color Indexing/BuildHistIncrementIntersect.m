function [ com_idx_hist ] = BuildHistIncrementIntersect(mod_hist, nbins3d)
%UNTITLED2 Summary of this function goes here
   
    %get bin size for each opponent dimension
    idx_rg = nbins3d(1); %16
    idx_wb = nbins3d(2); %8  
    idx_by = nbins3d(3); %16
    
    %% assign key to each bin of 'rg' dimension
    tPixels =  sum(mod_hist(:));
    BinProb = zeros(idx_rg,1);
    for i = 1 : idx_rg
        iBin = mod_hist(i,:,:); %matrix of 1x8x16             
        BinProb(i,:) = sum(iBin(:))/tPixels;
    end       
    [max_rg, rg_idx] = sort(BinProb,'descend');
    %% assign key to each bin of 'wb' dimension
    BinProb = zeros(idx_wb,1);
    for j = 1 : idx_wb
        iBin = mod_hist(:,j,:); %matrix of 16x1x16 
        BinProb(j,:) = sum(iBin(:))/tPixels;
    end
    [max_wb, wb_idx] =  sort(BinProb,'descend'); 
    %% assign key to each bin of 'by' dimension  
    BinProb = zeros(idx_by, 1);
    for k = 1 : idx_by
       iBin = mod_hist(:,:,k); %16x8 matrix
       BinProb(k,:) = sum(iBin(:))/tPixels;        
    end    
    [max_by, by_idx] = sort(BinProb,'descend');
    com_idx_hist =  [[max_rg rg_idx]; [max_wb wb_idx]; [max_by by_idx]];    
end

