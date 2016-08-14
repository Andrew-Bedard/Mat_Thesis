function lengths = find_all_lengths(connection_list)

%Finds the lengths of all outer edge points relative to each other, saves
%to array lengths to be used for sorting verticies by proximity

lengths = zeros(length(connection_list), length(connection_list));

for i = 1:length(connection_list)
    for j = 1:i
        x = [connection_list(1,i) connection_list(1,j)]';
        y = [connection_list(2,i) connection_list(2,j)]';
        
        lengths(i,j) = pdist([x, y], 'euclidean');
    end
end

%We will be searching for minimums, so get rid of zeros
lengths( lengths == 0) = NaN;