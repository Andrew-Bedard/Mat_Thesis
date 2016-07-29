function fitness_score = individual_fitness(Individual_params, Image_orig, Manual_outline)
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

% Apply PST and find features (sharp transitions)
[Edge, ~]= PST(Image_orig,handles,Morph_flag);

%Crop boundaries, remove noise, smooth and select outer edge of object

Edge = pst2edge(Edge,3);
Edge = LazySmoothing(Edge, false);
Edge = imfill(Edge, 'holes');

%Fill in interior of Manual_outline to perform RMSE comparison of found
%edge with Manual_outline
Manual_outline = imfill(Manual_outline,'holes');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REPLACED THIS NESTED LOOP WITH MORE EFFICIENT CODE BELOW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Compare all pixels of image, subtract 1 from score every time pixel does
% %not match
% 
% % Score 
% score = 0;
% 
% for i = 1:length(Edge(:,1))
%     for j = 1:length(Edge(1,:))
%         if Manual_outline(i,j) == 1 && Edge(i,j) == 0
%             score = score - 1;
%         elseif Manual_outline(i,j) == 0 && Edge(i,j) == 1
%             score = score - 1;
%         end
%     end
% end
% 
% fitness_score = score;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%Test for gradient score%%%%%%%

%Orientations = skeletonOrientation(Edge,5);


%Compare all pixels of image, subtract 1 from score every time pixel does
%not match

%Score 
score = sum(sum(Manual_outline == Edge));
diff_score = length(Manual_outline)^2 - score;


fitness_score = -diff_score;