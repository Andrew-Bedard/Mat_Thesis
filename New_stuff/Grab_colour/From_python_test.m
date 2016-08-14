%Read in the original image, but the real deal, not greyscale
Image_name = 'Bmp2_4_early_gast';
rgb_img = imread(sprintf('%s.jpg',Image_name));

%Import polygons from python program
cell_polygons = loadjson('C:\Users\Andy\Documents\School\Thesis\Py_Thesis\NematostellaMorphGen-master\test3_polygons.json');
field_names = fieldnames(cell_polygons);

%Number of rows and cols
rgb_rows = length(rgb_img(:,1,1));
rgb_cols = length(rgb_img(1,:,1));

dummy_array = zeros(rgb_rows, rgb_cols);

%Complete mask of all polygons combined
bw_mask = logical(dummy_array);

%Separate masks
all_masks = cell(1,numel(field_names));

%Get mask for each polygon
for i = 1:numel(field_names)
    
    poly = cell_polygons(1).(field_names{i});

    BW = roipoly(dummy_array, poly(:,2), poly(:,1));
    
    all_masks{i} = BW;
    
    bw_mask = bw_mask + BW;
end

imshow(bw_mask)

%Fill complete mask, take complement for taking colour average outside
%embryo
filled_mask = imfill(bw_mask, 'holes');
filled_complement = imcomplement(filled_mask);
figure, imshow(filled_complement);

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

channel_means = zeros(1,length(rgb_img(1,:,1)),3);

for i = 1:3
    for j = 1:length(rgb_img(1,:,1));
        current_col = rgb_img(:,j,i);
        current_col = current_col(current_col ~= 0);
        current_mean = mean(current_col);
        channel_means(1,j,i) = current_mean;
    end
end

%Mean value for each channel
rgb_means = [mean(channel_means(1,:,1)), mean(channel_means(1,:,2)), mean(channel_means(1,:,3))];
