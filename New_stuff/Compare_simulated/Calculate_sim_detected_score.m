function [diff_inner, diff_outer] = Calculate_sim_detected_score(Outer_Edge, Inner_Edge, pad_method)

%Calculates the difference between detected inner edge: Inner_Edge and
%every stage of the simulated edges, adjusted for size and position of
%Inner_Edge, and the same for Outer_Edge.
%pad_method is the method used to centre and scale the simulated edge w.r.t
%detected edge, default is 'extreme', see Resize_and_Pad for details.

Simulated_contents = dir('C:\Users\Andy\Documents\School\Thesis\Data\Simulated2bw');

%There are always two files .db files or some nonsense, so get rid of them
Simulated_contents(1:2) = [];

diff_inner = zeros(1,numel(Simulated_contents)/2);
diff_outer = zeros(1,numel(Simulated_contents)/2);

for i = 1:2:(numel(Simulated_contents) - 10)

    gast_time = Simulated_contents(i).name;
    
    [~, devo_time] = fileparts(gast_time);
    
    %Only take numbers, so we can specify whether it is XX.X_in or XX.X_out
    devo_time = devo_time(1:4);

    %Load data, convert from struct form because that's how it loads in for
    %some reason

    bw_in = load(sprintf('C:/Users/Andy/Documents/School/Thesis/Data/Simulated2bw/%s_bw_in.mat',devo_time));
    bw_out = load(sprintf('C:/Users/Andy/Documents/School/Thesis/Data/Simulated2bw/%s_bw_out.mat',devo_time));

    bw_in = struct2array(bw_in);
    bw_out = struct2array(bw_out);

    %Edges are larger than needed from the resizing process, thin such that
    %they are a line of single width
    bw_in = bwmorph(bw_in, 'thin', inf);
    bw_out = bwmorph(bw_out, 'thin', inf);

    %Resize simulated edge
    bw_resized = Resize_and_Pad(Outer_Edge, bw_out, pad_method);

    %Find difference (in number of pixels) between simulated and detected edge
    [diff_score, ~] = Simulated_Measured_diff(Outer_Edge, bw_resized);

    diff_outer(i) = diff_score;

    bw_resized = Resize_and_Pad(Inner_Edge, bw_in, pad_method);

    [diff_score, ~] = Simulated_Measured_diff(Inner_Edge, bw_resized);

    diff_inner(i) = diff_score;
    
end

diff_inner(diff_inner == 0) = [];
diff_outer(diff_outer == 0) = [];
