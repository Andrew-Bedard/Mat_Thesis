name = 'Pl10bla2';
pad_method = 'extreme';

load(sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Batch_results/%s_Outer_Edge.mat', name));
load(sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Batch_results/%s_Inner_Edge.mat', name));

Image_orig = imread(sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Kahikai/Images/%s.jpg',name));

[diff_inner, diff_outer] = Calculate_sim_detected_score(Outer_Edge, Inner_Edge, pad_method);

%Compare to overlay of detected edges
overlay = double(imoverlay(Image_orig, Outer_Edge/1000000, [1 0 0]));
overlay = imoverlay(overlay, Inner_Edge, [0 0 1]);
figure
Combined_overlay = imshow(overlay/max(max(max(overlay))));

[~, ~] = Simulated_Overlay(diff_inner, diff_outer,...
    Inner_Edge, Outer_Edge, Image_orig, 'average', pad_method);

[bw_outer, bw_inner] = Simulated_Overlay(diff_inner, diff_outer,...
    Inner_Edge, Outer_Edge, Image_orig, 'inner', pad_method);

[~, ~] = Simulated_Overlay(diff_inner, diff_outer,...
    Inner_Edge, Outer_Edge, Image_orig, 'outer', pad_method);