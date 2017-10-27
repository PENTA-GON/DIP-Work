function [sorted_hist] = SortedHistBySize(test_hist, strType) 
    end_idx = 0;
    %bin and idx size
   sorted_hist_bin = zeros(1, sum(size(test_hist)));
   sorted_hist_idx = zeros(1, sum(size(test_hist)));
    for iColor=1 : numel(size(test_hist))
       %start and end idx
       start_idx = 1 + end_idx;
       end_idx = start_idx + size(test_hist, iColor) - 1; 
       hist_bin = zeros(size(test_hist, iColor), 1);
       for j=1 : size(test_hist, iColor) 
           switch iColor
               case 1 
                   iBin = test_hist(j,:,:);
               case 2
                   iBin = test_hist(:,j,:);
               case 3
                    iBin = test_hist(:,:,j);
               otherwise 
                   error('wrong bins');
           end
           hist_bin(j,:) = sum(iBin(:))/sum(test_hist(:)); 
       end
       [sorted_hist_bin(1, start_idx:end_idx), sorted_hist_idx(1, start_idx:end_idx)]  = sort(hist_bin, strType);      
    end  
    sorted_hist = [sorted_hist_bin' sorted_hist_idx'];
end