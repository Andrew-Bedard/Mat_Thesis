%function [fittest_individual, best_scores] = evo_refact_test(Image_name, indvs, generations, im_save_int,boundary_name)

% Use this for debugging::::
Image_name = 'Bmp2_4_Blast';
indvs = 100;
generations = 1;
im_save_int = 0;
children_number = 5;
parents_number = 10;

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
loop_break_count = 0;



for k = 1:generations
    
    %Counter for stopping conditions
    loop_break_count = loop_break_count + 1;
    
    %Create population with indvs number of individuals
    population = new_ind(indvs);
    
    %Keep previously calculated children in population
    
    population(1:5,:) = children;
    
    %Keep previous generations parents!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    population(6:15,:) = parents;

    %Calculate a score for each individual
    score_vec = zeros(1,indvs);
    
    %Maybe parfor to speed this sucker up
    parfor i = 1:indvs
        score_vec(i) = ind_score(population(i,:), Image_orig, boundary);
    end;

    %Number of individuals in tournament
    tour_num = 40;

    %Tournament selection

    tourn_winners = tourn(score_vec,tour_num);

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
        [Edge,imtest] = evo_pst_test(population, win_ind, Image_orig, I_name, k, boundary_name);
        
        
    end
    
    % If loop break counter reaches N, there have been no improvements to
    % the fittest individual after N loops, break function
    
    if loop_break_count >= 5
        break
    end
    
end
