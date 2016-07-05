function [connection_list] = calculate_point_connection(name, cell_number)

%Calculates the closest interior edge point to specified outer edge points.
%The output connection_list contains two sets of coordinates, where
%connection_list(1:2,:) are the coordinates of outer points, and
%connection_list(3:4,:) are the coordinates of inner points to be connected
%to create cell_number of equally spaced cells.

%cell_number = the number of equally spaced (w.r.t. outer boundary) cells
%we wish to produce

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

%Transform logical array for boundaries into sets of coordinates to make
%measuring distances easier
coord_array_in = bw2coords(bw_in);
coord_array_out = bw2coords(bw_out);

%Distance between each slice based on cell_number
cell_dist = round(length(coord_array_out)/50);

connection_list = zeros(4, cell_number);
counter = 0;

for i = 1:cell_dist:length(coord_array_out)
    
    counter = counter + 1;
    
    dummy_vec = zeros(1,length(coord_array_in));
    
    out_coords = coord_array_out(:,i)';
    
    for j = 1:length(coord_array_in)
        
        coord_pair = [out_coords; coord_array_in(:,j)'];
        dummy_vec(1,j) = pdist(coord_pair, 'euclidean');
        
    end
    
    %Find the index of the closest point to outer point j
    [~, I] = find(dummy_vec(1,:) == min(dummy_vec(1,:)));
    
    connection_list(1:2,counter) = coord_array_out(:,i);
    connection_list(3:4,counter) = coord_array_in(:,I(1));
end