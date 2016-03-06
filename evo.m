%Script for evolutionary algorithm to optimize parameters for PST

% import original image
Image_orig=imread('Fox_late-gastrula2.jpg');

% import image of manual outline ( note, loads as BW3)
load('Fox_late-gastrula2_outline.mat');

% if image is a color image, convert it to grayscale
try
    Image_orig=rgb2gray(Image_orig);
catch
end

% convert the grayscale image do a 2D double array
Image_orig=double(Image_orig);

%Number of individuals
indvs = 100;

%Create population with indvs number of individuals
population = new_ind(indvs);

%Calculate a score for each individual
score_vec = zeros(1,indvs);

for i = 1:indvs
    score_vec(i) = ind_score(population(i,:), Image_orig, BW3);
end;