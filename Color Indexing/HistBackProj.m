function [ ind_x,ind_y ] = HistBackProj( M, I ,r)
%Histogram BackProjection
%Determine the location of object

[m,n,~] = size(I);

nbins3d = [16 8 16];

flag = 0;

isPlot = 0;

%figure;
%subplot(1,2,1),
[hist_M,bin_M] = histogram3d2d( M,nbins3d,flag, isPlot );
%subplot(1,2,2),
[hist_I,bin_I] = histogram3d2d( I,nbins3d,flag, isPlot );


%Ratio histogram
hist_R = min(hist_M ./ (hist_I) , 1);

B = zeros(size(bin_I,1),1);

for i = 1:size(bin_I,1) 
    
    a = bin_I(i,1);
    b = bin_I(i,2);
    c = bin_I(i,3);
    B(i) = hist_R(a,b,c);
    %{
    if(flag == 0)
        c = bin_I(i,3);
        B(i) = hist_R(a,b,c);
    else
        B(i) = hist_R(a,b,c);
    end
    %}
end
B = reshape(B,[m,n]);
%imshow(B);

%disk filter
f = zeros(2*r,2*r);

for i = 1: r
    for j = 1: r
        if((i-r)^2 + (j-r)^2 < r^2)
            f(i,j) = 1;
        end
    end
end

f = f + f(: ,end :-1 :1);% Mirror horizontally 
f = f + f(end:-1:1,:);% Mirror vertically          

B1 = conv2(B,f,'same');
c = max(B1(:));
%imshow(B1/c);

[~,ind] = max(B1(:));
[ind_x, ind_y] = ind2sub([m n],ind);

theta = linspace(0,2*pi);
x = r*cos(theta) + ind_x;
y = r*sin(theta) + ind_y;

figure('NumberTitle', 'off', 'Name', 'Back Projection');
set(gcf, 'position', [100 100 1200 500]);
subplot(1,2,1),imshow(M);title('The target');
subplot(1,2,2),imshow(I),hold on; title('The image');

plot(ind_y,ind_x,'s','color','red');
plot(y,x,'color','green');




              
    



end

