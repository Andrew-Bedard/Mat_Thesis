
%Allows one to select outline of image and output it as a collection of
%coordinates

I = imread('Fox_late-gastrula2.jpg');
I = rgb2gray(I);
figure, imshow(I)
BW = roipoly(I);

%Now requires the selection of the inside of the polygon to create a mask
%with, then use the following: BW2 = bwperim(BW,8);

