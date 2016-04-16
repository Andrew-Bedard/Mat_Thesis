function [ im_out ] = Im_crop(im_name, crop_size)
%
%Crops a selected image: im_name at its edges by crop_size pixels

% Delete the outer edges of image
imlength = length(Image_orig(1,:));
imwidth = length(Image_orig(:,1));

Image_orig(1,:) = [];
Image_orig(imlength - 1,:) = [];
Image_orig(:,1) = [];
Image_orig(:,imwidth - 1) = [];

end

