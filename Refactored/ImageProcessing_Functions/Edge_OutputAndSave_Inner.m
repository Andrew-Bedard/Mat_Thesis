function [Edge, Edge_overlay] = Edge_OutputAndSave_Inner(fittest_individual_Inner,...
    Outer_Edge, Image_orig, Image_name, current_generation, boundary_name, Save_bool)

%EDGE_OUTPUTANDSAVE: takes parameters of fittest individual, performs
%standar image processing with added canny edge detection for extra
%boundary smoothing, creates overlay image and saves if Save_bool == true

% low-pass filtering (also called localization) parameter
handles.LPF=fittest_individual_Inner(1); % Gaussian low-pass filter Full Width at Half Maximum (FWHM) (min:0 , max : 1)

% PST parameters
handles.Phase_strength=fittest_individual_Inner(2);  % PST  kernel Phase Strength
handles.Warp_strength=fittest_individual_Inner(3);  % PST Kernel Warp Strength

% Thresholding parameters (for post processing)
handles.Thresh_min=-fittest_individual_Inner(4);      % minimum Threshold  (a number between 0 and -1)
handles.Thresh_max=fittest_individual_Inner(5);  % maximum Threshold  (a number between 0 and 1)

% Get parameters for Frangi filter, then apply filter
Frangi_options = struct('FrangiScaleRange', [1 fittest_individual_Inner(6)], 'FrangiScaleRatio', fittest_individual_Inner(7), ...
    'FrangiBetaOne', fittest_individual_Inner(8), 'FrangiBetaTwo', fittest_individual_Inner(9),...
    'verbose',false,'BlackWhite',fittest_individual_Inner(10));

Frangi_image = FrangiFilter2D(Image_orig,Frangi_options);

% Apply PST and find features (sharp transitions)
[Edge, ~]= PST(Frangi_image,handles,1);

%Remove noise, smooth and select outer edge of object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Inner_Edge = Edge;
se = strel('disk',3,8);
Inner_Edge = imdilate(Inner_Edge,se);
Inner_Edge = bwareafilt(Inner_Edge,1,'largest');
Inner_Edge = imdilate(Inner_Edge,se);
Inner_Edge = imerode(Inner_Edge,se);
Inner_Edge = bwareafilt(Inner_Edge,1,'largest');
Inner_Edge = imcomplement(Inner_Edge);


% FIll outer edge calculated from EA_loop
Outer_Edge = imfill(Outer_Edge, 'holes');


%%%% Remove everything not inside calculated outer edge%%%%%

array_size = size(Outer_Edge);

for i = 1:array_size(1)
    for j = 1:array_size(2)
        if Outer_Edge(i,j) == 0
            Inner_Edge(i,j) = 0;
        end
    end
end

%%%More image processing

Inner_Edge = logical(Inner_Edge);
Inner_Edge = bwareafilt(Inner_Edge,1,'largest');
Inner_Edge = imerode(Inner_Edge,se);
Inner_Edge = imdilate(Inner_Edge,strel('disk',7));
Inner_Edge = bwperim(Inner_Edge);
Inner_Edge = bwareafilt(Inner_Edge,1,'largest');

Inner_Edge = imfill(Inner_Edge,'holes');
Inner_Edge = edge(Inner_Edge,'canny',[],8);

% overlay original image with detected features
overlay = double(imoverlay(Image_orig, Inner_Edge/1000000, [1 0 0]));
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