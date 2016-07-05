function [simulated_in, simulated_out] = import_simulated_edges(csv_name)

%Imports inner and outer edge from simulated gastrulation gallery
%Reflects on the x-axis to edges match orientation of in-situ images

csv_name_in = sprintf('%s_in.csv',csv_name);
csv_name_out = sprintf('%s_out.csv',csv_name);

simulated_in = csvread(csv_name_in);
simulated_out = csvread(csv_name_out);

simulated_in(1,:) = -simulated_in(1,:);
simulated_out(1,:) = -simulated_out(1,:);