%
%      This HDR Toolbox demo creates an LDR stack from an HDR image:
%	   1) Read a stack of LDR images
%	   2) Read exposure values from the EXIF
%	   3) Estimate the Camera Response Function (CRF)
%	   4) Build the radiance map using the stack and stack_exposure
%	   5) Save the radiance map in .hdr format
%	   6) Show the tone mapped version of the radiance map
%
%       Author: Francesco Banterle
%       Copyright 2016 (c)
%

clear all;clc

img = hdrimread('Bottles_Small.hdr');

name_folder_h = 'output/hdr_to_stack_histogram';
name_folder_u = 'output/hdr_to_stack_uniform';
name_folder_s = 'output/hdr_to_stack_selected';

format = 'jpg';

load('CRF_from_demo.mat');


%Histogram
% table = exp(lin_fun_1);
% 
% 
% mkdir(name_folder_h);
% 
% [stack, stack_exposure] = CreateLDRStackFromHDR( img, 2, 'histogram', 'LUT', table);
% 
% for i=1:size(stack, 4)
%     name_out = [name_folder_h, '/exp_', num2str(stack_exposure(i)), '.', format];
%     imwrite(stack(:,:,:,i), name_out);
% end
% 
% %
% % Uniform
% %
% 
% mkdir(name_folder_u);
% 
% [stack, stack_exposure] = CreateLDRStackFromHDR( img, 2, 'uniform', 'gamma', 2.2);
% 
% for i=1:size(stack, 4)
%     name_out = [name_folder_u, '/exp_', num2str(stack_exposure(i)), '.', format];
%     imwrite(stack(:,:,:,i), name_out);
% end

% %
% % Selected
% %
% 
mkdir(name_folder_s);

selected_exps = [-2.0 0.0 1.0];

[stack, stack_exposure] = CreateLDRStackFromHDR( img, selected_exps, 'selected', 'LUT', lin_fun_1);

for i=1:size(stack, 4)
    name_out = [name_folder_s, '/exp_', num2str(stack_exposure(i)), '.', format];
    imwrite(stack(:,:,:,i), name_out);
end
