function psf = PSFa(lambda,na,xyres,zres,xysize,zsize,rs,ri,d,w4,w7,w8,w12)

psf = zeros(xysize, xysize, zsize);
pupil = zeros(xysize, xysize);

k0 = 2*pi/lambda;
ki = ri/lambda*2*pi;
ks = rs/lambda*2*pi;
dkxy = (2*pi)/(xysize*xyres);

N = xysize/2;
n = zsize/2;

kMax = (2*pi*na)/(lambda*dkxy);
defocus = (-n+0.5:(n)).*zres;
kxcord = (1:xysize)'-N-1;
kycord = kxcord;

[kx, ky] = meshgrid(kxcord, kycord);
k = sqrt(kx.^2+ky.^2);
pupil = (k< kMax);

jmax=14;
par = [0 0 0 0 w4 0 0 w7 w8 0 0 0 w12 0 0]';
par(isnan(par)) =eps;
par = par./sqrt( sum(par.^2) );

W=zeros(length(kxcord),length(kycord));
for jj=0:jmax
    n=ceil((-3+sqrt(9+8*jj))/2);  
    m=2*jj-n*(n+2);                
    W=W+par(jj+1)*zernike(n,m,kxcord,kycord,kMax*2);
end

pupil=pupil.*exp(-i*2*pi*W/lambda);

sini = (k.*(dkxy))/ki;
sini(sini>1) = 1;
cosi = eps+sqrt(1-(sini.^2));

sins = (k.*(dkxy))/ks;
sins(sins>1) = 1;
coss = eps+sqrt(1-(sins.^2));

phiDefocus = (sqrt(-1)*ki).*cosi;
phi_sa = (sqrt(-1)*k0*d).*((rs.*coss)-(ri.*cosi));
OPDSA = exp(phi_sa);
pupil = (pupil./sqrt(cosi));

for zk = 1:zsize
    OPDDefocus = exp(defocus(1, zk).*phiDefocus);
    pupilDefocus = pupil.*OPDDefocus;
    pupilSA = pupilDefocus.*OPDSA;
    psf(:, :, zk) = ifft2(pupilSA);
    psf(:, :, zk) = fftshift(abs(psf(:, :, zk)).^2);
end

psf = sqrt(psf);