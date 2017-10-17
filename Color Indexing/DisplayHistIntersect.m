clear; close all; clc;

%read images from directory


M1=[1    1    1    1    1   
5    5    5    5    5
8    8    8    8    8
10    10    10    10    10];

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
  h=scatter(ii(k),jj(k),'MarkerFaceColor',col(cl(k)),'linewidth',M1(k));
  hold on;
end