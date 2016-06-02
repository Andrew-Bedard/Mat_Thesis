function [ boundary ] = Import_manual( Image_name, boundary_name, cropping_amount )
%IMPORT_MANUAL: Imports manually obtained inner or outer boundary

%Load boundary based on Image name and the type of boundary, either Inner
%or Outer

boundary = load(sprintf('%s_mask_%s.mat', Image_name, boundary_name));
boundary = struct2array(boundary);

%Crop boundaries of manual boundary image for use in score function
%Done to match image dimensions with original image when the original image
%is cropped to prevent boundaries from affecting edge detection

boundary = Image_crop(boundary,cropping_amount);

end

