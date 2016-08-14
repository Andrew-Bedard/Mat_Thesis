contents = dir('C:\Users\Andy\Documents\School\Thesis\Images\Kahikai\Images');
save_directory = sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Batch_Results/Results');

population_size = 100;
generations = 30;
im_save_int = 0;
children_number = 5;
parents_number = 10;
%Number of individuals in tournament
tourn_size = 40;
loop_max = 10;
save_edges = true;
save_parameters = false;

for i = 1:numel(contents)
 %for i = 7:7
  filename = contents(i).name;
  
  % Open the file specified in filename, do your processing...
  [~, Image_name] = fileparts(filename);
  
  % Prevent from trying to run EA on files not associated with image file,
  % or have already had EA run over
  if exist(sprintf('%s.jpg',Image_name),'file') ~= 0 && exist(sprintf('%s_edges.mat', Image_name), 'file') == 0
      
      % Name of directory to save binary images
      dirpath = save_directory;
      
      % If directory doesnt exist, create one
      if exist(dirpath,'dir') == 0
          mkdir(dirpath);
          addpath(dirpath);
      end

      tic
    boundary_name = 'Outer';


    % import original image, convert to double greyscale

    Image_orig = Im_import(Image_name);

    % import cropped image of manual outline ( note, loads as boundary)

    boundary = Import_manual(Image_name, boundary_name);
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Test multiple runs
    
    fittest_individual_outer = zeros(1,6);
    fittest_individual_outer(6) = -9999999;
    
    for t = 1:1
        %EA loop for outer boundary
        [fittest_individual, current_generation] = EA_loop(children_number,parents_number, ...
            generations, loop_max, population_size, tourn_size, Image_orig, Image_name, ...
            boundary, boundary_name, im_save_int);
        
        if fittest_individual(6) > fittest_individual_outer(6)
            fittest_individual_outer = fittest_individual;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

%     %EA loop for outer boundary
%     [fittest_individual_outer, current_generation] = EA_loop(children_number,parents_number, ...
%     generations, loop_max, population_size, tourn_size, Image_orig, Image_name, ...
%     boundary, boundary_name, im_save_int);


    %Take a look at what outer edge looks like, last parameter for saving, set
    %to false to supress output
    [Outer_Edge] = Edge_OutputAndSave_Outer(fittest_individual_outer,...
              Image_orig, Image_name, current_generation, boundary_name, false, false);


    %EA loop for inner boundary

    boundary_name = 'Inner';
    % 
    boundary = Import_manual(Image_name, boundary_name);

    [Inner_Edge] = Edge_OutputAndSave_Inner_nonEA(fittest_individual_outer,...
        Outer_Edge, Image_orig, Image_name, current_generation, boundary_name, false, false);
    
    
    %%%%%%%%%%%%%%%%%%%SIMULATED OVERLAY STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pad_method = 'extreme';
    [diff_inner, diff_outer] = Calculate_sim_detected_score(Inner_Edge, Outer_Edge, pad_method);
    [bw_out, bw_in] = Simulated_Overlay(diff_inner, diff_outer,...
    Inner_Edge, Outer_Edge, Image_orig, 'inner', pad_method);
    Outer_Edge = bw_out;
    Inner_Edge = bw_in;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Combined_Edge = Outer_Edge + Inner_Edge;
    overlay = double(imoverlay(Image_orig, Outer_Edge/1000000, [1 0 0]));
    overlay = imoverlay(overlay, Inner_Edge, [0 0 1]);
    figure
    Combined_overlay = (overlay/max(max(max(overlay))));
    imshow(Combined_overlay);
    
    if save_edges == true
        
        imwrite(Combined_overlay, sprintf('%s/%s_edges.jpg',save_directory,Image_name));

        close all

        outer_coords = bw2coords(Outer_Edge);
        inner_coords = bw2coords(Inner_Edge);

        csvwrite(sprintf('%s/%s_outer.csv',save_directory, Image_name), outer_coords);
        csvwrite(sprintf('%s/%s_inner.csv',save_directory, Image_name), inner_coords);

        save(sprintf('%s/%s_Inner_Edge.mat',save_directory, Image_name), 'Inner_Edge');
        save(sprintf('%s/%s_Outer_Edge.mat',save_directory, Image_name), 'Outer_Edge');
    end
    
    if save_parameters == true
        fittest = fittest_individual_outer;
        save(sprintf('%s/%s_PST_parameters.mat', save_directory, Image_name), 'fittest');
    end

    
      toc
  end
end