function [ Edge_new ] = pst2edge( Raw_pst_edge, dilation_size )
%pst2edge: takes as input edges detected directly from PST (Raw_pst_edge)
%and dilation_size, using standard image processing methods by dilating and
%eroding image creates continuous outline of edge object we are trying to
%detect

%Crop image to avoid boundaries of image from appearing as edge.
Edge = Image_crop(Raw_pst_edge,5);

% Dilate the Image

%Properties for dilation
se = strel('disk',dilation_size, 8);

Edge = imdilate(Edge, se);

%Fill Interior Gaps 
Edge = imfill(Edge, 'holes');

%Smoothen the Object boundaries

seD = strel('disk', dilation_size*2, 8);
Edge = imerode(Edge,seD);

%Get rid of all detected edges outside the largest object detected
Edge = bwareafilt(Edge,1,'largest');

%Get rid of everything inside the outer edge of binary image
Edge_new = bwperim(Edge);
end

