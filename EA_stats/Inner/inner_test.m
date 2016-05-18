
I_name = ('Nanos2ega2');

% import original image
Image_orig=imread(sprintf('%s.jpg',I_name));

% if image is a color image, convert it to grayscale
try
    Image_orig=rgb2gray(Image_orig);
catch
end

Out_Edge = get_outer(I_name);

filled_out = imfill(Out_Edge,'holes');

Im_minus_outer = Image_orig;


for i= 1:280
    for j = 1:280   
        if filled_out(i,j) == 0
            Im_minus_outer(i,j) = 0;
        end
    end
end

Enew = Edge;

% Edge = Im_crop(Edge,5);
% Edge = pst2edge(Edge,4);
% Edge = bwareafilt(Edge,1,'largest');
% Edge = pst2edge(Edge,4);
% Edge = bwareafilt(Edge,1,'largest');
% Edge = bwperim(Edge);
% 
% % Lazy smoothing
% dilated = imdilate(Edge,strel('disk',7));
% thinned = bwmorph(dilated,'thin',inf);
% Edge = thinned;

% new_full = Out_Edge(:,:) + new5(:,:);
% 
overlay = double(imoverlay(Image_orig, comb/1000000, [1 0 0]));
figure
imshow(overlay/max(max(max(overlay))));
title('Detected features using PST overlaid with original image')