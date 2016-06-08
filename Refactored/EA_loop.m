function [] = EA_loop(generations, population_size, Image_orig, boundary) 

for k = 1:generations
    
    %Counter for stopping conditions
    loop_break_count = loop_break_count + 1;
    
    %Create population with indvs number of individuals
    population = new_individual(population_size);
    
    %Keep previously calculated children in population
    
    population(1:5,:) = children;
    
    %Keep previous generations parents!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    population(6:15,:) = parents;

    %Calculate a score for each individual
    score_vec = zeros(1,population_size);
    
    %Calculate the fitness score for each individual
    parfor i = 1:population_size
        score_vec(i) = individual_fitness(population(i,:), Image_orig, boundary);
    end;

    %Number of individuals in tournament
    %%%%%% SHOULD BE PARAMETER FOR THIS FUNCTION%%%%%%
    tour_num = 40;

    %Tournament selection

    tourn_winners = tournament(score_vec,tour_num);

    %Crossover for the creation of Children

    children = crossover(population, tourn_winners);

    %Mutation

    children = mutate(children,k);
    
    %Save tourn_winners into list called parents to add back into
    %population
    
    parents = population(tourn_winners,:);
    
    % sort the scores in score vector
    win = sort(score_vec, 'descend');

    % find index of individual with highest score in score vector
    win_ind = find(score_vec == win(1));
    win_ind = win_ind(1);
    
    %Save best winning individuals score and properties thus far
    
    if win(1) > fittest_individual(6)
        fittest_individual(6) = win(1);
        fittest_individual(1:5) = population(win_ind,:);
        loop_break_count = 0;
    end
       
    sprintf('best score: %d',fittest_individual(6))
    
    best_scores(k) = fittest_individual(6);
    
    if mod(k,im_save_int) == 0
        
        % Check what the output edge looks like
        % Also saves jpg of edge over image
        [Edge,imtest] = evo_pst_test(population, win_ind, Image_orig, Image_name, k, boundary_name);
        
        
    end
    
    % If loop break counter reaches N, there have been no improvements to
    % the fittest individual after N loops, break function
    
    if loop_break_count >= 5
        break
    end
    
end