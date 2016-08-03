%Image directory
image_dir = dir('C:\Users\Andy\Documents\School\Thesis\Images\allimages');

%Directory to which data is to be saved
save_directory = sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Batch_Results');

%Directory where previously calculated optimal PST parameters are saved
params_dir = dir('C:\Users\Andy\Documents\School\Thesis\Images\Batch_Results\Parameters');

%Directory where post processed simulated boundaries live
boundary_dir = dir('C:\Users\Andy\Documents\School\Thesis\Data\Simulated2bw');

%The stages of the effective range of our method
effective_range = {'midblastula', 'lateblastula', 'earlygastrula', ...
    'midgastrula'};

%Load in data structure with all information regarding names of stages,
%abreviations attached to images and hours post fertilization times
Dev_stages = load('C:\Users\Andy\Documents\School\Thesis\Data\Dev_stages.mat');

%Find the index in our data structure where the effective range data lives
effective_index = zeros(1,numel(effective_range));

for i = 1:numel(effective_range)
    effective_index(i) = find(strcmp(stages, effective_range{i}));
end

%Save output
save_edges = false;

for i = 19:numel(image_dir)
  filename = image_dir(i).name;
  
  % Open the file specified in filename, do your processing...
  [~, Image_name] = fileparts(filename);
  
  % Prevent from running on files not associated with image, and prevent
  % from running on images that are outside the effective range of this
  % method
  if exist(sprintf('%s.jpg',Image_name),'file') ~= 0
      
      % Name of directory to save binary images
      dirpath = save_directory;
      
      % If directory doesnt exist, create one
      if exist(dirpath,'dir') == 0
          mkdir(dirpath);
          addpath(dirpath);
      end
      
      % import original image, convert to double greyscale
      Image_orig = Im_import(Image_name);
      
      tic
      
      %List to keep track of errors in overlayed edges to pick smallest
      diff_list = ones(2, numel(params_dir));
      diff_list = diff_list.*99999999;
      
    %Loop through, attempting to find best edge overlay based off all
    %previously calculated parameters
    for j = 6:numel(params_dir)
        filename = params_dir(j).name;
        [~, Individual_name] = fileparts(filename);
        
        if exist(sprintf('%s.mat', Individual_name),'file') ~= 0
            
            %Load pre-calculated parameters from PST optimization
            Parameter_Struct = load(sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Batch_Results/Parameters/%s.mat',Individual_name));
            fittest_individual_outer = Parameter_Struct.fittest;
            
            boundary_name = 'Outer';            

            %Find outer edge
            current_generation = 0;
            [Outer_Edge] = Edge_OutputAndSave_Outer(fittest_individual_outer,...
                      Image_orig, Image_name, current_generation, boundary_name, false, false);


            %inner boundary

            boundary_name = 'Inner';
            
            % Find inner edge using
            [Inner_Edge] = Edge_OutputAndSave_Inner_nonEA(fittest_individual_outer,...
                Outer_Edge, Image_orig, Image_name, current_generation, boundary_name, false, false);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Had weird issues with detected edges being in arrays of
            % different sizes, which causes issues, so here is a bandaid
            % that nukes the inner edge to an array of zeros
            outsize = size(Outer_Edge);
            insize = size(Inner_Edge);
            size_compare = (outsize == insize);
            
            if sum(size_compare) ~= 2
                Inner_Edge = zeros(outsize);
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %Test to make sure inner or outer edge is not empty
            
            if sum(sum(Outer_Edge)) ~= 0 && sum(sum(Inner_Edge)) ~= 0

                %%%%%%%%%%%%%%%%%%%SIMULATED OVERLAY STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                pad_method = 'extreme';
                [diff_inner, diff_outer] = Calculate_sim_detected_score(Inner_Edge, Outer_Edge, pad_method);
                [bw_out, bw_in] = Simulated_Overlay(diff_inner, diff_outer,...
                Inner_Edge, Outer_Edge, Image_orig, 'inner', pad_method);

                %Check for obvious errors in edges
                [good_in, good_out] = error_checking(bw_in, bw_out);
                
                if good_in == false && good_out == false
                    %If both edges are no good, retry with different method
                    %for calculating developmental stage
                    [bw_out, bw_in] = Simulated_Overlay(diff_inner, diff_outer,...
                    Inner_Edge, Outer_Edge, Image_orig, 'outer', pad_method);
                    
                    %Check for errors in new edges
                    [good_in, good_out] = error_checking(bw_in, bw_out);
                    
                    if good_in == false && good_out == false
                        %If the attempt to use a different method did not
                        %work, nuke both inner and outer boundaries
                        bw_in = zeros(size(bw_out));
                        bw_out = zeros(size(bw_out));
                    end
                    
                elseif good_in == false && good_out == true
                    %Until I decide on a way to properly handle this, just
                    %nuke the inner edge if it's nonsense
                    bw_in = zeros(size(bw_out));
                end
                
                Outer_Edge = bw_out;
                Inner_Edge = bw_in;
                
                %Re-calculate scores based off combined simulated-detected
                %Edges, used for selection of best fit
                [diff_inner, diff_outer] = Calculate_sim_detected_score(Inner_Edge, Outer_Edge, pad_method);
                %diff_list(j,:) = [diff_inner; diff_outer];

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                Combined_Edge = Outer_Edge + Inner_Edge;
                try
                    overlay = double(imoverlay(Image_orig, Outer_Edge/1000000, [1 0 0]));
                    overlay = imoverlay(overlay, Inner_Edge, [0 0 1]);
                    figure
                    Combined_overlay = (overlay/max(max(max(overlay))));
                    imshow(Combined_overlay);
                catch
                end
            end
        end
    end
    
    if save_edges == true
        
        imwrite(Combined_overlay, sprintf('%s/Overlays/%s_edges.jpg',save_directory,Image_name));

        close all

        outer_coords = bw2coords(Outer_Edge);
        inner_coords = bw2coords(Inner_Edge);

        csvwrite(sprintf('%s/CSVS/%s_outer.csv',save_directory, Image_name), outer_coords);
        csvwrite(sprintf('%s/CSVS/%s_inner.csv',save_directory, Image_name), inner_coords);

        save(sprintf('%s/Edges/%s_Inner_Edge.mat',save_directory, Image_name), 'Inner_Edge');
        save(sprintf('%s/Edges/%s_Outer_Edge.mat',save_directory, Image_name), 'Outer_Edge');
    end

    
      toc
  end
end