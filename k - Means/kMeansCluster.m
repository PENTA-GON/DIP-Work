function [clusters]=kMeansCluster(m,k)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kMeansCluster - Simple k means clustering algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[maxRow, maxCol]=size(m);
if maxRow<=k, 
    y=[m, 1:maxRow];
else
	
	% initial value of centroid
	p = randperm(size(m,1));      % random initialization
	for i=1:k
		c(i,:)=m(p(i),:);  
	end    
	temp=zeros(maxRow,1);   % initialize as zero vector    
	while 1,
        d=DistMatrix(m,c);  % calculate objcets-centroid distances
        [z,g]=min(d,[],2);  % find group matrix g
        if g==temp,
            break;          % stop the iteration
        else
            temp=g;         % copy group matrix to temporary variable
        end
        for i=1:k
            c(i,:)=mean(m(find(g==i),:));
        end
	end
    clusters = c'; %row: # attributes, col: # clusters
end
