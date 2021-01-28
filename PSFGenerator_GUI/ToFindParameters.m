clear all; close all; clc
%% 

%Initial PSF
fixed_par=[530,1.4,64.5,160,256,128,1.333,1.518, 10560]; % lambda,na,xyres,zres,xysize,zsize,rs,ri,d
find_par=[0.02 0.03 0 0]; % inital aberration values
h = PSFa(fixed_par(1),fixed_par(2),fixed_par(3),fixed_par(4),fixed_par(5),fixed_par(6),fixed_par(7),fixed_par(8),fixed_par(9),find_par(1),find_par(2),find_par(3),find_par(4)); %initial PSF

% images
load('../Deconv_GUI/bars/blurred_bars.mat');
g = single(blurred_bars); %observed image
f = g; %initial image 

% optimization 
options=optimset('TolX',1e-10,'Display','Iter','MaxIter',10,'MaxFunEvals',100 );
f_handle = @(find_par)myobjfun(find_par,f,g,fixed_par);
best_par=fminsearch(f_handle, find_par ,options);
%save best_par best_par
        
