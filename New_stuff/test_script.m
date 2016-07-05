%Load data, convert from struct form because that's how it loads in for
%some reason
function [

bw_in = load('C:\Users\Andy\Documents\School\Thesis\Data\Simulated2bw\37.5_bw_in.mat');
bw_out = load('C:\Users\Andy\Documents\School\Thesis\Data\Simulated2bw\37.5_bw_out.mat');

bw_in = struct2array(bw_in);
bw_out = struct2array(bw_out);

%Edges are larger than needed from the resizing process, thin such that
%they are a line of single width
bw_in = bwmorph(bw_in, 'thin', inf);
bw_out = bwmorph(bw_out, 'thin', inf);

%Transform logical array for boundaries into sets of coordinates to make
%measuring distances easier
coord_array_in = bw2coords(bw_in);
coord_array_out = bw2coords(bw_out);

%Number of cells we want to split up out volume by
cell_number = 50;

%Distance between each slice based on cell_number
cell_dist = round(length(coord_array_out)/50);

connection_list = zeros(2, cell_number);

counter = 0;

tic
for i = 1:cell_dist:length(coord_array_out)
    
    counter = counter + 1;
    
    dummy_vec = zeros(1,length(coord_array_in));
    
    out_coords = coord_array_out(:,i)';
    
    for j = 1:length(coord_array_in)
        
        coord_pair = [out_coords; coord_array_in(:,j)'];
        dummy_vec(1,j) = pdist(coord_pair, 'euclidean');
        
    end
    

    [~, I] = find(dummy_vec(1,:) == min(dummy_vec(1,:)));
    connection_list(:,counter) = coord_array_in(:,I(1));
end
toc