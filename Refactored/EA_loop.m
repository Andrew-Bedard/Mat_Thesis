function [fittest_individual, current_generation] = EA_loop(children_number,parents_number, ...
    generations, loop_max, population_size, tourn_size, Image_orig, Image_name, ...
    boundary, boundary_name, im_save_int) 


%EA_LOOP: Main loop. Generates initial values needed to start loop, goes
%from 1:generations, will break if no improvements after loop_max number of
%loops. Generates new population, calculates fitness based on parameters of
%individuals, selects top tourn_size individuals for tournament resulting
%in parents_number parents, 


%Create initial values for parents, children, fittest individual, and
%empty scores
[ children, parents, fittest_individual, best_scores, children_scores, parents_scores] = ...
    Generate_initial(children_number, parents_number, generations, boundary_name);


loop_break_counter = 0;

for current_generation = 1:generations
    
    %Counter for stopping conditions
    loop_break_counter = loop_break_counter + 1;
    
    %Create new population for calculation, saving the parents and children
    %from previous generation
    
    [population, score_vec] = Next_generation_population(population_size, children,...
        parents, children_scores, children_number, parents_scores, ...
        parents_number, current_generation, boundary_name);
    
    %Calculate the fitness score for each individual
    parfor i = 1:population_size
        if score_vec(i) == 0
            score_vec(i) = individual_fitness(population(i,:), Image_orig, boundary);
        end
    end;

    %Tournament selection

    [tourn_winners, parents_scores] = tournament(score_vec,tourn_size);
    
    %Save tourn_winners into list called parents to add back into
    %population
    
    parents = population(tourn_winners,:);

    %Crossover for the creation of Children

    children = crossover(population, tourn_winners);

    %Mutation

    children = mutate(children,current_generation, boundary_name);
    
    %Calculate fitness for newly created Children    
    children_scores = zeros(1, children_number);
    
    parfor i = 1:children_number
        children_scores(i) = individual_fitness(children(i,:), Image_orig, boundary);
    end;
    
    
    % Sort scores and find fittest individual, reset loop_break_counter if
    % current fittest individual has greater fitness than previous
    % generation. Output current score.
    
    [fittest_individual, loop_break_counter] = find_fittest(population, children,...
        children_scores, score_vec, loop_break_counter, fittest_individual, false);
    
    best_scores(current_generation) = fittest_individual(6);
    
    %If our current generation is a multiple of image save interval,
    %calculate edge and save (requires Save_bool of Image_orig to be set to
    %true)
    if mod(current_generation,im_save_int) == 0
        
        % Calculate image output and save based on Save_bool
        [~, ~] = Edge_OutputAndSave_Outer(fittest_individual,...
          Image_orig, Image_name, current_generation, boundary_name, false);
      
    end
    
    % If loop break counter reaches loop_max, there have been no improvements to
    % the fittest individual after loop_max loops, break function
    
    if loop_break_counter >= loop_max
        break
    end
    
end