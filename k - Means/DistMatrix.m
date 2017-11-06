function d=DistMatrix(A,B)
 %%%%%%%%%%%%%%%%%%%%%%%%%
 % DISTMATRIX return distance matrix between points in A and in B
 %%%%%%%%%%%%%%%%%%%%%%%%%%%
clc

[hA,wA]=size(A);
[hB,wB]=size(B);
if wA ~= wB,  error(' second dimension of A and B must be the same'); end
for k=1:wA
  C{k}= repmat(A(:,k),1,hB);
  D{k}= repmat(B(:,k),1,hA);
end
S=zeros(hA,hB);
for k=1:wA
  S=S+(C{k}-D{k}').^2;
end
d=sqrt(S);