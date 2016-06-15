function fitness_score = individual_fitness_inner(Individual_params, Image_orig,...
    Manual_outline, Outer_Edge)
%INDIVIDUAL_FITNESS: calculates the fitness score of each individual in the
% population


% low-pass filtering (also called localization) parameter
handles.LPF=Individual_params(1); % Gaussian low-pass filter Full Width at Half Maximum (FWHM) (min:0 , max : 1)

% PST parameters
handles.Phase_strength=Individual_params(2);  % PST  kernel Phase Strength
handles.Warp_strength=Individual_params(3);   % PST Kernel Warp Strength

% Thresholding parameters (for post processing)
handles.Thresh_min=Individual_params(4);  % minimum Threshold  (a number between 0 and -1)
handles.Thresh_max=Individual_params(5);  % maximum Threshold  (a number between 0 and 1)

% choose to compute the analog or digital edge
Morph_flag = 1 ; %  Morph_flag=0 to compute analog edge and Morph_flag=1 to compute digital edge.

% Get parameters for Frangi filter, then apply filter
Frangi_options = struct('FrangiScaleRange', [1 Individual_params(6)], 'FrangiScaleRatio', Individual_params(7), ...
    'FrangiBetaOne', Individual_params(8), 'FrangiBetaTwo', Individual_params(9),...
    'verbose',false,'BlackWhite',Individual_params(10));

Frangi_image = FrangiFilter2D(Image_orig,Frangi_options);

% Apply PST and find features (sharp transitions)
[Edge, ~]= PST(Frangi_image,handles,Morph_flag);

%Crop boundaries, remove noise, smooth and select outer edge of object
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Inner_Edge = Edge;
se = strel('disk',3,8);
Inner_Edge = imdilate(Inner_Edge,se);
Inner_Edge = bwareafilt(Inner_Edge,1,'largest');
Inner_Edge = imdilate(Inner_Edge,se);
Inner_Edge = imerode(Inner_Edge,se);
Inner_Edge = bwareafilt(Inner_Edge,1,'largest');
Inner_Edge = imcomplement(Inner_Edge);



%GRAB OUTER EDGE CALCULATED FROM PARAMATERS OF FITTEST INDIVIDUAL 

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

%Compare all pixels of image, subtract 1 from score every time pixel does
%not match

% Score 
score = 0;

for i = 1:length(Inner_Edge(:,1))
    for j = 1:length(Inner_Edge(1,:))
        if Manual_outline(i,j) == 1 && Inner_Edge(i,j) == 0
            score = score - 1;
        elseif Manual_outline(i,j) == 0 && Inner_Edge(i,j) == 1
            score = score - 1;
        end
    end
end

fitness_score = score;