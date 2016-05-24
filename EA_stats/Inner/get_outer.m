function [Out_Edge] = get_outer(I_name)

%Comes up with outer edge based on pre-calculated optimal parameters

% import original image
Image_orig=imread(sprintf('%s.jpg',I_name));

% Load parameters from fittest individual of last run to determine outer
% edge
Params = load(fullfile('C:','Users','Andy','Documents','School','Thesis','Images','Kahikai','EA_prog','Outer',sprintf('%s',I_name),'fittest_ind.mat'));
Params = struct2array(Params);

% if image is a color image, convert it to grayscale
try
    Image_orig=rgb2gray(Image_orig);
catch
end

% convert the grayscale image do a 2D double array
Image_orig=double(Image_orig);


% low-pass filtering (also called localization) parameter
handles.LPF=Params(1); % Gaussian low-pass filter Full Width at Half Maximum (FWHM) (min:0 , max : 1)

% PST parameters
handles.Phase_strength=Params(2);  % PST  kernel Phase Strength
handles.Warp_strength=Params(3);  % PST Kernel Warp Strength

% Thresholding parameters (for post processing)
handles.Thresh_min=Params(4);      % minimum Threshold  (a number between 0 and -1)
handles.Thresh_max=Params(5);  % maximum Threshold  (a number between 0 and 1)

% Apply PST and find features (sharp transitions)
[Edge, ~]= PST(Image_orig,handles,1);

Edge = Im_crop(Edge,5);
Edge = pst2edge(Edge,4);
Edge = bwareafilt(Edge,1,'largest');
Edge = pst2edge(Edge,4);
Edge = bwareafilt(Edge,1,'largest');
Edge = bwperim(Edge);

% Lazy smoothing
dilated = imdilate(Edge,strel('disk',7));
thinned = bwmorph(dilated,'thin',inf);
Edge = thinned;

Out_Edge = Edge;





