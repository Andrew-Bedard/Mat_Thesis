
%Allows one to select outline of image and output it as a collection of
%coordinates

I_name = ('FoxD_1');
I = imread(sprintf('%s.jpg',I_name));
try
    I=rgb2gray(I);
catch
end
figure, imshow(I)
BW = roipoly(I);

prompt = 'press enter once mask is saved ';
input(prompt,'s');
%Now requires the selection of the inside of the polygon to create a mask
%with, then use the following: 
BW2 = bwperim(BW,8); 
BW3 = imdilate(BW2,strel('disk',1));
%where imdilate increases the edge thickness because manual outlines are
%not going to be perfect

imshow(BW3);
save(sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Kahikai/Binary_masks/%s_mask',I_name),'BW3');
clear;