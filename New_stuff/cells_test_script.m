%Get list of all point connections, inbetween which we create splines
%Recall that connection_list(1:2,:) are the outer points, and
%connection_list(3:4,:) are the inner points.

%Number of subdivided cells
cell_num = 100;

[connection_list, bw_in, bw_out] = calculate_point_connection('26.1', cell_num);

%Fill in boundaries of logical image

filled_in = imfill(bw_in, 'holes');
filled_out = imfill(bw_out, 'holes');

%Difference between Outer filled and inner filled gives area of interest

Out_minus_in = filled_out - filled_in;

%For each outer point, find the distance to all other outer points

lengths = find_all_lengths(connection_list);

%Create a new connection list where adjacent columns are closest neighbours

connection_list = adjacent_vertecies(connection_list, lengths);


%bw_total is to see if things are working properly, as we should recover
%the full bw image from combining all the individual cells
bw_total = zeros(size(Out_minus_in));

for i = 1:length(connection_list) - 1

    xv = zeros(1,4);
    xv(1) = connection_list(1, i);
    xv(2) = connection_list(3, i);
    xv(3) = connection_list(3, i + 1);
    xv(4) = connection_list(1, i + 1);

    yv = zeros(1,4);
    yv(1) = connection_list(2, i);
    yv(2) = connection_list(4, i);
    yv(3) = connection_list(4, i + 1);
    yv(4) = connection_list(2, i + 1);

    bw = roipoly(Out_minus_in, yv, xv);
    
    bw_total = bw_total + bw;
    
    imshow(bw);
    pause(0.1)
    
    
end

imshow(bw_total)