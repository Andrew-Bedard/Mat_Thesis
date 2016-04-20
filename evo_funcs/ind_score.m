function out_score = ind_score(Ind_vec, Image_orig, Manual_outline)
%IND_SCORE Summary of this function goes here
%   Uses PST to evaulate each individual and assign a score

% low-pass filtering (also called localization) parameter
handles.LPF=Ind_vec(1); % Gaussian low-pass filter Full Width at Half Maximum (FWHM) (min:0 , max : 1)

% PST parameters
handles.Phase_strength=Ind_vec(2);  % PST  kernel Phase Strength
handles.Warp_strength=Ind_vec(3);   % PST Kernel Warp Strength

% Thresholding parameters (for post processing)
handles.Thresh_min=Ind_vec(4);  % minimum Threshold  (a number between 0 and -1)
handles.Thresh_max=Ind_vec(5);  % maximum Threshold  (a number between 0 and 1)

% choose to compute the analog or digital edge
Morph_flag = 1 ; %  Morph_flag=0 to compute analog edge and Morph_flag=1 to compute digital edge.

% Apply PST and find features (sharp transitions)
[Edge, ~]= PST(Image_orig,handles,Morph_flag);

% Score for 
score = 0;

%Crop boundaries(by setting = 0) of Edge such that the edges that PST inevitably detect
%near the boundaries of the origional image do not affec the score at all

Edge = Im_crop(Edge,5);
Edge = pst2edge(Edge,4);
Edge = bwareafilt(Edge,1,'largest');
Edge = pst2edge(Edge,4);
Edge = bwareafilt(Edge,1,'largest');
Edge = bwperim(Edge);

%
for i = 1:length(Edge(:,1))
    for j = 1:length(Edge(1,:))
        if Manual_outline(i,j) == 1 && Edge(i,j) == 1
            score = score + 0.2;
%         elseif Manual_outline(i,j) == 0 && Edge(i,j) == 0
%             score = score + 0.005;
        elseif Manual_outline(i,j) == 0 && Edge(i,j) ==1
            score = score - 0.05;
        end
    end
end


% overlay = double(imoverlay(Manual_outline, Edge/1000000, [1 0 0]));
% figure
% imshow(overlay);
% title('Detected features using PST overlaid with manual outline')

out_score = score;

end

