%function [fittest_individual, best_scores] = evo_refact_test(Image_name, indvs, generations, im_save_int,boundary_name)

% Use this for debugging::::
Image_name = 'Bmp2_4_Blast';
population_size = 100;
generations = 25;
im_save_int = 3;
children_number = 5;
parents_number = 10;
boundary_name = 'Outer';

%I_name = the name of the image
%indvs = the number of individuals total in the population for each
%generation
%generations = the number of generations until loop terminates
%im_save_int = the length of interval until next image is saved


% import original image

Image_orig = Im_import(Image_name);


% import cropped image of manual outline ( note, loads as boundary)

boundary = Import_manual(Image_name, boundary_name, 5);

%Create initial values for parents, children, fittest individual, and
%best_scores
[ children, parents, fittest_individual, best_scores] = ...
    Generate_initial(children_number, parents_number, generations);


%Loop break counter
loop_break_counter = 0;



for current_generation = 1:generations
    
    %Counter for stopping conditions
    loop_break_counter = loop_break_counter + 1;
    
    %Create new population for calculation, saving the parents and children
    %from previous generation
    
    [population, score_vec] = Next_gnereation_population(population_size, children, ...
        parents, children_number, parents_number);
    
    %Calculate the fitness score for each individual
    parfor i = 1:population_size
        score_vec(i) = individual_fitness(population(i,:), Image_orig, boundary);
    end;

    %Number of individuals in tournament
    tour_num = 40;

    %Tournament selection

    tourn_winners = tournament(score_vec,tour_num);

    %Crossover for the creation of Children

    children = crossover(population, tourn_winners);

    %Mutation

    children = mutate(children,current_generation);
    
    %Save tourn_winners into list called parents to add back into
    %population
    
    parents = population(tourn_winners,:);
    
    % Sort scores and find fittest individual, reset loop_break_counter if
    % current fittest individual has greater fitness than previous
    % generation. Output current score.
    
    [fittest_individual, loop_break_counter] = find_fittest(population, score_vec ...
        , loop_break_counter, fittest_individual, false);
    
    best_scores(current_generation) = fittest_individual(6);
    
    %If our current generation is a multiple of image save interval,
    %calculate edge and save (requires Save_bool of Image_orig to be set to
    %true)
    if mod(current_generation,im_save_int) == 0
        
        % Calculate image output and save based on Save_bool
        [~, ~] = Edge_OutputAndSave(fittest_individual,...
          Image_orig, Image_name, current_generation, boundary_name, false);
      
    end
    
    % If loop break counter reaches N, there have been no improvements to
    % the fittest individual after N loops, break function
    
    if loop_break_counter >= 5
        break
    end
    
end

[Edge, Edge_overlay] = Edge_OutputAndSave(fittest_individual,...
          Image_orig, Image_name, current_generation, boundary_name, false);
