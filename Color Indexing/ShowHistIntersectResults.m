function [] = ShowHistIntersectResults(sResults, scale)

numR = size(sResults,1);
numC = size(sResults,2);
Row = [1:1:numR];

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
scatter(X, Y, sResults(:)*scale, 's','filled');

%trying to change figure properties
 xticks(Row);xtickangle(45);
 xticklabels({1:1:75});
 yticks(Row);
 yticklabels({1:1:75});
 
 %axis setting for R2016a
%{
  set(gca,'xtick',Row); 
  set(gca,'xticklabel',{1:1:75});
  set(gca,'ytick',Row); 
  set(gca,'yticklabel',{1:1:75});
%}
 set(gca, 'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
 xlabel('Model Images');
 ylabel('Test Images');
 
end
