function [population, score_vec] = Next_generation_population(population_size, children, parents, ...
    children_scores, children_number, parents_number, current_generation)

%NEXT_GENERATION_POPULATION: from population_size, children, parents it
%creates a new population for the next generations calculations, keeping
%both parents and children from the previous generation and creating a
%score vector.

if current_generation == 1
    
    %Create population with indvs number of individuals
    population = new_individual(population_size);
    
    %Create empty vector for scores to be calculated
    
    score_vec = zeros(1,population_size);
    
else

    %Create population with indvs number of individuals
    population = new_individual(population_size);

    %Keep previously calculated children in population

    population(1:children_number,:) = children;

    %Keep previous generations parents

    population((children_number + 1):(children_number + parents_number),:) = parents;

    %Keep calculated already calculated scores from previous generation

    score_vec = zeros(1,population_size);

    score_vec(1:children_number) = children_scores;

end;
