I_name = 'FGF8A';

Image_orig=imread(sprintf('%s.jpg',I_name));

Image_orig = rgb2gray(Image_orig);

% params = load(sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Kahikai/EA_prog/Outer/%s/fittest_ind.mat',I_name));
% 
% params = struct2array(params);

% low-pass filtering (also called localization) parameter
handles.LPF=params(1); % Gaussian low-pass filter Full Width at Half Maximum (FWHM) (min:0 , max : 1)

% PST parameters
handles.Phase_strength=params(2);  % PST  kernel Phase Strength
handles.Warp_strength=params(3);  % PST Kernel Warp Strength

% Thresholding parameters (for post processing)
handles.Thresh_min=params(4);      % minimum Threshold  (a number between 0 and -1)
handles.Thresh_max=params(5);  % maximum Threshold  (a number between 0 and 1)

[Edge,~] = PST(Image_orig,handles,1);

Edge = Im_crop(Edge,5);
Edge = pst2edge(Edge,4);
Edge = bwareafilt(Edge,1,'largest');
Edge = pst2edge(Edge,4);
Edge = bwareafilt(Edge,1,'largest');
Edge = bwperim(Edge);

% Lazy smoothing
dilated = imdilate(Edge,strel('disk',7));
thinned = bwmorph(dilated,'thin',inf);
outedge = thinned;

% overlay original image with detected features
overlay = double(imoverlay(Image_orig, Edge/1000000, [1 0 0]));
figure
imshow(overlay/max(max(max(overlay))));
title('Detected features using PST overlaid with original image')