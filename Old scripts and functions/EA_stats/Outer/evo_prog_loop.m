%Performs EA on all images in set directory, and saves edges as binary
%image after set number of iterations, saves parameters of fittest
%individual in .mat file called winner, where the last parameter is the
%final score.


contents = dir('C:\Users\Andy\Documents\School\Thesis\Images\Kahikai\Images');

%Inner or Outer boundary

bdry = 'Outer';


%List of all errors

err_list = zeros(30, numel(contents));


for i = 1:numel(contents)
% for i = 1:3
  filename = contents(i).name;
  
  % Open the file specified in filename, do your processing...
  [~, name] = fileparts(filename);
  
  % Prevent from trying to run EA on files not associated with image file,
  % or have already had EA run over
  if exist(sprintf('%s.jpg',name),'file') ~= 0 && exist(sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Kahikai/EA_prog/%s/%s',bdry,name),'dir') == 0
      
      % Name of directory to save binary images
      dirpath = sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Kahikai/EA_prog/%s/%s',bdry,name);
      
      % If directory doesnt exist, create one
      if exist(dirpath,'dir') == 0
          mkdir(dirpath);
      end
      
      % Run EA and save images every im_save_int until generations number
      % of loops, save parameters of fittest individual and list of errors
      % over time
      [winner,scores_list] = evo_test(name,100,30,1,bdry);
      
      %Scores list of errors to aggregate
      err_list(:,i) = scores_list;
      
      %Save parameters of fittest solution
      save(sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Kahikai/EA_prog/%s/%s/fittest_ind',bdry,name),'winner');
  end
end

