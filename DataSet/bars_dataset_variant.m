clear all
close all
clc

%% ---------------- Data Generation (Depth-variant Image Model) ----------------------------%%
addpath('DVAsymPSF');  
%% Generate bars
bars = zeros(256,256,128);
for x = 1:256
    for z = 1:128
        if (((x-87)^2+(z-35)^2)<43) && (((x-87)^2+(z-35)^2)>15)
            bars(x,86:170,z) = 65635;
        end
    end
end

for x = 1:256
    for z = 1:128
        if (((x-108)^2+(z-50)^2)<43) && (((x-108)^2+(z-50)^2)>15)
            bars(x,86:170,z) = 65635;
        end
    end
end

for x = 1:256
    for z = 1:128
        if (((x-129)^2+(z-65)^2)<43) && (((x-129)^2+(z-65)^2)>15)
            bars(x,86:170,z) = 65635;
        end
    end
end

for x = 1:256
    for z = 1:128
        if (((x-150)^2+(z-80)^2)<43) && (((x-150)^2+(z-80)^2)>15)
            bars(x,86:170,z) = 65635;
        end
    end
end

for x = 1:256
    for z = 1:128
        if (((x-171)^2+(z-95)^2)<43) && (((x-171)^2+(z-95)^2)>15)
            bars(x,86:170,z) = 65635;
        end
    end
end
bars = uint16(bars);
%save bars bars
g = bars;
[gx gy gz] = size(g);
%% Save tif 2D images
for z=1:9
    tmp = bars(:,:,z);
    eval(['imwrite(tmp,''bars00' num2str(z) '.tif'')']);
end

for z=10:99
    tmp = bars(:,:,z);
    eval(['imwrite(tmp,''bars0' num2str(z) '.tif'')']);
end

for z=100:128
    tmp = bars(:,:,z);
    eval(['imwrite(tmp,''bars' num2str(z) '.tif'')']);
end
%% Blurring

for num = 1: 9
    eval(['load h0000' num2str(num) ' h0000' num2str(num) ' ']);
    eval(['H{' num2str(num) '} = single(psf2otf(h0000' num2str(num) ', size(g)));']);
end

for num = 10: 99
    eval(['load h000' num2str(num) ' h000' num2str(num) ' ']);
    eval(['H{' num2str(num) '} = single(psf2otf(h000' num2str(num) ', size(g)));']);
end

for num = 100: gz
    eval(['load h00' num2str(num) ' h00' num2str(num) ' ']);
    eval(['H{' num2str(num) '} = single(psf2otf(h00' num2str(num) ', size(g)));']);
end

for kk = 1:gz
        eval(['Y' num2str(kk) '=single(zeros(gy, gx, gz));'])
        eval(['Y' num2str(kk) '(:,:,kk)=g(:,:,kk);'])
end
    
blurred = single(zeros(gy, gx, gz));
    
for kk = 1:gz,
    eval(['blurred_temp = real(ifftn(H{' num2str(kk) '}.*fftn(Y' num2str(kk) ')));'])
    blurred = blurred + blurred_temp;
end

blurred_bars = uint16(blurred);
save blurred_bars blurred_bars

%% Save tif 2D images
for z=1:9
    tmp = zeros(256,256);
    tmp = uint16(blurred(:,:,z));
    eval(['imwrite(tmp,''blurred_bars000' num2str(z) '.tif'')']);
end

for z=10:99
    tmp = zeros(256,256);
    tmp = uint16(blurred(:,:,z));
    eval(['imwrite(tmp,''blurred_bars00' num2str(z) '.tif'')']);
end
for z=100:gz
    tmp = zeros(256,256);
    tmp = uint16(blurred(:,:,z));
    eval(['imwrite(tmp,''blurred_bars0' num2str(z) '.tif'')']);
end

%% Generate Noise
I=single(blurred_bars);
GauSNR = 10;

%// Add noise to image     
v = var(I(:)) / (10^(GauSNR/10));
m=0;
noise2 = randn(size(I))*sqrt(v) + m;
I_noisy = single(blurred_bars) + noise2;
I_noisy_poisson=imnoise(uint16(I_noisy),'poisson');

%% save tif 2D images
for z=1:9
    %tmp = zeros(256,256);
    tmp = uint16(I_noisy_poisson(:,:,z));
    eval(['imwrite(tmp,''bars_G10_P_000' num2str(z) '.tif'')']);
end

for z=10:99
    %tmp = zeros(256,256);
    tmp = uint16(I_noisy_poisson(:,:,z));
    eval(['imwrite(tmp,''bars_G10_P_00' num2str(z) '.tif'')']);
end

for z=100:128
    %tmp = zeros(256,256);
    tmp = uint16(I_noisy_poisson(:,:,z));
    eval(['imwrite(tmp,''bars_G10_P_0' num2str(z) '.tif'')']);
end
