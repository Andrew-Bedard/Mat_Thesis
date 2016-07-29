I_name = 'smad4-likeega2';

% import original image

Image_orig=imread(sprintf('%s.jpg',I_name));

%Import parameters from optimal soltn EA

params = load(sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Kahikai/EA_prog/Outer/Pre_smoothing/%s/fittest_ind.mat',I_name));

params = struct2array(params);
%params = fittest_individual_outer(1:5);
%Frangi%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options = struct('FrangiScaleRange', [1 8], 'FrangiScaleRatio', 2, 'FrangiBetaOne', 0.99, 'FrangiBetaTwo', 4, 'verbose',false,'BlackWhite',true);
Image_orig = rgb2gray(Image_orig);
I2=double(Image_orig);
Ivessel=FrangiFilter2D(I2, options);

%Pst%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% low-pass filtering (also called localization) parameter
handles.LPF=params(1); % Gaussian low-pass filter Full Width at Half Maximum (FWHM) (min:0 , max : 1)

% PST parameters
handles.Phase_strength=params(2);  % PST  kernel Phase Strength
handles.Warp_strength=params(3);  % PST Kernel Warp Strength

% Thresholding parameters (for post processing)
handles.Thresh_min=params(4);      % minimum Threshold  (a number between 0 and -1)
handles.Thresh_max=params(5);  % maximum Threshold  (a number between 0 and 1)

Morph_flag = 1;

% Apply PST and find features (sharp transitions)
[Edge, ~]= PST(Ivessel,handles, Morph_flag);


if Morph_flag ==0
    % show the detected features    
    figure()
    imshow(Edge/max(max(Edge))*3)
    title('Detected features using PST')
    
else

    figure()
    imshow(Edge)
    
    Edge_orig = Edge;

    %Image processing, dilating eroding and taking complement to get inner
    %area%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    e2 = Edge;
    se = strel('disk',3,8);
    e3 = imdilate(e2,se);
    %e_3 = bwmorph(e3,'bridge');
    e4 = bwareafilt(e3,1,'largest');
    e5 = imdilate(e4,se);
    e6 = imerode(e5,se);
    e6 = bwareafilt(e6,1,'largest');
    e7 = imcomplement(e6);


    %%%%%%% Get Outer Edge %%%%%%%%%

    [Edge,~] = PST(Image_orig,handles,1);


    Edge = pst2edge(Edge,4);

    % Lazy smoothing
    dilated = imdilate(Edge,strel('disk',7));
    thinned = bwmorph(dilated,'thin',inf);

    % New smoothing
    thinned = imfill(thinned,'holes');
    thinned = edge(thinned,'canny',[],10);
    outedge = thinned;

    %%%% Remove everything not inside calculated outer edge%%%%%
    filledout = imfill(outedge,'holes');
    for i = 1:280
        for j = 1:280
            if filledout(i,j) == 0
                e7(i,j) = 0;
            end
        end
    end

    %%%%% More image processing, dilating eroding and taking perimeter
    e8 = bwareafilt(e7,1,'largest');
    e9 = imerode(e8,se);
    dilated = imdilate(e9,strel('disk',7));
    new_edge = bwperim(dilated);
    new_edge = bwareafilt(new_edge,1,'largest');

    % New Smoothing
    % new_edge = imfill(new_edge,'holes');
    % new_edge = edge(new_edge,'canny',[],8);

    overlay = double(imoverlay(Image_orig, new_edge/1000000, [1 0 0]));
    figure
    imshow(overlay/max(max(max(overlay))));
    title('Detected features using PST overlaid with original image')
end