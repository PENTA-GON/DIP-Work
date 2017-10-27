function [sValue ] = HistIntersec_3D( hist_A, hist_B )
%HistIntersec_3D Basic histogram intersections using minimum values between
%two 3D-histograms 
% hist_A - Model image histogram
% hist_B - test image histogram
    %find minimum values between 2 histograms, 3D arrary
    hist_min = min(hist_A, hist_B);
    %normalized intersection across 1st dimension
%     for x=1 : size(hist_min, 1) 
%         % sum of minimum histogram
%         I = sum(hist_min(x,:,:)); 
%         %sum of model histogram
%         M = sum(hist_A(x,:,:)); 
%         %normalize histogram intersection
%         min_x(:,x) = sum(I)/sum(M);
%     end
%     for y=1 : size(hist_A, 2)
%         min_y(:,y) = sum(sum(hist_min(:,y,:))) / sum(sum(hist_A(:,y,:)));
%     end
%     for z=1 : size(hist_A, 3)
%         min_z(:,z) = sum(sum(hist_min(:,:,z))) / sum(sum(hist_A(:,:,z)));
%     end
%     sValue = mean([mean(x) mean(y) mean(z)]);
    sValue = sum(hist_min(:))/sum(hist_A(:));
end

%convert 3d to 2d matrix
%feat = reshape(x,size(x,1)*size(x,2),size(x,3));