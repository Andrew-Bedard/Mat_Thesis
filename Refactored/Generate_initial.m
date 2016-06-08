function [ children, parents, fittest_individual, best_scores, score_vec] = ...
    Generate_initial(children_number, parents_number, generations, population_size)
%Generate_initial: Creates initial variables needed to start EA loop.
%children= array of children_number children with random parameters
%parents = array of parents_number parents with random parameters
%fittest_individual= assign fittest individual with zero parameters and
%fitness score of -99999
%best_scores = empty list of generations length to track the best score
%over time (for graphing purposes)

%Random children and parents, for simplicity starting EA loop
children = new_ind(children_number);
parents = new_ind(parents_number);


%Create origional fittest individual, where columns 1:5 are parameters for
%the PST, and column 6 is its fitness score.
fittest_individual = zeros(1,6);
fittest_individual(6) = -99999;

%List of best scores
best_scores = zeros(generations,1);

%Score vector
score_vec = zeros(1,population_size);

end

