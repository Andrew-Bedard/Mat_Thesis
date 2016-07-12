function [diff_inner, diff_outer] = Calculate_sim_detected_score(Outer_Edge, Inner_Edge)

Simulated_contents = dir('C:\Users\Andy\Documents\School\Thesis\Data\Simulated2bw');

diff_inner = zeros(1,numel(Simulated_contents));
diff_outer = zeros(1,numel(Simulated_contents));

for i = 1:numel(Simulated_contents)

    gast_time = Simulated_contents(i).name;
    
    [~, devo_time] = fileparts(gast_time);
    
    if length(devo_time) > 5

        %Load data, convert from struct form because that's how it loads in for
        %some reason

        bw_in = load(sprintf('C:/Users/Andy/Documents/School/Thesis/Data/Simulated2bw/%s.mat',devo_time));
        bw_out = load(sprintf('C:/Users/Andy/Documents/School/Thesis/Data/Simulated2bw/%s.mat',devo_time));

        bw_in = struct2array(bw_in);
        bw_out = struct2array(bw_out);

        %Edges are larger than needed from the resizing process, thin such that
        %they are a line of single width
        bw_in = bwmorph(bw_in, 'thin', inf);
        bw_out = bwmorph(bw_out, 'thin', inf);

        %Resize simulated edge
        bw_resized = Resize_and_Pad(Outer_Edge, bw_out);

        %Find difference (in number of pixels) between simulated and detected edge
        [diff_score, ~] = Simulated_Measured_diff(Outer_Edge, bw_resized);

        diff_outer(i) = diff_score;

        bw_resized = Resize_and_Pad(Inner_Edge, bw_in);

        [diff_score, ~] = Simulated_Measured_diff(Inner_Edge, bw_resized);

        diff_inner(i) = diff_score;
        
    end
    
end

diff_inner(diff_inner == 0) = [];
diff_outer(diff_inner == 0) = [];
