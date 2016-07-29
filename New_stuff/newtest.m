% % test script to see if I can better detect inner edges
% 
% %clc  % clear screen
% %clear all  % clear all variables
% %close all   % close all figures
% 
% import original image
Image_orig=imread('smad4-likeega2.jpg');

% if image is a color image, convert it to grayscale
try
    Image_orig=rgb2gray(Image_orig);
catch
end

%import manual boundary


% convert the grayscale image do a 2D double array
Image_orig=double(Image_orig);

cum_edge = zeros(size(Image_orig));
count = 0;

%for lpf = 0.05:0.01:0.3
    for warp = 1:2:50
        for stren = 1:2:60
        %for minthresh = -0.0001:-0.00005:-0.01
    % low-pass filtering (also called localization) parameter
    handles.LPF=0.09; % Gaussian low-pass filter Full Width at Half Maximum (FWHM) (min:0 , max : 1)

    % PST parameters
    handles.Phase_strength=stren;  % PST  kernel Phase Strength
    handles.Warp_strength=warp    ;  % PST Kernel Warp Strength

    % Thresholding parameters (for post processing)
    handles.Thresh_min=-0.01;      % minimum Threshold  (a number between 0 and -1)
    handles.Thresh_max=0.9;  % maximum Threshold  (a number between 0 and 1)

    Morph_flag = 1;

    % Apply PST and find features (sharp transitions)
    [Edge1, ~]= PST(Image_orig,handles,Morph_flag);
    
    cum_edge = Edge1 + cum_edge;
    
    count = count+1;
    
    imshow(Edge1)
    
    %pause(0.);


        end
    end
%end

if Morph_flag ==0
    % show the detected features    
    figure()
    imshow(cum_edge/max(max(cum_edge))*3)
    title('Detected features using PST')
   
else
    
    %Edge = Image_crop(Edge,5);
    Edge = pst2edge(Edge1,4);
    % Edge = bwareafilt(Edge,1,'largest');
    % Edge = pst2edge(Edge,4);
    % Edge = bwareafilt(Edge,1,'largest');
    %Edge = bwperim(Edge);

    % Lazy smoothing
    dilated = imdilate(Edge,strel('disk',7));
    thinned = bwmorph(dilated,'thin',inf);
    Edge = thinned;

    new_edge = imfill(Edge,'holes');
    new_edge = edge(new_edge,'canny',[],10);


    % overlay original image with detected features
    overlay = double(imoverlay(Image_orig, new_edge/1000000, [1 0 0]));
    figure
    imshow(overlay/max(max(max(overlay))));
    title('Detected features using PST overlaid with original image')
    
    figure
    imshow(cum_edge);


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
end

edge2 = bwmorph(cum_edge,'majority');
edge3 = bwmorph(edge2,'bridge');
edge4 = bwmorph(edge3,'clean');
edge5 = imdilate(edge4,strel('disk',3,8));
edge6 = bwmorph(edge5,'bridge');
edge7 = bwareafilt(edge6,1);
figure;imshow(edge7)