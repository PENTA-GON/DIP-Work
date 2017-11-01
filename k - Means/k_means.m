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
%value = cell(k,1);

max_iters = 15;
for M = 1:max_iters
    
   % For each example in X, assign it to the closest centroid 
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
       %value{min_ind} = [ value{min_ind},samples(:,i)];
       counts(min_ind) = counts(min_ind)+ 1;
   end
    
    % Given the memberships, compute new centroids
    for j = 1:k
        value = samples(:,record{j}(1));
        for s = 2:(counts(j)-1)
            value = [value, samples(:,record{j}(s))];
        end
        aver(:,j) = sum(value,2) / (counts(j) - 1);
    end
end

end

