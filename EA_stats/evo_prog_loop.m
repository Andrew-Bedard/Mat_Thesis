%Performs EA on all images in set directory, and saves edges as binary
%image after set number of iterations, saves parameters of fittest
%individual in .mat file called winner, where the last parameter is the
%final score.

contents = dir('C:\Users\Andy\Documents\School\Thesis\Images\Kahikai\Images');
for i = 1:numel(contents)
%for i = 1:3
  filename = contents(i).name;
  
  % Open the file specified in filename, do your processing...
  [~, name] = fileparts(filename);
  
  % Prevent from trying to run EA on files not associated with image file,
  % or have already had EA run over
  if exist(sprintf('%s.jpg',name),'file') ~= 0 && exist(sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Kahikai/EA_prog/%s',name),'dir') == 0
      
      % Name of directory to save binary images
      dirpath = sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Kahikai/EA_prog/%s',name);
      
      % If directory doesnt exist, create one
      if exist(dirpath,'dir') == 0
          mkdir(dirpath);
      end
      
      % Run EA and save images every im_save_int until generations number
      % of loops
      winner = evo_test(name,100,30,1);
      
      %Save parameters of fittest solution
      save(sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Kahikai/EA_prog/%s/fittest_ind',name),'winner');
  end
end

