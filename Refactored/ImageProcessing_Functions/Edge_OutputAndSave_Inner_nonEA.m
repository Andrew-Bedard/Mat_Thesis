function [Edge] = Edge_OutputAndSave_Inner_nonEA(fittest_individual_outer,...
    Outer_Edge, Image_orig, Image_name, current_generation, boundary_name, Show_im, Save_bool)

%EDGE_OUTPUTANDSAVE: takes parameters of fittest individual, performs
%standar image processing with added canny edge detection for extra
%boundary smoothing, creates overlay image and saves if Save_bool == true

% low-pass filtering (also called localization) parameter
handles.LPF=fittest_individual_outer(1); % Gaussian low-pass filter Full Width at Half Maximum (FWHM) (min:0 , max : 1)

% PST parameters
handles.Phase_strength=fittest_individual_outer(2);  % PST  kernel Phase Strength
handles.Warp_strength=fittest_individual_outer(3);  % PST Kernel Warp Strength

% Thresholding parameters (for post processing)
handles.Thresh_min=-fittest_individual_outer(4);      % minimum Threshold  (a number between 0 and -1)
handles.Thresh_max=fittest_individual_outer(5);  % maximum Threshold  (a number between 0 and 1)

% Get parameters for Frangi filter, then apply filter
Frangi_options = struct('FrangiScaleRange', [1 8], 'FrangiScaleRatio', 2, 'FrangiBetaOne', 0.99, 'FrangiBetaTwo', 4, 'verbose',false,'BlackWhite',true);

Frangi_image = FrangiFilter2D(Image_orig,Frangi_options);

% Apply PST and find features (sharp transitions)
[Edge, ~]= PST(Frangi_image,handles,1);

%Remove noise, smooth and select outer edge of object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


se = strel('disk',3,8);
Edge = imdilate(Edge,se);
Edge = bwareafilt(Edge,1,'largest');
Edge = imdilate(Edge,se);
Edge = imerode(Edge,se);
Edge = bwareafilt(Edge,1,'largest');
Edge = imcomplement(Edge);


% FIll outer edge calculated from EA_loop
Outer_Edge = imfill(Outer_Edge, 'holes');


%%%% Remove everything not inside calculated outer edge%%%%%

array_size = size(Outer_Edge);

for i = 1:array_size(1)
    for j = 1:array_size(2)
        if Outer_Edge(i,j) == 0
            Edge(i,j) = 0;
        end
    end
end

%%%More image processing

Edge = logical(Edge);
Edge = bwareafilt(Edge,1,'largest');
Edge = imerode(Edge,se);
Edge = imdilate(Edge,strel('disk',7));
Edge = bwperim(Edge);
Edge = bwareafilt(Edge,1,'largest');

Edge = imfill(Edge,'holes');
Edge = edge(Edge,'canny',[],8);
Edge = bwareafilt(Edge,1,'largest');

    
if Show_im == true
    % overlay original image with detected features
    overlay = double(imoverlay(Image_orig, Edge/1000000, [1 0 0]));
    Edge_overlay = (overlay/max(max(max(overlay))));
    figure
    imshow(Edge_overlay);
    title('Detected features using PST overlaid with original image')
    pause(3);
    close figure 1
end
% Save image (if Save_bool == true) as jpg and close figure window
if Save_bool == true
    saveas(Edge_overlay,sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Kahikai/EA_prog/%s/%s/%d_gens',...
        boundary_name,Image_name,current_generation),'jpg');
end