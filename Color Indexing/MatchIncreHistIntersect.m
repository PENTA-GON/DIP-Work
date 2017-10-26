function [ sIdx ] = MatchIncreHistIntersect( max_hist_model, test_hist, maxBins, nbins3d )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    %sort test image histogram by size    
    nModel = numel(max_hist_model);
    sIdx = zeros(1, nModel); %#_test_img x #_model_img (75x75)    
    %find # of max bins considered per color index
    nMaxBins = floor(nbins3d/min(nbins3d));
    tBins = sum(nMaxBins);
    for iModel = 1 : numel(nMaxBins)
        minBins = floor(maxBins/tBins);
        if mod(maxBins,tBins) == 0
           bins_color = nMaxBins * minBins;
        else
            %specify # bins for each color index according to maxBins
            tmpMod = mod(maxBins,tBins);
            bins_color = nMaxBins * minBins;
            if tmpMod < 2
                bins_color(2) = bins_color(2) + tmpMod;
            elseif tmpMod == 2
                    bins_color(1) = bins_color(1) + 1;
                    bins_color(3) = bins_color(3) + 1;
            elseif tmpMod == 3
                bins_color = bins_color + 1;
            else
                bins_color = bins_color + 1;
                bins_color(2) = bins_color(2) + 1;
            end
        end
    end
    %% sort test image histogram bins by size
    %Get # bins considered per index(color)
    n_rg_bins = bins_color(1);
    n_wb_bins = bins_color(2);
    n_by_bins = bins_color(3);
    for i_rg = 1 : nbins3d(1)
         iBin = test_hist(i_rg,:,:); %matrix of 1x8x16 
         hist_bin_rg(i_rg,:) = sum(iBin(:))/sum(test_hist(:)); 
    end
    for i_wb = 1 : nbins3d(2)
         iBin = test_hist(:,i_wb,:);
         hist_bin_wb(i_wb,:) = sum(iBin(:))/sum(test_hist(:));   
    end
    for i_by = 1 : nbins3d(3)
        iBin = test_hist(:,:,i_by);
         hist_bin_by(i_by,:) = sum(iBin(:))/sum(test_hist(:));         
    end
    [sorted_rg_bin, sorted_rg_idx] = sort(hist_bin_rg,'descend');
    [sorted_wb_bin, sorted_wb_idx] = sort(hist_bin_wb,'descend');
    [sorted_by_bin, sorted_by_idx] = sort(hist_bin_by,'descend');
    %% Go through each model comparison
    S_RG_IDX = 1;
    S_WB_IDX = nbins3d(1)+1;
    S_BY_IDX = nbins3d(1)+nbins3d(2)+1;
    for iModel= 1 : nModel
        %% compare with model bins for rg index         
        model_rg_prob = max_hist_model{iModel}(S_RG_IDX:n_rg_bins,1);
        test_rg_prob = sorted_rg_bin;
        
        model_rg_idx = max_hist_model{iModel}(S_RG_IDX:n_rg_bins,2); %index
        test_rg_idx = sorted_rg_idx(1:n_rg_bins);
        
        matched_idx = find(test_rg_idx == model_rg_idx);
        if numel(matched_idx) ~= n_rg_bins %unmatched bins in larger key values
            %get those bins not matched with test image
            unmatched_idx = find(test_rg_idx ~= model_rg_idx);   
            %processing for unmatched index
            %1) simply using index from model%test_rg_idx = [matched_idx; model_rg_idx(unmatched_idx)];
            %2) Compare and choose larger bins
            for j=1 : numel(unmatched_idx)
                if ~ismember(unmatched_idx(j), matched_idx) %not the same as matched idx
                    if( model_rg_prob(model_rg_idx(unmatched_idx(j)))> test_rg_prob(test_rg_idx(unmatched_idx(j))))
                        matched_idx = [sorted_rg_bin(matched_idx); model_rg_idx(unmatched_idx(j))];
                    else
                        matched_idx = [sorted_rg_bin(matched_idx); test_rg_idx(unmatched_idx(j))];
                    end
                else
                    model_rg_idx
                end
            end
        else
            test_rg_idx = matched_idx;
        end
        %Required Prob using RG Idx        
        for k=1 : numel(test_rg_idx)
            match_rg_prob(k,1) = sorted_rg_bin(test_rg_idx(k));
        end
        %% Compare with model bins for wb index
        model_wb_idx = max_hist_model{iModel}(S_WB_IDX:S_WB_IDX+(n_wb_bins-1),2);
        test_wb_idx = sorted_wb_idx(1:n_wb_bins);
        matched_idx = find(test_wb_idx == model_wb_idx);
        if numel(matched_idx) ~= n_wb_bins
            unmatched_idx = find(test_wb_idx ~= model_wb_idx);
            %TODO to replace with id from matched model bins
            test_wb_idx = [matched_idx; model_wb_idx(unmatched_idx)];
        else
           test_wb_idx = matched_idx; 
        end
        model_wb_prob =  max_hist_model{iModel}(S_WB_IDX:S_WB_IDX+(n_wb_bins-1),1);
        test_wb_prob = zeros(numel(model_wb_prob),1);
        for k=1 : numel(test_wb_prob)
           test_wb_prob(k,1) = sorted_wb_bin(test_wb_idx(k)); 
        end
        %% Compare with model bins for by index
        model_by_idx = max_hist_model{iModel}(S_BY_IDX:S_BY_IDX+(n_by_bins-1),2);
        test_by_idx = sorted_by_idx(1:n_by_bins);
        matched_idx = find(test_by_idx == model_by_idx);
        if numel(matched_idx) ~= n_by_bins
            unmatched_idx = find(test_by_idx ~= model_by_idx);
            test_by_idx = [matched_idx; model_by_idx(unmatched_idx)];
        else
            test_by_idx = matched_idx;
        end
        model_by_prob = max_hist_model{iModel}(S_BY_IDX:S_BY_IDX+(n_by_bins-1),1);
        test_by_prob = zeros(numel(model_by_prob),1);
        for k=1: numel(test_by_prob)
           test_by_prob(k,1) = sorted_by_bin(test_by_idx(k)); 
        end
        %% Compute normalized histogram intersection
        I = [match_rg_prob; match_wb_prob; match_by_prob];
        M = [model_rg_prob; model_wb_prob; model_by_prob];
        sIdx(1,iModel) = sum(min(I,M))/sum(M);
    end

end

