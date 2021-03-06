function [Difference_score, Sim_vs_Meas] = Simulated_Measured_diff(Measured_Edge, Simulated_Edge)

%Counts the number of pixels that differ between simulated and measured
%edges

Measured_Edge_filled = imfill(Measured_Edge, 'holes');

Simulated_Edge_filled = imfill(Simulated_Edge, 'holes');

Simulated_Edge_filled = double(Simulated_Edge_filled);

Measured_Edge_filled = double(Measured_Edge_filled);

Sim_vs_Meas = Simulated_Edge_filled - Measured_Edge_filled;

Sim_vs_Meas = logical(Sim_vs_Meas);

Difference_score = sum(sum(Sim_vs_Meas));