% taken from http://www.mathworks.com/help/images/examples/detecting-a-cell-using-image-segmentation.html?prodcode=IP

strucforsomereason = load('C:\Users\Andy\Documents\School\Thesis\Mat_Thesis\Blast_outline\edge_test_1.mat');
BWs = strucforsomereason.Edge;

% Dilate the Image

se = strel('disk', 3, 8);

BWsdil = imdilate(BWs, se);
figure, imshow(BWsdil), title('dilated gradient mask');

%Remove Connected Objects on Border

BWnobord = imclearborder(BWsdil, 4);
figure, imshow(BWnobord), title('cleared border image');

%Fill Interior Gaps (takes place step further than in source as the
%exterior edge may cause the entire image to be filled

BWdfill = imfill(BWnobord, 'holes');
figure, imshow(BWdfill);
title('binary image with filled holes');

%Smoothen the Object

seD = strel('disk', 2, 8);
BWfinal = imerode(BWdfill,seD);
BWfinal = imerode(BWfinal,seD);
%BWfinal = imerode(BWfinal,seD);
figure, imshow(BWfinal), title('segmented image');

%Show outline over origional image

Image_orig=imread('Vas1_mid-gastrula.jpg');

BWoutline = bwperim(BWfinal);
Segout = Image_orig;
Segout(BWoutline) = 255;
figure, imshow(Segout), title('outlined original image');