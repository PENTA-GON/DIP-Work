function [ match_value ] = HistIntersec_1D( hist_A, hist_B )
%HistIntersec_1 Basic histogram intersections using minimum values between
%two 1D-histograms 
% hist_A - Model image histogram
% hist_B - test image histogram
    %find minimum values between 2 histograms
    hist_min = min(hist_A, hist_B);
    %normailze hist intersection
    match_value = sum(hist_min)/ sum(hist_A);
end

