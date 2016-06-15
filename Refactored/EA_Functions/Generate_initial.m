function [ children, parents, fittest_individual, best_scores, children_scores, parents_scores] = ...
    Generate_initial(children_number, parents_number, generations, boundary_name)
%Generate_initial: Creates initial variables needed to start EA loop.
%children= array of children_number children with random parameters
%parents = array of parents_number parents with random parameters
%fittest_individual= assign fittest individual with zero parameters and
%fitness score of -99999
%best_scores = empty list of generations length to track the best score
%over time (for graphing purposes)

%Random children and parents, for simplicity starting EA loop
children = new_individual(children_number, boundary_name);
parents = new_individual(parents_number, boundary_name);


%Create origional fittest individual, where columns 1:5 are parameters for
%the PST, parameters 6:10 are for Frangi filter if boundary_name = inner,
%and the last column is for the score

if strcmp(boundary_name,'Outer')
    fittest_individual = zeros(1,6);
    fittest_individual(6) = -99999;
else
    fittest_individual = zeros(1,11);
    fittest_individual(11) = -99999;
end

%List of best scores
best_scores = zeros(generations,1);

%List of children scores
children_scores = zeros(1, children_number);
%List of parents scores
parents_scores = zeros(1, parents_number);
end

