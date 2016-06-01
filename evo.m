%Script for evolutionary algorithm to optimize parameters for PST

tic;

% Use this for debugging::::
% I_name = 'Bmp2_4_Blast';
indvs = 100;
generations = 3;
% im_save_int = 1;
bdry = 'Outer';

%I_name = the name of the image
%indvs = the number of individuals total in the population for each
%generation
%generations = the number of generations until loop terminates
%im_save_int = the length of interval until next image is saved

%Script for evolutionary algorithm to optimize parameters for PST

I_name = ('Nanos2ega2');

% import original image
Image_orig=imread(sprintf('%s.jpg',I_name));

% if image is a color image, convert it to grayscale
try
    Image_orig=rgb2gray(Image_orig);
catch
end

% convert the grayscale image do a 2D double array
Image_orig=double(Image_orig);

%Grab outer edge from fittest individuals parameters
Out_Edge = get_outer(I_name);

%Fill outer boundary for use in selecting inner boundary
filled_out = imfill(Out_Edge,'holes');

Im_minus_outer = Image_orig;

%Subtract all pixels not inside the calculated outer boundary
for i= 1:280
    for j = 1:280   
        if filled_out(i,j) == 0
            Im_minus_outer(i,j) = 0;
        end
    end
end




% import image of manual outline ( note, loads as BW3)
load(sprintf('%s_mask_inner.mat',I_name));

% Crop boundaries of manual outline image
% for use in score function 
%(to prevent them from affecting PST)
BW3 = Im_crop(BW3,5);


%Origional children & parents to make the following loop a little easier
children = new_ind(5);
parents = new_ind(10);

%Create origional fittest individual, where columns 1:5 are parameters for
%the PST, and column 6 is its fitness score.
best_ind = zeros(1,6);
best_ind(6) = -9999;

%Loop break counter
loop_break_count = 0;

best_scores = zeros(generations,1);


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
        score_vec(i) = ind_score(population(i,:), Image_orig, BW3);
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
    
    if win(1) > best_ind(6)
        best_ind(6) = win(1);
        best_ind(1:5) = population(win_ind,:);
        loop_break_count = 0;
    end
       
    sprintf('best score: %d',best_ind(6))
    
    best_scores(k) = best_ind(6);
    
       
    % Check what the output edge looks like
    % Also saves jpg of edge over image
    [Edge,imtest] = evo_pst_test(population, win_ind, Image_orig, I_name, k, bdry);

    
    % If loop break counter reaches N, there have been no improvements to
    % the fittest individual after N loops, break function
    
    if loop_break_count >= 5
        break
    end
    
end

toc;