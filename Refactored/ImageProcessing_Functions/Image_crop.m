function [ full_im ] = Image_crop(full_im, crop_size)
%
%Crops a selected image: im_name at its edges by crop_size pixels
%MAY ONLY WORK WITH SQUARE IMAGES!!!!!!

    full_im(1:crop_size,:) = 0;
    full_im(:,1:crop_size) = 0;
    full_im((length(full_im) - crop_size):length(full_im),:) = 0;
    full_im(:,length(full_im(:, 1)) - crop_size:length(full_im(:, 1))) = 0;

end

