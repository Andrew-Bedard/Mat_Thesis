%function [fittest_individual, best_scores] = evo_refact_test(Image_name, indvs, generations, im_save_int,boundary_name)
tic;
% Use this for debugging::::
Image_name = 'Bmp2_4_early_gast';
population_size = 100;
generations = 30;
im_save_int = 2;
children_number = 5;
parents_number = 10;
%Number of individuals in tournament
tourn_size = 40;
loop_max = 5;

boundary_name = 'Outer';


% import original image, convert to double greyscale

Image_orig = Im_import(Image_name);

% import cropped image of manual outline ( note, loads as boundary)

boundary = Import_manual(Image_name, boundary_name);

%EA loop for outer boundary
[fittest_individual_outer, current_generation] = EA_loop(children_number,parents_number, ...
    generations, loop_max, population_size, tourn_size, Image_orig, Image_name, ...
    boundary, boundary_name, im_save_int);

toc;
%Take a look at what outer edge looks like, last parameter for saving, set
%to false to supress output
[Outer_Edge, Edge_overlay_Outer] = Edge_OutputAndSave_Outer(fittest_individual_outer,...
          Image_orig, Image_name, current_generation, boundary_name, false);
      

%EA loop for inner boundary

boundary_name = 'Inner';
% 
boundary = Import_manual(Image_name, boundary_name);

%im_save_int = 1;

% [fittest_individual_inner, current_generation, population] = EA_loop_inner(children_number, parents_number, ...
%     generations, loop_max, population_size, tourn_size, Image_orig, Image_name, ...
%     boundary, boundary_name, im_save_int, Outer_Edge);
% 
% toc;
% %Take a look at what inner edge looks like, last parameter for saving, set
% %to false to supress output
% [Inner_Edge, Edge_overlay_Inner] = Edge_OutputAndSave_Inner(fittest_individual_inner,...
%     Outer_Edge, Image_orig, Image_name, current_generation, boundary_name, false);


[Inner_Edge, Edge_overlay] = Edge_OutputAndSave_Inner_nonEA(fittest_individual_outer,...
    Outer_Edge, Image_orig, Image_name, current_generation, boundary_name, false);

Combined_Edge = Outer_Edge + Inner_Edge;
overlay = double(imoverlay(Image_orig, Outer_Edge/1000000, [1 0 0]));
overlay = imoverlay(overlay, Inner_Edge, [0 0 1]);
figure
Combined_overlay = imshow(overlay/max(max(max(overlay))));