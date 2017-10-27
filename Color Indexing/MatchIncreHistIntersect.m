function [ sIdx ] = MatchIncreHistIntersect( max_hist_model, max_hist_test, bins_color )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    %sort test image histogram by size    
    nModel = numel(max_hist_model);
    sIdx = zeros(1, nModel); %#_test_img x #_model_img (75x75)    
    %% sort test image histogram bins by size
    %Get # bins considered per index(color)
    nbins3d = bins_color(1,:); %16-8-16
    mbins3d = bins_color(2,:); % B=10 => 4-2-4 %n_rg_bins-n_wb_bins-n_by_bins      
    %% indexes to go through test image bins & indexes (test_hist=16-8-16)
    idx_per_color(1,:) = [1 nbins3d(1)]; %rg => 1-16
    idx_per_color(2,:) = [nbins3d(1)+1 nbins3d(1)+nbins3d(2)]; %wb => 17-24
    idx_per_color(3,:) = [nbins3d(1)+nbins3d(2)+1 nbins3d(1)+nbins3d(2)+nbins3d(3)]; %by=>25-40
    
    %% 2. Find mached histogram bins between model and test images
    for iModel= 1 : nModel
        for iColor=1 : size(nbins3d,2) %3 colors: rg-wb-by
            %Model image idx and prob per Color
            model_bin_prob{iColor} = max_hist_model{iModel}(idx_per_color(iColor,1): idx_per_color(iColor,2), 1);
            model_bin_idx{iColor} = max_hist_model{iModel}(idx_per_color(iColor,1): idx_per_color(iColor,2), 2);
            %Test Image idx and prob per Color
            test_bin_prob = max_hist_test(idx_per_color(iColor,1): idx_per_color(iColor,2), 1);
            test_bin_idx= max_hist_test(idx_per_color(iColor,1): idx_per_color(iColor,2), 2);
            % idx of selected # bins according to given B (B=10 in example)
            model_idx{iColor} = model_bin_idx{iColor}(1 : mbins3d(iColor)); 
            test_idx{iColor} = test_bin_idx(1 : mbins3d(iColor)); 
            %Resultant matching idx and prob for B bins per index(Color)
            match_idx{iColor} = zeros(mbins3d(iColor),1);
            match_prob{iColor} = zeros(mbins3d(iColor),1);
            model_prob{iColor} = zeros(mbins3d(iColor),1);
            %matching index between test and model image bins
            matched_bins = find(test_idx{iColor} == model_idx{iColor});
            %Condition if NOT all bins are matched
            if numel(matched_bins) ~= mbins3d(iColor)
                %Assign those partially matched indexes
                match_idx{iColor} = test_bin_idx(matched_bins);
                %Find indexes of unmatched bins
                unmatched_bins = find(test_idx{iColor} ~= model_idx{iColor}); 
                for i=1 : numel(unmatched_bins)
                    if ~ismember(test_bin_idx(unmatched_bins(i)), match_idx{iColor})
                        if ~ismember(model_idx{iColor}(unmatched_bins(i)), match_idx{iColor})
                            if model_bin_prob{iColor}(model_idx{iColor}(unmatched_bins(i))) > test_bin_prob(test_idx{iColor}(unmatched_bins(i)))
                                match_idx{iColor} = [match_idx{iColor}; model_idx{iColor}(unmatched_bins(i))];
                            else
                                match_idx{iColor} = [match_idx{iColor}; test_idx{iColor}(unmatched_bins(i))];
                            end
                        else
                             match_idx{iColor} = [match_idx{iColor}; test_idx{iColor}(unmatched_bins(i))];
                        end        
                    else %Included in current matched bins
                        match_idx{iColor} = [match_idx{iColor}; model_idx{iColor}(unmatched_bins(i))];
                    end
                end
            else %Condition if ALL bins are matched
                match_idx{iColor} = matched_bins;                
            end
            match_bin_idx = match_idx{iColor};
            for j=1 : numel(match_bin_idx)               
                %Get match prob according to match idx of bins
                if test_bin_prob(match_bin_idx(j)) < model_bin_prob{iColor}(match_bin_idx(j))
                    match_prob{iColor}(j) = test_bin_prob(match_bin_idx(j));
                else
                    match_prob{iColor}(j) = model_bin_prob{iColor}(match_bin_idx(j));
                end
                model_prob{iColor}(j) = model_bin_prob{iColor}(match_bin_idx(j));
            end
        end   
        %% Compute normalized histogram intersection
        I = [match_prob{1}; match_prob{2}; match_prob{3}];
        M = [model_bin_prob{1}(1 : mbins3d(1)); model_bin_prob{2}(1 : mbins3d(2)); model_bin_prob{3}(1 : mbins3d(3))]; %Using all M
        %M = [model_prob{1}; model_prob{2}; model_prob{3}];%Using M(B)
        %sIdx(1,iModel) = sum(I)/sum(M);
        sIdx(1,iModel) = sum(min(I,M))/sum(M); 
    end

end

