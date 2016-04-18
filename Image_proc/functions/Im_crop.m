function [ full_im ] = Im_crop(full_im, crop_size)
%
%Crops a selected image: im_name at its edges by crop_size pixels

full_im(1:crop_size,:) = [];
full_im(:,1:crop_size) = [];
full_im((length(full_im) - crop_size):length(full_im),:) = [];
full_im(:,length(full_im(:, 1)) - crop_size:length(full_im(:, 1))) = [];

end

