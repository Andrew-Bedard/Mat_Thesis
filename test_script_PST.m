% % test script to test PST function
% 
% %clc  % clear screen
% %clear all  % clear all variables
% %close all   % close all figures
% 
% % import original image
% Image_orig=imread('Nanos2ega2.jpg');
% 
% % if image is a color image, convert it to grayscale
% try
%     Image_orig=rgb2gray(Image_orig);
% catch
% end
% 
% 
% % convert the grayscale image do a 2D double array
% Image_orig=double(Image_orig);

Image_orig = Ivessel;

% low-pass filtering (also called localization) parameter
handles.LPF=0.517; % Gaussian low-pass filter Full Width at Half Maximum (FWHM) (min:0 , max : 1)

% PST parameters
handles.Phase_strength=2;  % PST  kernel Phase Strength
handles.Warp_strength=20;  % PST Kernel Warp Strength

% Thresholding parameters (for post processing)
handles.Thresh_min=-0.00017;      % minimum Threshold  (a number between 0 and -1)
handles.Thresh_max=0.9610;  % maximum Threshold  (a number between 0 and 1)

% Apply PST and find features (sharp transitions)
[Edge, ~]= PST(Image_orig,handles,1);

% Edge = Im_crop(Edge,5);
% Edge = pst2edge(Edge,4);
% Edge = bwareafilt(Edge,1,'largest');
% Edge = pst2edge(Edge,4);
% Edge = bwareafilt(Edge,1,'largest');
% Edge = bwperim(Edge);
% 
% % Lazy smoothing
% dilated = imdilate(Edge,strel('disk',7));
% thinned = bwmorph(dilated,'thin',inf);
% Edge = thinned;

    
% overlay original image with detected features
overlay = double(imoverlay(Image_orig, Edge/1000000, [1 0 0]));
figure
imshow(overlay/max(max(max(overlay))));
title('Detected features using PST overlaid with original image')


% show the PST phase kernel gradient
% figure
% [D_PST_Kernel_x D_PST_Kernel_y]=gradient(PST_Kernel);
% mesh(sqrt(D_PST_Kernel_x.^2+D_PST_Kernel_y.^2))
% title('PST Kernel phase Gradient')

% Edge = Im_crop(Edge,5);
% Edge = pst2edge(Edge,4);
% Edge = bwareafilt(Edge,1,'largest');
% Edge = pst2edge(Edge,4);
% Edge = bwareafilt(Edge,1,'largest');
% Edge = bwperim(Edge);
% figure();
% imshow(Edge);




