function [Edge] = evo_pst(population, win_ind, Image_orig)

% test script to test PST function


%show the original image
% subplot(1,2,1)
% imshow(Image_orig)
% title('Original Image')

% low-pass filtering (also called localization) parameter
handles.LPF=population(win_ind,1); % Gaussian low-pass filter Full Width at Half Maximum (FWHM) (min:0 , max : 1)

% PST parameters
handles.Phase_strength=population(win_ind,2);  % PST  kernel Phase Strength
handles.Warp_strength=population(win_ind,3);  % PST Kernel Warp Strength

% Thresholding parameters (for post processing)
handles.Thresh_min=-population(win_ind,4);      % minimum Threshold  (a number between 0 and -1)
handles.Thresh_max=population(win_ind,5);  % maximum Threshold  (a number between 0 and 1)

% choose to compute the analog or digital edge
Morph_flag = 1 ; %  Morph_flag=0 to compute analog edge and Morph_flag=1 to compute digital edge.

% Apply PST and find features (sharp transitions)
[Edge , ~]= PST(Image_orig,handles,Morph_flag);

Edge = Im_crop(Edge,5);
Edge = pst2edge(Edge,4);
Edge = bwareafilt(Edge,1,'largest');
Edge = pst2edge(Edge,4);
Edge = bwareafilt(Edge,1,'largest');
Edge = bwperim(Edge);

if Morph_flag ==0
    % show the detected features    
    subplot(1,2,2)
    imshow(Edge/max(max(Edge))*3)
    title('Detected features using PST')
   
else
%     subplot(1,2,2)
%     imshow(Edge)
%     title('Detected features using PST')
    
    % overlay original image with detected features
    overlay = double(imoverlay(Image_orig, Edge/1000000, [1 0 0]));
    figure
    imshow(overlay/max(max(max(overlay))));
    title('Detected features using PST overlaid with original image')
end

% show the PST phase kernel gradient
% figure
% [D_PST_Kernel_x D_PST_Kernel_y]=gradient(PST_Kernel);
% mesh(sqrt(D_PST_Kernel_x.^2+D_PST_Kernel_y.^2))
% title('PST Kernel phase Gradient')






