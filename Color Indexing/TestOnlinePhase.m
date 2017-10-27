clear;close all;clc;
%Test image
n_rg_bins = 3; %mbins3d(1)

%Test Image
sorted_rg_bin = [0.160851351351351;0.159824324324324;0.108175675675676;0.105445945945946;0.0822567567567568;0.0670472972972973;0.0664932432432432;0.0643716216216216];
sorted_rg_idx = [3;4;1;2;7;6;5;8];

%Model image
model_rg_prob = [0.150851351351351;0.149824324324324;0.138175675675676;0.105445945945946;0.0822567567567568;0.0670472972972973;0.0664932432432432;0.0643716216216216];
test_rg_prob = sorted_rg_bin;

%Comparison with B=3
model_idx = [2;4;3];%
test_idx = sorted_rg_idx(1:3);

% Resultant bin idx and prob
match_rg_idx = zeros(n_rg_bins,1);
match_rg_prob = zeros(n_rg_bins,1);

matched_bins = find(test_idx == model_idx);
if numel(matched_bins) ~= 3 %Partial or No matches
    %Complete those partially equivalent one
    match_rg_idx = sorted_rg_idx(matched_bins);
     unmatched_bins = find(test_idx ~= model_idx);       
     for j=1 : numel(unmatched_bins) %loop through all unmatched bins
         
        if ~ismember(sorted_rg_idx(unmatched_bins(j)), match_rg_idx) %not included in current matched indexes
            if ~ismember(model_idx(unmatched_bins(j)), match_rg_idx)
                if model_rg_prob(model_idx(unmatched_bins(j))) > test_rg_prob(test_idx(unmatched_bins(j)))
                    match_rg_idx = [match_rg_idx; model_idx(unmatched_bins(j))];
                else
                    match_rg_idx = [match_rg_idx; test_idx(unmatched_bins(j))];
                end
            else
                 match_rg_idx = [match_rg_idx; test_idx(unmatched_bins(j))];
            end
           
        else %included in current matched_bins
            match_rg_idx = [match_rg_idx; model_idx(unmatched_bins(j))];
        end
        
     end
     
else %Complete matches between model and test
    match_rg_idx = matched_bins;
end

for j=1 : n_rg_bins
    if test_rg_prob(match_rg_idx(j)) > model_rg_prob(match_rg_idx(j))
                match_rg_prob(j) = test_rg_prob(match_rg_idx(j));
            else
                match_rg_prob(j) = model_rg_prob(match_rg_idx(j));
            end
end

