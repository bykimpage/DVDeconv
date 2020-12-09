function f = INV_OSL(g, h, a, iter, Every_save_check, file_type)

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

fj = single(zeros(gy,gx,gz));
fj = g;
H = single(psf2otf(h,size(g)));

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

scale = single(real(ifftn(conj(H).*fftn(weight((1:gy)'', (1:gx)'', (1:gz)'')))) + sqrt(eps));

lambda = 0;

disp('iteration')
for k = 1:iter
    disp(k)
    
    if k > 2,
        lambda = (G{4}(:,1).'*G{4}(:,2))/(G{4}(:,2).'*G{4}(:,2) +eps);
        lambda = max(min(lambda,1),0);
    end
    
    Y = max(G{2} + lambda*(G{2} - G{3}),0);
    
    re_blurred = single(zeros(gy, gx, gz));
    re_blurred = real(ifftn(H.*fftn(Y)));
    
    re_blurred = re_blurred + read_out_c;
    re_blurred(re_blurred == 0) = eps;
    estim = read_out./re_blurred + eps;
    
    ratio = estim((1:gy)', (1:gx)', (1:gz)');
    E = fftn(ratio);
    
    G{3} = G{2};
    ej=single(zeros(gy, gx, gz));
    ej = real(ifftn(conj(H).*E))./scale;
    Y= max((Y.*ej),0);
    C = Y;
    
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
        eval(['save DeconvInvOSL' num2str(k) ' f ']);
    elseif  (Every_save_check == 1 && file_type == 0) % tif
        for num=1:gz
            tmp_f = double(f(:,:,num));
            minD = min(tmp_f(:));
            maxD = max(tmp_f(:));
            mapped_image = (double(tmp_f) - minD) ./ (maxD - minD);
            eval(['imwrite(mapped_image, ''DeconvInvOSL' num2str(k) '.tiff'', ''WriteMode'', ''append'');']);
        end
    end
    
end

disp('iteration end')

%f = G{2};

end