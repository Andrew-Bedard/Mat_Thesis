function [xMax, yMid] = find_aboral(bw_mask)

%Get max and min y-values of mask, to determine mid point which will
%determine where our indexing starts on the aboral half of the embryo

%Make sure mask has no holes
filled_mask = imfill(bw_mask, 'holes');

bwOutline = bwboundaries(filled_mask);

%bwboundaries creates a cell, select array from cell
bwOutline = bwOutline{1};

max_y = max(bwOutline(:,2));
min_y = min(bwOutline(:,2));
yMid = round((max_y - min_y)/2) + min_y;

xMax = find(bw_mask(yMid,:),1, 'last');