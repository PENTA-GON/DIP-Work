function [ counts,aver,record ] = k_means( samples,k )
% k-means clusterinf algorithm

%randomly choose k samples as the cluster centers
[nrow,ncol] = size(samples);
randIndex = randperm(ncol,k);
initcenter = samples(:,randIndex);

%initialate the cluster centers
aver = initcenter; % cluster center
counts = ones(k,1);  
record = cell(k,1); % record samples within each class

for i = 1:size(samples,2)
    
    min = distance(samples(:,i),aver(:,1));%between the i-th sample and the first cluster center
    min_ind = 1;
    
    for j = 2:k
        dis = distance(samples(:,i),aver(:,j));
        if(dis < min)
            min = dis;
            min_ind = j;
        end
    end
    
    record{min_ind}(counts(min_ind,1)) =  i; 
    counts(min_ind,1) = counts(min_ind,1)+ 1;
    %update the cluster center
    aver(:,min_ind) = (aver(:,min_ind) * (counts(min_ind,1)-1) + samples(:,i)) / counts(min_ind,1);
    
end

end

