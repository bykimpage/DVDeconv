function f = DV_OSL(g, h, a, iter, Every_save_check, file_type)

% g : observed image
% H : name of psf mat
% a : regularization
% Every_save_check : every time save (0) off (1) on
% file_type : (0) tif  (1) mat
% Last Modified: 2018/02/26
% For additional information and citations, please refer to:
% [1] Kim, Boyoung, and Takeshi Naemura. "Blind depth-variant deconvolution of 3D data in wide-field fluorescence microscopy." Scientific reports 5 (2015).
% [2] Kim, Boyoung, and Takeshi Naemura. "Blind deconvolution of 3D fluorescence microscopy using depth?variant asymmetric PSF." Microscopy research and technique 79.6 (2016): 480-494.

if nargin==4
    a=0.001;
    iter = 10;
    
elseif (nargin~=4) && (nargin~=6)
    error('The # of inputs is not valid \n');
end

[gy gx gz] = size(g);

for num = 1:gz
    eval(['fj' num2str(num) ' = single(zeros(gy,gx,gz) );']);
    eval(['fj' num2str(num) '(:,:,num) = g(:,:,num);']);
end


for num = 1: gz
    %eval(['load h' num2str(num) ' h' num2str(num) ' ']);
    %eval(['H' num2str(num) '= single(psf2otf(h' num2str(num) ',[gy gx gz]));'])
    eval(['H{' num2str(num) '} = single(psf2otf(h{1,' num2str(num) '}, size(g)));']);
    %eval(['clear h' num2str(num) '  h' num2str(num) ' ']);
end

% L=[];
% F=[];

G{1} = g;

%readout noise
read_out_c = 100;
weight = single(ones(gy, gx, gz));
read_out = single(max(weight.*(read_out_c + G{1}),0));

if length(G{1})<2,
    error(message('input image must have at least 2 elements'))
elseif ~isa(G{1},'double'),
    G{1} = im2double(G{1});
end

G{2} = G{1};
G{3} = 0;
G{2} = G{2}((1:gy)', (1:gx)', (1:gz)');
G{4}(prod(gy*gx*gz),2) = 0;

for num = 1:gz
    eval(['scale{' num2str(num) '} = single(real(ifftn(conj(H{' num2str(num) '}).*fftn(weight((1:gy)'', (1:gx)'', (1:gz)'')))) + sqrt(eps));'])
end

lambda = 0;

disp('iteration')
for k = 1:iter
    disp(k)
    
    if k > 2,
        lambda = (G{4}(:,1).'*G{4}(:,2))/(G{4}(:,2).'*G{4}(:,2) +eps);
        lambda = max(min(lambda,1),0);
    end
    
    Y = max(G{2} + lambda*(G{2} - G{3}),0);
    
    for kk = 1:gz
        eval(['Y' num2str(kk) '=single(zeros(gy, gx, gz));'])
        eval(['Y' num2str(kk) '(:,:,kk)=Y(:,:,kk);'])
    end
    
    re_blurred = single(zeros(gy, gx, gz));
    
    for kk = 1:gz,
        eval(['re_blurred_temp = real(ifftn(H{' num2str(kk) '}.*fftn(Y' num2str(kk) ')));'])
        re_blurred = re_blurred + re_blurred_temp;
    end
    
    re_blurred = re_blurred + read_out_c;
    re_blurred(re_blurred == 0) = eps;
    estim = read_out./re_blurred + eps;
    
    ratio = estim((1:gy)', (1:gx)', (1:gz)');
    E = fftn(ratio);
    
    G{3} = G{2};
    ej=single(zeros(gy, gx, gz));
    
    for kk = 1:gz
        eval(['tt = real(ifftn(conj(H{' num2str(kk) '}).*E))./scale{' num2str(kk) '};'])
        ej(:,:,kk) =tt(:,:,kk);
    end
    
    for kk = 1:gz
        eval(['Y' num2str(kk) ' = max((Y' num2str(kk) '.*ej),0);'])
        eval(['C(:,:,kk)= Y' num2str(kk) '(:,:,kk);'])
    end
    
    clear E
    
    temp_G = C;
    
    
    fj_R = temp_G;    fj_R(:,2:end,:) = temp_G(:,1:end-1,:);  %f(i,j-1,k)
    fj_L = temp_G;     fj_L(:,1:end-1,:) = temp_G(:,2:end,:);  %f(i,j+1,k)
    fj_U = temp_G;     fj_U(2:end,:,:) = temp_G(1:end-1,:,:);  %f(i-1,j,k)
    fj_D = temp_G;     fj_D(1:end-1,:,:) = temp_G(2:end,:,:);  %f(i+1,j,k)
    fj_H = temp_G;    fj_H(:,:,2:end) = temp_G(:,:,1:end-1);  %f(i,j,k-1)
    fj_LOW = temp_G;     fj_LOW(:,:,1:end-1) = temp_G(:,:,2:end);  %f(i,j,k+1)
    
    TV_grad = -(fj_L-temp_G)./sqrt((fj_L-temp_G).^2+eps) + (temp_G-fj_R)./sqrt((temp_G-fj_R).^2+eps)...
        - (fj_D-temp_G)./sqrt((fj_D-temp_G).^2+eps) + (temp_G-fj_U)./sqrt((temp_G-fj_U).^2+eps)...
        - (fj_LOW-temp_G)./sqrt((fj_LOW-temp_G).^2+eps) +(temp_G-fj_H)./sqrt((temp_G-fj_H).^2+eps);
    
    esti_fj = C ./(1+a*TV_grad);
    
    G{2} = esti_fj;
    G{4} = [G{2}(:)-Y(:) G{4}(:,1)];
    
    %     %likelihood
    %     L = sum(sum(sum(-re_blurred + g.*log(re_blurred))));
    %
    %     % total variation
    %     T = sum(sum(sum(sqrt((esti_fj-fj_R).^2+eps)+sqrt((esti_fj-fj_U).^2+eps)+sqrt((esti_fj-fj_H).^2+eps))));
    %     F_val = -L + a*T;
    %     F = [F F_val];
    f = G{2};
    if (Every_save_check == 1 && file_type == 1) % mat
        eval(['save DeconvOSL' num2str(k) ' f ']);
    elseif  (Every_save_check == 1 && file_type == 0) % tif
        for num=1:gz
            tmp_f = double(f(:,:,num));
            minD = min(tmp_f(:));
            maxD = max(tmp_f(:));
            mapped_image = (double(tmp_f) - minD) ./ (maxD - minD);
            eval(['imwrite(mapped_image, ''DeconvOSL' num2str(k) '.tiff'', ''WriteMode'', ''append'');']);
        end
    end
    
end

disp('iteration end')

%f = G{2};

end