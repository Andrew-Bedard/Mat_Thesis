function Resized_Logical = Resize_and_Pad(Detected_Edge, Simulated_Edge, pad_method)

%Resizes the simulated edge such that it's smallest x, y and largest x, y
%values correspond.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Better description needed

%Get rid of all points outside extreme x and y values of simulated edges
[~, ~, Sim_coords] = extreme_diff(Simulated_Edge);

x_min = min(Sim_coords(1,:));
x_max = max(Sim_coords(1,:));

y_min = min(Sim_coords(2,:));
y_max = max(Sim_coords(2,:));

%Sim_unpadded = zeros(x_diff, y_diff);

Sim_unpadded = Simulated_Edge(x_min:x_max, y_min:y_max);

clear x_min x_max y_min y_max

[x_diff, y_diff, Detected_coords] = extreme_diff(Detected_Edge);

x_min = min(Detected_coords(1,:));
x_max = max(Detected_coords(1,:));

y_min = min(Detected_coords(2,:));
y_max = max(Detected_coords(2,:));

%Resize simulated boundary such that it has the same extreme x and y values
bw_resize = double(Sim_unpadded);
bw_resize = imresize(bw_resize, [x_diff y_diff]);

%Create zero array, for padding as Detected_Edge and bw_resize are not of
%the same dimensions
bw_new = zeros(size(Detected_Edge));


if strcmp(pad_method, 'even') == 1
    %Pad zeros evenly along boarders
    x_pad = abs(length(bw_new(1,:)) - x_diff);
    y_pad = abs(length(bw_new(:,1)) - y_diff);

    x_pad_left = ceil(x_pad/2);
    x_pad_right = floor(x_pad/2) + 1;

    y_pad_lower = ceil(y_pad/2);
    y_pad_upper = floor(y_pad/2) + 1;

elseif strcmp(pad_method, 'extreme') == 1
    %Pad zeros based on extreme values of detected edges

    x_pad_left = x_min + 1;
    x_pad_right = length(bw_new(1,:)) - x_max;

    y_pad_lower = y_min + 1;
    y_pad_upper = length(bw_new(:,1)) - y_max;
end

bw_new(x_pad_left: (end - x_pad_right), y_pad_lower: (end - y_pad_upper)) = bw_resize;

bw_new = logical(bw_new);

bw_new = bwmorph(bw_new, 'thin', inf);

Resized_Logical = bw_new;