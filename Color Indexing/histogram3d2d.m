function [ n1,bin ] = histogram3d2d( I,nbins,flag, isPlot )
% Task1.Create 3D and 2D histogram
% I: image input; nbins: size of bins; flag: 0-3D histogram and 1-2D histogram

r = double(I(:,:,1));
g = double(I(:,:,2));
b = double(I(:,:,3));

% 3D histogram
if (flag == 0)
    rg = r - g;
    by = 2*b - r - g;
    wb = r + g + b;
    
    w = [rg(:),wb(:),by(:)];
    
% 2D histogram    
else 
    r1 = r ./ (r + g + b);
    g1 = g ./(r + g + b);
    b1 = 1 - r1 - g1;
    
   % w = [r1(:),g1(:)];
   w = [r1(:),g1(:),b1(:)];
   nbins = [nbins,nbins(1)];
end

[nrows,ncols] = size(w);
% Bin each observation in sifferent directions, such asx,y,z-direction.
bin = zeros(nrows,ncols);

for i = 1:ncols
    %minx = min(w(:,i));
    %maxx = max(w(:,i));
    
    %%{
    if(flag == 0)
        if(ncols == 3 && i == 2)
            minx = 0;
            maxx = 255 * 3/2;%for wb axis
        else
            minx = -255/2;
            maxx = 255/2;
        end
    else 
        minx = 0;
        maxx = 1.0;
        %maxx = max(w(:,i));
    end
    %}
    % Make histc mimic hist behavior  
    binwidth{i} = (maxx - minx) / nbins(i);
    edges{i} = minx + binwidth{i}*(0:nbins(i));
    ctrs{i} = edges{i}(1:nbins(i)) + binwidth{i}/2;

    % everything < ctrs(1) gets counted in first bin, 
    % everything > ctrs(end) gets counted in last bin.
    histcEdges = [-Inf edges{i}(2:end-1) Inf];
    [dum,bin(:,i)] = histc(w(:,i),histcEdges,1);
    
    %subscripts begins at 1 
    bin(:,i) = max(bin(:,i),1);
    bin(:,i) = min(bin(:,i),nbins(i));
end

% Combine the three vectors of 1D bin counts into a grid of 3D bin
% Counts. A = accumarray(subs,val,sz) If sub = 1 and val = 101,realValue = val-1+sub = 101
n1 = accumarray(bin,1,nbins);

if(flag == 1)
    for i = 1:nbins(1)
        for j  = 1:nbins(2)
            n(i,j) = sum(n1(i,j,:));
        end
    end
else
    n = n1;
end

a = (n>0);
len = sum(a(:));

X = zeros(1,len);
Y = zeros(1,len);
S = zeros(1,len);% Scale
C = zeros(len,3);% Color

counts = 1;

if isPlot
    if (flag == 0) 
        Z = zeros(1,len);
    
    for z = 1:nbins(3)
        for y = 1:nbins(2)
            for x = 1:nbins(1)
                if ~n(x,y,z) == 0
                    X(counts) = x;
                    Y(counts) = y;
                    Z(counts) = z;
                    S(counts) = n(x,y,z)/10;
            
                    % Using inverse function to calculate the original color
                    R = uint8(1/2 * edges{1}(x)+ 1/3 * edges{2}(y) - 1/6 * edges{3}(z));
                    G = uint8(-1/2 * edges{1}(x)+ 1/3 * edges{2}(y) - 1/6 * edges{3}(z));
                    B = uint8(1/3 * edges{2}(y) + 1/3 * edges{3}(z));
                    C(counts,:) = [im2double(R),im2double(G),im2double(B)];
               
                    counts = counts + 1;
                end
            end
        end
    end 

    %figure;
    %if isPlot
        scatter3(X,Y,Z,S,C,'filled','s');%,'MarkerfaceAlpha',0.8); 

        axis([0 16 0 8 0 16]);

        xlabel(['rg axis [',num2str(round(edges{1}(1))),',',num2str(round(edges{1}(nbins(1)))),']']);
        ylabel(['wb axis [',num2str(round(edges{2}(1))),',',num2str(round(edges{2}(nbins(2)))),']']);
        zlabel(['by axis [',num2str(round(edges{3}(1))),',',num2str(round(edges{3}(nbins(3)))),']']);
        title('3D histogram of three opponent color axes');

        box on
        ax = gca;
        ax.BoxStyle = 'full';
        set(gca,'YDir','reverse'); 

        view(30,30);
    %end
else
    for y = 1:nbins(2)
        for x = 1:nbins(1)
            if ~n(x,y) == 0
                X(counts) = x;
                Y(counts) = y;
                S(counts) = n(x,y,:)/10;
            
                j = 1;
               
                % Because different colors may have same r' and g'
                % Average color within each bin is used in here 
                for i = 1:size(bin,1)
                    if(bin(i,1) == x && bin(i,2) == y)
                        [ind(j,1),ind(j,2)] = ind2sub(size(I),i);
                        j = j + 1;
                    end
                end
                
                if(size(ind,1)~= 1)
                    c = uint8(mean(ind));
                else% only one pixel within bin(x,y) 
                    c = ind;
                end
                C(counts,:)= im2double(uint8(I(c(1),c(2),:)));
                
                counts = counts + 1;
            end
        end
    end 
    %if isPlot
        scatter(X ,Y ,S,C,'filled','s','MarkerfaceAlpha',0.8); 
        xlabel(['r'' axis [',num2str(edges{1}(1)),',',num2str(edges{1}(nbins(1))),']']);
        ylabel(['g'' axis [',num2str(edges{2}(1)),',',num2str(edges{2}(nbins(2))),']']);

        title('2D histogram of color constancy algorithm');
    %end
    end
end

end

