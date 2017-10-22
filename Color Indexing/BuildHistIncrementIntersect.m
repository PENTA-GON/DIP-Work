function [ com_idx_hist, idx_mod_hist ] = BuildHistIncrementIntersect(mod_hist, nbins3d)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    %combined histogram
    
    %get bin size for each opponent dimension
    idx_rg = nbins3d(1); %16
    idx_wb = nbins3d(2); %8  
    idx_by = nbins3d(3); %16
    sortedProb = zeros(idx_rg, idx_rg); 
    sortedBin = zeros(idx_rg, idx_rg);
    %% assign key to each bin of 'rg' dimension
    BinProb = zeros(idx_rg,idx_rg);
    for i = 1 : idx_rg
        iBin = mod_hist(i,:,:); %matrix of 1x8x16 
        fBin = reshape(iBin, size(iBin,1)*size(iBin,2), size(iBin,3)); %matrix of 8x16
        tPixels = sum(sum(fBin));
        BinProb(i,:) = sum(fBin)/tPixels;
        %sort group according to key values 
        [sortedProb(i,:), sortedBin(i,:)] = sort(BinProb(i,:),'descend');
    end       
    idx_mod_hist{1,1} = sortedBin;
    idx_mod_hist{2,1} = sortedProb;
    %max_rg = [sortedBin(:,1) max(sortedProb,[],2)]; %max values at first column 
    [max_rg, rg_idx] = sort(max(sortedProb,[],2),'descend');
    %% assign key to each bin of 'wb' dimension
    sortedProb = zeros(idx_wb, idx_by);
    sortedBin = zeros(idx_wb, idx_by);
    BinProb = zeros(idx_wb,idx_by);
    for j = 1 : idx_wb
        iBin = mod_hist(:,j,:); %matrix of 16x1x16 
        fBin = reshape(iBin, size(iBin,1)*size(iBin,2), size(iBin,3)); %matrix of 16x16
        tPixels = sum(sum(fBin));
        BinProb(j,:) = sum(fBin)/tPixels;
         %sort group according to max values 
        [sortedProb(j,:), sortedBin(j,:)] = sort(BinProb(j,:),'descend');
    end
    idx_mod_hist{1,2} = sortedBin;
    idx_mod_hist{2,2} = sortedProb;
    %max_wb = [sortedBin(:,1) max(sortedProb,[],2)]; %max values at first column
    [max_wb, wb_idx] =  sort(max(sortedProb,[],2),'descend'); 
    %% assign key to each bin of 'by' dimension
    sortedProb = zeros(idx_by, idx_wb);
    sortedBin = zeros(idx_by, idx_wb);
    BinProb = zeros(idx_by, idx_wb);
    for k = 1 : idx_by
       iBin = mod_hist(:,:,k); %16x8 matrix
        tPixels = sum(sum(iBin));
        BinProb(k,:) = sum(iBin)/tPixels;
        [sortedProb(k,:), sortedBin(k,:)] = sort(BinProb(k,:),'descend');
    end
    idx_mod_hist{1,3} = sortedBin;
    idx_mod_hist{2,3} = sortedProb;
    %max_by = [sortedBin(:,1) max(sortedProb,[],2)]; %max values at first column
    [max_by, by_idx] = sort(max(sortedProb,[],2),'descend')
    com_idx_hist =  [[max_rg rg_idx]; [max_wb wb_idx]; [max_by by_idx]];
    
end

