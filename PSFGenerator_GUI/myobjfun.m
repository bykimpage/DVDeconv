function f_val = myobjfun(find_par,f,g,fixed_par)

[gy gx gz] = size(g);

fj = single(zeros(gy,gx,gz));
fj = g;
h = PSFa(fixed_par(1),fixed_par(2),fixed_par(3),fixed_par(4),fixed_par(5),fixed_par(6),fixed_par(7),fixed_par(8),fixed_par(9),find_par(1),find_par(2),find_par(3),find_par(4));

H = single(psf2otf(h,size(g)));

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

Y = max(G{2} + lambda*(G{2} - G{3}),0);

fh = single(zeros(gy, gx, gz));
fh = real(ifftn(H.*fftn(Y)));

fh = fh + read_out_c;
fh(fh == 0) = eps;


f_val=-(sum(g(:).*log(fh(:))-fh(:)));