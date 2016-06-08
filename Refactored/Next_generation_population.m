function [population, score_vec] = Next_generation_population(population_size, children, parents, ...
    children_number, parents_number)

%NEXT_GENERATION_POPULATION: from population_size, children, parents it
%creates a new population for the next generations calculations, keeping
%both parents and children from the previous generation and creating a
%score vector.

%Create population with indvs number of individuals
population = new_individual(population_size);

%Keep previously calculated children in population

population(1:children_number,:) = children;

%Keep previous generations parents

population((children_number + 1):(children_number + parents_number),:) = parents;

%Calculate a score for each individual
score_vec = zeros(1,population_size);