function [ knn_edge ] = KNN(Edge, kn)
%Performs a modified KNN regression on the entire logical array Edge
% 
% Edge is input logical array obtained from PST
% d_measure is the type of distance measure
% kn is the number of nearest neighbors

len = length(Edge);

[I,J] = find(Edge == 1);

for i = 1:len - 1
    dist = zeros(len(I));
    for j = 1:len - 1
        
    end
end

end

