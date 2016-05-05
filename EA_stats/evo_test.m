function [] = evo_test(I_name, indvs, generations, im_save_int)

% Use this for debugging::::
% I_name = 'Bmp2_4_Blast';
% indvs = 100;
% generations = 1;
% im_save_int = 1;

%I_name = the name of the image
%indvs = the number of individuals total in the population for each
%generation
%generations = the number of generations until loop terminates
%im_save_int = the length of interval until next image is saved

%Script for evolutionary algorithm to optimize parameters for PST


% import original image

Image_orig=imread(sprintf('%s.jpg',I_name));

% if image is a color image, convert it to grayscale
try
    Image_orig=rgb2gray(Image_orig);
catch
end

% convert the grayscale image do a 2D double array
Image_orig=double(Image_orig);

% import image of manual outline ( note, loads as BW3)
load(sprintf('%s_mask.mat',I_name));

% Crop boundaries of manual outline image
% for use in score function 
%(to prevent them from affecting PST)
BW3 = Im_crop(BW3,5);


%Origional children & parents to make the following loop a little easier
children = new_ind(5);
parents = new_ind(10);

for k = 1:generations
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
    
    if mod(k,im_save_int) == 0
        
        % sort the scores in score vector
        win = sort(score_vec, 'descend');

        % find index of individual with highest score in score vector
        win_ind = find(score_vec == win(2));
        win_ind = win_ind(1);

        % Check what the output edge looks like
        % Also saves jpg of edge over image
        [Edge,imtest] = evo_pst_test(population, win_ind, Image_orig, I_name, k);
        
        %save(sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Kahikai/EA_prog/%s/%d_gens',I_name,k),'Edge');
    end
    
end
