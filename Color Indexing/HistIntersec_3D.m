function [sValue ] = HistIntersec_3D( hist_A, hist_B )
%HistIntersec_3D Basic histogram intersections using minimum values between
%two 3D-histograms 
% hist_A - Model image histogram
% hist_B - test image histogram
    %find minimum values between 2 histograms
    hist_min = min(hist_A, hist_B);
    %Find intersection between test and model histograms
    sValue = sum(hist_min(:))/sum(hist_A(:));
end

%convert 3d to 2d matrix
%feat = reshape(x,size(x,1)*size(x,2),size(x,3));