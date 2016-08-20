%Read in the original image, but the real deal, not greyscale
Image_name = 'Nanos2ega1';
Im_orig = imread(sprintf('%s.jpg',Image_name));

rgb_img = im2double(Im_orig);

%Import polygons from python program
cell_polygons = loadjson(sprintf('C:/Users/Andy/Documents/School/Thesis/Data/Polygons/%s_polygons.json',Image_name));
field_names = fieldnames(cell_polygons);

%Number of rows and cols
rgb_rows = length(rgb_img(:,1,1));
rgb_cols = length(rgb_img(1,:,1));

dummy_array = zeros(rgb_rows, rgb_cols);

%Complete mask of all polygons combined
bw_mask = logical(dummy_array);
bw_subcells = logical(dummy_array);

%Empty cell for each individual mask
all_masks = cell(1,numel(field_names));

%Polygon Ids ( Matlab doesn't like it when the name of a field has a number
%as its first character, so loadjson automatically puts it into x0x[Hex
%code] format, so to recover the Ids from the json file I will track the
%Ids manually)
poly_ids = zeros(numel(field_names),1);

%Get mask for each polygon
for i = 1:numel(field_names)
    
    %Grab the proper polygon id from the crazy json hex name
    current_name = field_names{i};
    current_name = current_name(current_name ~= '_');
    current_name = current_name(5:end);
    
    %Added the +1 here to convert from python indexing to Matlab indexing
    poly_ids(i) = str2double(current_name) + 1;
    
    %Create polygon ROI from verticies
    poly = cell_polygons(1).(field_names{i});
    BW = roipoly(dummy_array, poly(:,2), poly(:,1));    
    all_masks{i} = BW;
    
    %Full logical mask
    bw_mask = bw_mask + BW;    
    
    %Save outline of subcells for display    
    BWSUB = bwmorph(BW, 'remove');    
    bw_subcells = bw_subcells + BWSUB;
end

%Sorts masks such that they are in order from 1:end based on ids
[~, sorted_order] = sort(poly_ids);

%Find point which will represent the aboral point of embryo
[xMax,yMid] = find_aboral(bw_mask);

dummy_list = zeros(1,numel(field_names));

for i = 1:numel(field_names)
    current_poly = cell_polygons(1).(field_names{sorted_order(i)});
    dummy_list(i) = inpolygon(xMax,yMid,current_poly(:,2),current_poly(:,1));
end

starting_poly = find(dummy_list);

sorted_order = circshift(sorted_order, -starting_poly + 1);

% for i = 1:numel(field_names)
%     
%     imshow(all_masks{sorted_order(i)})
%     pause(0.1)
%     
% end

%imshow(bw_mask)

%Fill complete mask
filled_mask = imfill(bw_mask, 'holes');

%take complement for taking colour average outside
%embryo
filled_complement = imcomplement(filled_mask);
%figure, imshow(filled_complement);

%Set entries where they are not within the filled_complement equal to zero
%This has to be done as a nested loop because of soemthing strange
%happening that I havent figured out yet
for i = 1:length(rgb_img(1,:,1));
    for j = 1:length(rgb_img(:,1,1));
        if filled_complement(i,j) == 0
            rgb_img(i,j,:) = 0;
        end
    end
end

%Need to calculate the mean colours for each channel column by column
%because we are changing the length of the columns by removing entires
%entirely

rgb_means = channel_means(rgb_img);

mask_means = zeros(numel(field_names),3);

Im_orig = im2double(Im_orig);

for i = 1:numel(field_names)
    
    dummy_im = Im_orig;
    current_mask = all_masks{sorted_order(i)};
    
    for j = 1:3
        dummy_im(:,:,j) = dummy_im(:,:,j).*double(current_mask);
    end
    
    mask_means(i,:) = channel_means(dummy_im);
    
end

%Subtract mean value from background colour.
correctedMeans = [mask_means(:,1) - rgb_means(1), mask_means(:,2) - rgb_means(2), mask_means(:,3) - rgb_means(3)];
% 
% %Lets plot this junk
% figure, subplot(2,1,1), imshow(Im_orig)
% 
% hold on
% subplot(2,1,2), plot(-correctedMeans(:,1),'r')
% hold on
% subplot(2,1,2),plot(-correctedMeans(:,2),'b')
% hold on
% subplot(2,1,2),plot(-correctedMeans(:,3),'g')

%windowed mean plotting

smoothedMeans = window_mean(correctedMeans, 10);

figure, subplot(2,2,1), imshow(Im_orig)
title(sprintf('Original Image: %s', Image_name));

%Make sure bw_subcells is logical
bw_subcells = logical(bw_subcells);
subplot(2,2,2),imshow(bw_subcells)
title(sprintf('Subcell Division'))


subplot(2,2,[3,4]), plot(-smoothedMeans(:,1),'r')
hold on
subplot(2,2,[3,4]),plot(-smoothedMeans(:,2),'b')
hold on
subplot(2,2,[3,4]),plot(-smoothedMeans(:,3),'g')
title('RGB colour levels')
xlim([0,length(smoothedMeans)])