%Script for evolutionary algorithm to optimize parameters for PST

tic;

% import original image
I_name = ('Bmp2_4_early_gast');

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

%Number of individuals
indvs = 100;

%Origional children to make the following loop a little easier
children = new_ind(5);

for k = 1:20

    %Create population with indvs number of individuals
    population = new_ind(indvs);
    
    %Keep previously calculated children in population
    
    population(1:5,:) = children;

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
    
end

% sort the scores in score vector
win = sort(score_vec, 'descend');

% find index of individual with highest score in score vector
win_ind = find(score_vec == win(2));
win_ind = win_ind(1);

% Check what the output edge looks like
[Edge] = evo_pst(population, win_ind, Image_orig);

toc;