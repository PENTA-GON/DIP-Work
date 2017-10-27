clear; close all; clc;

load('histResults3d.mat');
%load('histResults2d.mat');

numR = size(sResults,1);
numC = size(sResults,2);
Row = [1:1:numR];
[col,row] = meshgrid(Row); %only use x
%myCol='byr'; %'MarkerFaceColor',myCol(1),

X = zeros(1,numR*numC);
Y = zeros(1,numR*numC);
counts = 1;
for i=1: numR
   for j=1 : numC
      X(counts) = i;
      Y(counts) = j;
      counts = counts + 1;
   end
end

figure;
scatter(X, Y, sResults(:)*100, 's','filled');

%trying to change figure properties
 xticks(Row);xtickangle(45);
 xticklabels({1:1:numR});
 yticks(Row);
 yticklabels({1:1:numC});
 set(gca, 'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
 xlabel('Model Images');
 ylabel('Test Images');
%%axis setting for R2016a
%{
set(gca, 'XAxisLocation','top','YAxisLocation',...
    'left','YDir','reverse',...
    'fontsize',5);

set(gca,'xtick',Row); 
set(gca,'xticklabel',{1:1:75});
set(gca,'ytick',Row); 
set(gca,'yticklabel',{1:1:75});
%}
[~, ind]= max(sResults,[],2);
counts = 1;
for i = 1:length(ind)
    if(i ~= ind(i))
        error(counts) = i;
        a = sort(sResults(i,:),'descend');
        b(counts) = find(a == sResults(i,i),1);
        counts = counts + 1 ;
    end
end
fprintf('There are %d errors here\n', counts - 1);
for i = 1:(counts-1)
    fprintf('It is the No.%d image,correct image is the No.%d matched image\n ', error(i),b(i));
end
%{
%% example obtained from web
M1=[1    1    1    1    1   
.5    .5    .5    .5    .5
.8    .8    .8    .8    .8
.10    .10    .10    .10    .10];

M2=[-0.1    -0.93    0.4    0.65    0   
.25    .71    .83    -.59    -0.7
.23    -.14    -.55    .49    .53
74.   .71    -.19    .58    -.76];

R1=[1 2 3 4 5];
C1=[1 2 3 4 5];

[ii,jj]=meshgrid(R1,C1);
cl=sign(M2)+2;
col='byr';
for k=1:numel(M1)
  h=scatter(ii(k),jj(k),'MarkerFaceColor',col(1),'linewidth',M1(k));
  hold on;
end
%}
