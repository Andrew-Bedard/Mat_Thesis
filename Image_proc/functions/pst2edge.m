function [ Edge_new ] = pst2edge( Edge )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

% taken from http://www.mathworks.com/help/images/examples/detecting-a-cell-using-image-segmentation.html?prodcode=IP

% strucforsomereason = load('C:\Users\Andy\Documents\School\Thesis\Mat_Thesis\Blast_outline\edge_test_1.mat');
% BWs = strucforsomereason.Edge;

BWs = Edge;

% Dilate the Image

se = strel('disk',3, 8);

BWsdil = imdilate(BWs, se);
% figure, imshow(BWsdil), title('dilated gradient mask');

BWnobord = BWsdil;

%Remove Connected Objects on Border

%BWnobord = imclearborder(BWsdil, 4);
%figure, imshow(BWnobord), title('cleared border image');

%Fill Interior Gaps (takes place step further than in source as the
%exterior edge may cause the entire image to be filled

BWdfill = imfill(BWnobord, 'holes');
% figure, imshow(BWdfill);
% title('binary image with filled holes');

%Smoothen the Object

seD = strel('disk', 1, 8);
BWfinal = imerode(BWdfill,seD);
BWfinal = imerode(BWfinal,seD);

Edge_new = BWfinal;

end

