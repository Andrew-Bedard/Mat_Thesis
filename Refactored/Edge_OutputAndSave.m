function [Edge, Edge_overlay] = Edge_OutputAndSave(fittest_individual,...
    Image_orig, Image_name, current_generation, boundary_name, Save_bool)

%EDGE_OUTPUTANDSAVE: takes parameters of fittest individual, performs
%standar image processing with added canny edge detection for extra
%boundary smoothing, creates overlay image and saves if Save_bool == true

% low-pass filtering (also called localization) parameter
handles.LPF=fittest_individual(1); % Gaussian low-pass filter Full Width at Half Maximum (FWHM) (min:0 , max : 1)

% PST parameters
handles.Phase_strength=fittest_individual(2);  % PST  kernel Phase Strength
handles.Warp_strength=fittest_individual(3);  % PST Kernel Warp Strength

% Thresholding parameters (for post processing)
handles.Thresh_min=-fittest_individual(4);      % minimum Threshold  (a number between 0 and -1)
handles.Thresh_max=fittest_individual(5);  % maximum Threshold  (a number between 0 and 1)

% Apply PST and find features (sharp transitions)
[Edge , ~]= PST(Image_orig,handles,1);

% Image processing

Edge = pst2edge(Edge,3);

% Lazy smoothing
Edge = imdilate(Edge,strel('disk',7));
Edge = bwmorph(Edge,'thin',inf);
Edge = imfill(Edge,'holes');
Edge = edge(Edge,'canny',[],10);

% overlay original image with detected features
overlay = double(imoverlay(Image_orig, Edge/1000000, [1 0 0]));
figure
Edge_overlay = imshow(overlay/max(max(max(overlay))));
title('Detected features using PST overlaid with original image')
% Save image (if Save_bool == true) as jpg and close figure window
if Save_bool == true
    saveas(Edge_overlay,sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Kahikai/EA_prog/%s/%s/%d_gens',...
        boundary_name,Image_name,current_generation),'jpg');
end
pause(3);
close figure 1