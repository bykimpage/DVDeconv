function Znm=zernike(n,m,x,y,d)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Class:     Psych 221/EE 362
% Function:  zernike.m
% Author:    Patrick Maeda
% Purpose:   Compute Zernike Polynomial
% Date:      02.28.03	
%	
% Matlab 6.1:  03.03.03
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% zernike.m  is a function that computes the values of a Zernike Polynomial
%            over a circular pupil of diameter d
%
% Output:
% Znm is the Zernike polynomial term of order n and frequency m
%
% Input:
% n = highest power or order of the radial polynomial term, [a positive integer]
% m = azimuthal frequency of the sinusoidal component, [a signed integer, |m| <= n]
% x = 1-D array of pupil x-coordinate values, [length(x) must equal length(y)]
% y = 1-D array of pupil y-coordinate values, [length(y) must equal length(x)]
% d = pupil diameter
%
% The Zernike Polynomial definitions used are taken from:
% Thibos, L., Applegate, R.A., Schweigerling, J.T., Webb, R., VSIA Standards Taskforce Members,
% "Standards for Reporting the Optical Aberrations of Eyes"
% OSA Trends in Optics and Photonics Vol. 35, Vision Science and its Applications,
% Lakshminarayanan,V. (ed) (Optical Society of America, Washington, DC 2000), pp: 232-244. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize circular pupil function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Imax=length(x);
Jmax=length(y);
a=d/2;

for I=1:Imax    %initialize circular pupil
    for J=1:Jmax
       p(I,J)=(sqrt(x(I)^2+y(J)^2) <= a);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute Normalization Constant
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Nnm=sqrt(2*(n+1)/(1+(m==0)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute Zernike polynomial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if n==0
   Znm=p;
else
   Znm=zeros(Imax,Jmax);
   for I=1:Imax
      for J=1:Jmax
         r=sqrt(x(I)^2+y(J)^2);
         if (x(I)>=0 & y(J)>=0) | (x(I)>=0 & y(J)<0)
            theta=atan(y(J)/(x(I)+1e-20));
         else
            theta=pi+atan(y(J)/(x(I)+1e-20));
         end
         for s=0:0.5*(n-abs(m))
            Znm(I,J)=Znm(I,J)+(-1)^s*factorial(n-s)*(r/a)^(n-2*s)/(factorial(s)*...
                     factorial(0.5*(n+abs(m))-s)*factorial(0.5*(n-abs(m))-s));
         end
         Znm(I,J)=p(I,J)*Nnm*Znm(I,J)*((m>=0)*cos(m*theta)-(m<0)*sin(m*theta));
      end
   end
end

