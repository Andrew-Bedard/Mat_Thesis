image_dir = dir('C:\Users\Andy\Documents\School\Thesis\Images\allimages');
save_directory = sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Batch_Results');
params_dir = dir('C:\Users\Andy\Documents\School\Thesis\Images\Batch_Results\Parameters');


%Number of individuals in tournament
save_edges = false;

for i = 14:numel(image_dir)
  filename = image_dir(i).name;
  
  % Open the file specified in filename, do your processing...
  [~, Image_name] = fileparts(filename);
  
  % Prevent from trying to run EA on files not associated with image file,
  % or have already had EA run over
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
      
    
    for j = 1:numel(params_dir)
        filename = params_dir(j).name;
        [~, Individual_name] = fileparts(filename);
        
        if exist(sprintf('%s.mat', Individual_name),'file') ~= 0
            
            Parameter_Struct = load(sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Batch_Results/Parameters/%s.mat',Individual_name));
            fittest_individual_outer = Parameter_Struct.fittest;
            
            boundary_name = 'Outer';            

            %Take a look at what outer edge looks like, last parameter for saving, set
            %to false to supress output
            current_generation = 0;
            [Outer_Edge] = Edge_OutputAndSave_Outer(fittest_individual_outer,...
                      Image_orig, Image_name, current_generation, boundary_name, false, false);


            %inner boundary

            boundary_name = 'Inner';
            % 

            [Inner_Edge] = Edge_OutputAndSave_Inner_nonEA(fittest_individual_outer,...
                Outer_Edge, Image_orig, Image_name, current_generation, boundary_name, false, false);
            
            outsize = size(Outer_Edge);
            insize = size(Inner_Edge);
            size_compare = (outsize == insize);
            
            if sum(size_compare) ~= 2
                Inner_Edge = zeros(outsize);
            end
            
            %Test to make sure inner or outer edge is not empty
            
            if sum(sum(Outer_Edge)) ~= 0 && sum(sum(Inner_Edge)) ~= 0

                %%%%%%%%%%%%%%%%%%%SIMULATED OVERLAY STUFF%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                pad_method = 'extreme';
                [diff_inner, diff_outer] = Calculate_sim_detected_score(Inner_Edge, Outer_Edge, pad_method);
                [bw_out, bw_in] = Simulated_Overlay(diff_inner, diff_outer,...
                Inner_Edge, Outer_Edge, Image_orig, 'inner', pad_method);
                Outer_Edge = bw_out;
                Inner_Edge = bw_in;
                
                %Check for obvious errors in edges
                [good_in, good_out] = error_checking(Inner_Edge, Outer_Edge);
                
                if good_in == false && good_out == false
                    
                
                %Re-calculate scores based off combined simulated-detected
                %Edges, used for selection of best fit
                [diff_inner, diff_outer] = Calculate_sim_detected_score(Outer_Edge, Inner_Edge, pad_method);
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