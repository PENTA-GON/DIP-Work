function [ feat_new ] = featSelect(file,nb_new)
%Read the file and randomly choose nb_new number of features


 fid = fopen(file, 'r');
 dim = fscanf(fid, '%f',1); %dimension of each feature
 if dim == 1
     dim = 0;
 end
 
 %number of all features
 nb = fscanf(fid, '%d',1);
 %feature
 feat = fscanf(fid, '%f', [5+dim, inf]);
 fclose(fid);
 

 
 if(nb ~= size(feat,2))
     nb = size(feat,2)
 end
 
 %randomly choose 100 features
 if(nb < nb_new)
     fprintf('the number of features is smaller than the demanded');
 else
     %returns nb_new unique integers selected randomly from 1 to nb inclusive
     randIndex = randperm(nb,nb_new);%exclude the geometry information
     feat_new = feat(:,randIndex);
     %feat_new = feat(6:133,randIndex);
 end
 
end

