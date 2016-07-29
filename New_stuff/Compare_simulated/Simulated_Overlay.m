function [bw_outer, bw_inner] = Simulated_Overlay(diff_inner, diff_outer,...
    Inner_Edge, Outer_Edge, Image_orig, combine_method, pad_method)

%Takes as arguments
%diff_inner: the list of errors between each developmental stage and our
%detected inner edges, Inner_Edge
%diff_outer: the list of errors between each developmental stage and our
%detected outer edges, Outer_Edge
%Image_orig: the original image
%combine_method: because both inner and outer boundaries must correspond to
%a single developmental stage, combine_method is selected in order to
%either average the estimated age from both the inner and outer boundary,
%only use the estimated age for the inner boundary, or only use the
%estimated age for the outer boundary.

%Outputs
%bw_outer: the final outer edge, as a logical array
%bw_inner: the final inner edge, as a logical array

Simulated_contents = dir('C:\Users\Andy\Documents\School\Thesis\Data\Simulated2bw');

%Get rid of .db files that always appear in front
Simulated_contents(1:2) = [];

%Only want to know developmental stage, not whether it is inner or outer
%boundary, that distinction is left for a later step below.
Simulated_contents = Simulated_contents(1:2:end);

[~, I1] = min(diff_inner);
[~, I2] = min(diff_outer);

if strcmp('average', combine_method) == 1
    
    I3 = (I1+I2)/2;
    I3 = round(I3);

    inner_cand = Simulated_contents(I3).name;
    outer_cand = Simulated_contents(I3).name;
    
elseif strcmp('inner', combine_method) == 1
    
    inner_cand = Simulated_contents(I1).name;
    outer_cand = Simulated_contents(I1).name;
    
elseif strcmp('outer', combine_method) == 1
    
    inner_cand = Simulated_contents(I2).name;
    outer_cand = Simulated_contents(I2).name;
    
else
    inner_cand = Simulated_contents(I1).name;
    outer_cand = Simulated_contents(I2).name;
end

[~, devo_time_inner] = fileparts(inner_cand);
[~, devo_time_outer] = fileparts(outer_cand);

%Get rid of string contents other than number, such that XX.X_in becomes
%XX.X
devo_time_inner = devo_time_inner(1:4);
devo_time_outer = devo_time_outer(1:4);

bw_in = load(sprintf('C:/Users/Andy/Documents/School/Thesis/Data/Simulated2bw/%s_bw_in.mat',devo_time_inner));
bw_out = load(sprintf('C:/Users/Andy/Documents/School/Thesis/Data/Simulated2bw/%s_bw_out.mat',devo_time_outer));

bw_in = struct2array(bw_in);
bw_out = struct2array(bw_out);

%Edges are larger than needed from the resizing process, thin such that
%they are a line of single width
bw_in = bwmorph(bw_in, 'thin', inf);
bw_out = bwmorph(bw_out, 'thin', inf);

%Resize simulated edge
bw_resized_inner = Resize_and_Pad(Inner_Edge, bw_in, pad_method);
bw_resized_outer = Resize_and_Pad(Outer_Edge, bw_out, pad_method);

full_length = length(bw_resized_outer);

%Compare the size of bw_resized inner and outer to the size of bw_in and
%bw_out. The idea is if there is a huge discrepancy then there may be
%something funky happening, usually with bw_resized_inner from the detected
%inner edge being of poor quality, use default size relative to 
%bw_resized_outer.

resized_ratio = dimensions_compare(bw_resized_inner, bw_resized_outer);

simulated_ratio = dimensions_compare(bw_in, bw_out);

[x_out_diff, y_out_diff, ~] = extreme_diff(bw_resized_outer);

if simulated_ratio(1)/resized_ratio(1) < 0.5 || simulated_ratio(2)/resized_ratio(2) < 0.5 % || simulated_ratio(1)/resized_ratio(1) > 0.85 || simulated_ratio(2)/resized_ratio(2) > 0.85
    in_filled = imfill(bw_in,'holes');
    bw_resized_inner = imresize(in_filled, [(1/simulated_ratio(1))*x_out_diff (1/simulated_ratio(2))*y_out_diff]);
    bw_new = zeros(size(bw_resized_outer));
    
    bw_resized_inner_filled = imfill(bw_resized_inner, 'holes');
    bw_resized_inner_coords = bwboundaries(bw_resized_inner_filled);
    bw_resized_inner_coords = bw_resized_inner_coords{1}';
    
    bw_resized_outer_filled = imfill(bw_resized_outer, 'holes');
    bw_resized_outer_coords = bwboundaries(bw_resized_outer_filled);
    bw_resized_outer_coords = bw_resized_outer_coords{1}';
    
%    x_in_max = max(bw_resized_inner_coords(1,:));
    x_in_min = min(bw_resized_inner_coords(1,:));
%   y_in_max = max(bw_resized_inner_coords(2,:));
    y_in_min = min(bw_resized_inner_coords(2,:));
    
    %x_out_max = max(bw_resized_outer_coords(1,:));
     x_out_min = min(bw_resized_outer_coords(1,:));
    %y_out_max = max(bw_resized_outer_coords(2,:));
     y_out_min = min(bw_resized_outer_coords(2,:));

    
    for i = 1:length(bw_resized_inner_coords)
        bw_new(x_in_min + x_out_min + bw_resized_inner_coords(1,i), y_in_min + y_out_min + bw_resized_inner_coords(2, i)) = 1;
    end
            

%     x_pad_left = x_in_min + 1;
%     x_pad_right = length(bw_new(1,:)) - x_in_max;
%     
%     y_pad_lower = y_in_min + 1;
%     y_pad_upper = length(bw_new(:,1)) - y_in_max;
%     
%     bw_new(x_pad_left:(end - x_pad_right), y_pad_lower:(end - y_pad_upper)) = bw_resized_inner;

    bw_resized_inner = bw_new;
end

%Remove edge pixels outside of Outer_Edge
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
filled_Outer_Edge = imfill(Outer_Edge, 'holes');
filled_Simulated = imfill(bw_resized_outer, 'holes');

complement_Outer = imcomplement(filled_Outer_Edge);
complement_Simulated = imcomplement(filled_Simulated);

cleaned_outer = complement_Outer + complement_Simulated;
cleaned_outer = logical(cleaned_outer);
cleaned_outer = imcomplement(cleaned_outer);

bw_outer_final = bwperim(cleaned_outer);

%Create overlay
% overlay = double(imoverlay(Image_orig, bw_outer_final/1000000, [1 0 0]));
% overlay = imoverlay(overlay, bw_resized_inner, [0 0 1]);
% figure
% Combined_overlay = imshow(overlay/max(max(max(overlay))));

bw_outer = bw_outer_final;
bw_inner = bw_resized_inner;