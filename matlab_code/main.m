clc;clear

%% Load Images
path = 'memorial.hdr';

hdr = hdrread(path);
hdr(hdr < 0) = 0;

%% Load CRF (Camera respond function)
load('CRF.mat');

%% Construct SVE image
E = hdr;

exptime = [-4 -1];
delta_ts = 2^exptime(1);
delta_tl = 2^exptime(2);

IS = tabledFunction(N * delta_ts, table, 0);
IL = tabledFunction(N * delta_tl, table, 0);

imshowpair(IS,IL,'montage');

[m,n,~] = size(E);
Iraw = zeros(m,n);
Iraw(1 : 4 : end,1 : 2 : end) = IS(1 : 4 : end,1 : 2 : end,1);
Iraw(1 : 4 : end,2 : 2 : end) = IS(1 : 4 : end,2 : 2 : end,2);
Iraw(2 : 4 : end,1 : 2 : end) = IS(2 : 4 : end,1 : 2 : end,2);
Iraw(2 : 4 : end,2 : 2 : end) = IS(2 : 4 : end,2 : 2 : end,3);
Iraw(3 : 4 : end,1 : 2 : end) = IL(3 : 4 : end,1 : 2 : end,1);
Iraw(3 : 4 : end,2 : 2 : end) = IL(3 : 4 : end,2 : 2 : end,2);
Iraw(4 : 4 : end,1 : 2 : end) = IL(4 : 4 : end,1 : 2 : end,2);
Iraw(4 : 4 : end,2 : 2 : end) = IL(4 : 4 : end,2 : 2 : end,3);

%% Convert to radiance
x = (0 : 255) / 255;
A = zeros(size(Iraw));
img = single(Iraw);

A(1 : 2 : end, 1 : 2 : end) =  ...
    interp1(x, table(:,1), img(1 : 2 : end, 1 : 2 : end), 'nearest', 'extrap');
% green pixels -> irradiance
A(1 : 2 : end, 2 : 2 : end) =  ...
    interp1(x, table(:,2), img(1 : 2 : end, 2 : 2 : end), 'nearest', 'extrap');
A(2 : 2 : end, 1 : 2 : end) =  ...
    interp1(x, table(:,2), img(2 : 2 : end, 1 : 2 : end), 'nearest', 'extrap');
% blue pixels -> irradiance
A(2 : 2 : end, 2 : 2 : end) =  ...
    interp1(x, table(:,3), img(2 : 2 : end, 2 : 2 : end), 'nearest', 'extrap');

delta_value = 1.0 / 65536.0;
E_hat = zeros(size(A));
E_hat(1 : 4 : end,:,:) = log(A(1 : 4 : end,:,:) + delta_value) - log(delta_ts);
E_hat(2 : 4 : end,:,:) = log(A(2 : 4 : end,:,:) + delta_value) - log(delta_ts);
E_hat(3 : 4 : end,:,:) = log(A(3 : 4 : end,:,:) + delta_value) - log(delta_tl);
E_hat(4 : 4 : end,:,:) = log(A(4 : 4 : end,:,:) + delta_value) - log(delta_tl);
E_hat = exp(E_hat);

%% HDR image reconstruction
caffe.set_mode_gpu();
gpu_id = 1;
caffe.set_device(gpu_id);


model_dir = 'WEIGHTS/';

net_weights = [model_dir 'APSIPA/HDR_iter_150000.caffemodel'];
net_model = '/HDR_mat.prototxt';
HDR_Bayer = CNN(E_hat, 32, 16, net_weights, net_model);
J = double(HDR_Bayer);
D = CFAIHamiltonAdams(J, 2);
D(D < 0) = 0;
HDR_apsipa = D;

imshowpair(GammaTMO(ReinhardTMO(N, 0.18), 2.2, 0, 0), GammaTMO(ReinhardTMO(HDR_apsipa, 0.18), 2.2, 0, 0), 'montage');


















