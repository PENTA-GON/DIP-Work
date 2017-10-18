function [rg, by, wb] = rgb2opp(I)
    r = double(I(:,:,1));
    g = double(I(:,:,2));
    b = double(I(:,:,3));
    rg = r - g;
    by = 2*b - r - g;
    wb = r + g + b;
end