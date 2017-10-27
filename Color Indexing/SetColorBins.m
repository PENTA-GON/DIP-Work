function [bins_color] = SetColorBins(maxBins, nbins3d)
%find # of max bins considered per group (color)
    nMaxBins = floor(nbins3d/min(nbins3d));
    tBins = sum(nMaxBins);
    %# bins per color space originally assigned
    bins_color(1,:) = nbins3d;
    minBins = floor(maxBins/tBins);
    %# bins according to given B(maxBins) value
    if mod(maxBins,tBins) == 0 %Proportion across three color spaces
       bins_color(2,:) = nMaxBins * minBins;
    else
        %specify # bins for each color index according to maxBins
        tmpMod = mod(maxBins,tBins);
        bins_color(2,:) = nMaxBins * minBins;
        if tmpMod < 2
            bins_color(2,2) = bins_color(2,2) + tmpMod;
        elseif tmpMod == 2
                bins_color(2,1) = bins_color(2,1) + 1;
                bins_color(2,3) = bins_color(2,3) + 1;
        elseif tmpMod == 3
            bins_color(2,:) = bins_color(2,:) + 1;
        else
            bins_color(2,:) = bins_color(2,:) + 1;
            bins_color(2,2) = bins_color(2,2) + 1;
        end
    end
end