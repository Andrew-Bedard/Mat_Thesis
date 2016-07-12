name = '18.2';

%Load data, convert from struct form because that's how it loads in for
%some reason

bw_in = load(sprintf('C:/Users/Andy/Documents/School/Thesis/Data/Simulated2bw/%s_bw_in.mat',name));
bw_out = load(sprintf('C:/Users/Andy/Documents/School/Thesis/Data/Simulated2bw/%s_bw_out.mat',name));

bw_in = struct2array(bw_in);
bw_out = struct2array(bw_out);

%Edges are larger than needed from the resizing process, thin such that
%they are a line of single width
bw_in = bwmorph(bw_in, 'thin', inf);
bw_out = bwmorph(bw_out, 'thin', inf);

detected_coords = bw2coords(Outer_Edge);
y_max = max(detected_coords(2,:));
y_min = min(detected_coords(2,:));
y_diff = abs(diff([y_min y_max]));

x_max = max(detected_coords(1,:));
x_min = min(detected_coords(1,:));
x_diff = abs(diff([x_min x_max]));

bw_out_resize = double(bw_out);
bw_out_resize = imresize(bw_out_resize, [x_diff y_diff]);

bw_new = zeros(size(Combined_Edge));

x_pad = 