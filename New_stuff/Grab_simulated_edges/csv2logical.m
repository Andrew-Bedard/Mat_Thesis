%Takes file with csv files of simulated boundary outlines and outputs
%logical arrays that are needed to analysis

contents = dir('C:\Users\Andy\Documents\School\Thesis\Data\Smoothen_Boundaries');
dirpath = sprintf('C:/Users/Andy/Documents/School/Thesis/Mat_Thesis/New_stuff/Grab_simulated_edges/Simulated2bw');

% If directory doesnt exist, create one
if exist(dirpath,'dir') == 0
  mkdir(dirpath);
  addpath(dirpath);
end

for i = 3:4:numel(contents)
    
  filename = contents(i).name;
  
  % Open the file specified in filename, do your processing...
  [~, name] = fileparts(filename);
  
  % Prevent from trying to run on files not associated with csv file,
  % or have already been run over
  %if exist(sprintf('%s.csv',name),'file') ~= 0 && exist(sprintf('C:\Users\Andy\Documents\School\Thesis\Mat_Thesis\New_stuff\Grab_simulated_edges\Simulated2bw\%s',name),'dir') == 0
  if exist(sprintf('C:/Users/Andy/Documents/School/Thesis/Mat_Thesis/New_stuff/Grab_simulated_edges/Simulated2bw/%s',name),'dir') == 0    
      
      %Each csv has to be transformed simulataneously with its
      %complementary boundary, import_simulated_edges takes this into
      %account
      name = name(1:4);
      
     %Import csv from simulated inner and outer boundaries
     [sim_in, sim_out] = import_simulated_edges(name);
     
     %Round and descretize results for easier image processing
     [rounded_in, rounded_out] = discretize_data(sim_in, sim_out);
     [bw_in, bw_out] = discrete2logical(rounded_in, rounded_out);
      
      %Save logical arrays that represent simulated innner and outer
      %boundaries
      save(sprintf('C:/Users/Andy/Documents/School/Thesis/Mat_Thesis/New_stuff/Grab_simulated_edges/Simulated2bw/%s_bw_in.mat',name),'bw_in');
      save(sprintf('C:/Users/Andy/Documents/School/Thesis/Mat_Thesis/New_stuff/Grab_simulated_edges/Simulated2bw/%s_bw_out.mat',name),'bw_out');
      
  end
end