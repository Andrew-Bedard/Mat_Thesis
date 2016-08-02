function [ Image_orig ] = Im_import(Image_name)
%IM_IMPORT: Imports in-situ image for analysis
%   
%   Imports in-situ image for analysis by name, if image is color, converts
%   to grayscale, then converts grayscale to double.

Image_orig = imread(sprintf('%s.jpg',Image_name));

% if image is a color image, convert it to grayscale
try
    Image_orig=rgb2gray(Image_orig);
catch
end

% convert the grayscale image do a 2D double array
Image_orig=double(Image_orig);

%Images must be square, so if not resize such that its length and width are
%equal to whichever is smaller

imsize = size(Image_orig);

if imsize(1) ~= imsize(2)
    Image_orig = imresize(Image_orig, [min(imsize) min(imsize)]);
end

end

