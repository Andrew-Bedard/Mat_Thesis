function [Edge, imtest] = evo_pst_test(population, win_ind, Image_orig,I_name,k,bdry, imsave)

% Population = array of all individuals with their associated parameters
% win_ind = fittest individual
% Image_orig = original image
% I_name = name of image
% k = current generation ( used for naming only)
% bdry = inner or outer boundary, for file selection and naming
%imsave= save image, boolean


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


Edge = pst2edge(Edge,4);

% Lazy smoothing
dilated = imdilate(Edge,strel('disk',7));
thinned = bwmorph(dilated,'thin',inf);

Edge = imfill(thinned,'holes');

%Added canny edge detection for improved smoothing!!!!!!
Edge = edge(Edge,'canny',[],10);



if Morph_flag ==0
    % show the detected features    
    subplot(1,2,2)
    imshow(Edge/max(max(Edge))*3)
    title('Detected features using PST')
    
else  
    
    % overlay original image with detected features
    overlay = double(imoverlay(Image_orig, Edge/1000000, [1 0 0]));
    figure
    imtest = imshow(overlay/max(max(max(overlay))));
    title('Detected features using PST overlaid with original image')
    % Save image as jpg and close figure window
    if imsave == true
        saveas(imtest,sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Kahikai/EA_prog/%s/%s/%d_gens',bdry,I_name,k),'jpg');
    end
    close figure 1
end








