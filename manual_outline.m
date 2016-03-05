
%Allows one to select outline of image and output it as a collection of
%coordinates

I = imread('Fox_late-gastrula2.jpg');
I = rgb2gray(I);
figure, imshow(I)
BW = roipoly(I);

%Now requires the selection of the inside of the polygon to create a mask
%with, then use the following: BW2 = bwperim(BW,8); BW3 = imdilate(BW2,
%strel('disk',1));
%where imdilate increases the edge thickness because manual outlines are
%not going to be perfect

