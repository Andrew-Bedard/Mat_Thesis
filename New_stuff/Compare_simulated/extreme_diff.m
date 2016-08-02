function [x_diff, y_diff, Edge_coords] = extreme_diff(Edge_Logical)

Edge_Filled = imfill(Edge_Logical, 'holes');
Edge_coords = bwboundaries(Edge_Filled);

if isempty(Edge_coords) == 1
    x_diff = length(Edge_Logical);
    y_diff = length(Edge_Logical);
else
    
    Edge_coords = Edge_coords{1}';

    y_max = max(Edge_coords(2,:));
    y_min = min(Edge_coords(2,:));
    y_diff = abs(diff([y_min y_max]));

    x_max = max(Edge_coords(1,:));
    x_min = min(Edge_coords(1,:));
    x_diff = abs(diff([x_min x_max]));
end