function [bw_outer, bw_inner] = Simulated_Overlay(diff_inner, diff_outer,...
    Inner_Edge, Outer_Edge, Image_orig, combine_method)

Simulated_contents = dir('C:\Users\Andy\Documents\School\Thesis\Data\Simulated2bw');

Simulated_contents(1:2) = [];

[~, I1] = min(diff_inner);
[~, I2] = min(diff_outer);

if strcmp('average', combine_method) == 1
    
    I3 = (I1+I2)/2;

    inner_cand = Simulated_contents(I3).name;
    outer_cand = Simulated_contents(I3).name;
else
    inner_cand = Simulated_contents(I1).name;
    outer_cand = Simulated_contents(I2).name;
end

[~, devo_time_inner] = fileparts(inner_cand);
[~, devo_time_outer] = fileparts(outer_cand);

bw_in = load(sprintf('C:/Users/Andy/Documents/School/Thesis/Data/Simulated2bw/%s.mat',devo_time_inner));
bw_out = load(sprintf('C:/Users/Andy/Documents/School/Thesis/Data/Simulated2bw/%s.mat',devo_time_outer));

bw_in = struct2array(bw_in);
bw_out = struct2array(bw_out);

%Edges are larger than needed from the resizing process, thin such that
%they are a line of single width
bw_in = bwmorph(bw_in, 'thin', inf);
bw_out = bwmorph(bw_out, 'thin', inf);

%Resize simulated edge
bw_resized_inner = Resize_and_Pad(Inner_Edge, bw_in);
bw_resized_outer = Resize_and_Pad(Outer_Edge, bw_out);

Combined_Edge = bw_resized_inner + bw_resized_outer;
overlay = double(imoverlay(Image_orig, bw_resized_outer/1000000, [1 0 0]));
overlay = imoverlay(overlay, bw_resized_inner, [0 0 1]);
figure
Combined_overlay = imshow(overlay/max(max(max(overlay))));

bw_outer = bw_resized_outer;
bw_inner = bw_resized_inner;