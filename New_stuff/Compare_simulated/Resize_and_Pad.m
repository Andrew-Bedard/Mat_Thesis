function Resized_Logical = Resize_and_Pad(Detected_Edge, Simulated_Edge)

%Resizes the simulated edge such that it's smallest x, y and largest x, y
%values correspond.

detected_coords = bw2coords(Detected_Edge);
y_max = max(detected_coords(2,:));
y_min = min(detected_coords(2,:));
y_diff = abs(diff([y_min y_max]));

x_max = max(detected_coords(1,:));
x_min = min(detected_coords(1,:));
x_diff = abs(diff([x_min x_max]));

bw_out_resize = double(Simulated_Edge);
bw_out_resize = imresize(bw_out_resize, [x_diff y_diff]);

bw_new = zeros(size(Detected_Edge));

x_pad = abs(length(bw_new(1,:)) - x_diff);
y_pad = abs(length(bw_new(:,1)) - y_diff);

x_pad_left = ceil(x_pad/2);
x_pad_right = floor(x_pad/2) + 1;

y_pad_lower = ceil(y_pad/2);
y_pad_upper = floor(y_pad/2) + 1;

bw_new(x_pad_left: (end - x_pad_right), y_pad_lower: (end - y_pad_upper)) = bw_out_resize;

bw_new = logical(bw_new);

bw_new = bwmorph(bw_new, 'thin', inf);

Resized_Logical = bw_new;