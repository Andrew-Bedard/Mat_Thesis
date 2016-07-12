function connection_list_new = adjacent_vertecies(connection_list, lengths)

%From the list of outer edge points and their closest inner point to which
%they should be connected, adjacent_certecies sorts connection_list such
%that every column entry in connection_list is adjacent to the column entry
%with which it defines a proper polygon.

connection_list_new = zeros(size(connection_list));

p2 = connection_list(:,1);

connection_list_new(:,1) = p2;

I = 1;

for i = 2:length(connection_list)
    
    prev_ind = I;
    
    %Find index of closes point to current point, insert into new
    %connection list.
    [~, I] = min(lengths(:, prev_ind));    
    connection_list_new(:,i) = connection_list(:,I);
    
    %Get rid of value for already adjacent entries
    lengths(I, prev_ind) = NaN;
    
end