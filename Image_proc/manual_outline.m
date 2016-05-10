
%Allows one to select outline of image and output it as a collection of
%coordinates

contents = dir('C:\Users\Andy\Documents\School\Thesis\Images\Kahikai\Images');
for i = 1:numel(contents)
    filename = contents(i).name;

    % Open the file specified in filename, do your processing...
    [~, I_name] = fileparts(filename);
    
     %Make sure we are only trying to find boundary for image files
     if exist(sprintf('%s.jpg',I_name),'file') ~= 0 %&& exist(sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Kahikai/Binary_masks/%s_mask.mat',I_name),'file') == 0

        I = imread(sprintf('%s.jpg',I_name));
        try
            I=rgb2gray(I);
        catch
        end
        figure, imshow(I)
        BW = roipoly(I);

        prompt = 'press enter once mask is saved ';
        input(prompt,'s');
        %Now requires the selection of the inside of the polygon to create a mask
        %with, then use the following: 
        BW2 = bwperim(BW,8); 
        BW3 = imdilate(BW2,strel('disk',1));
        %where imdilate increases the edge thickness because manual outlines are
        %not going to be perfect

        imshow(BW3)
        save(sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Kahikai/Binary_masks/%s_mask',I_name),'BW3');
        clear BW3;
        close all;

        %%%%%%% USE THIS FOR DILATING OR ERODING MASKS IN A FILE %%%%%%%%
%         load(sprintf('%s_mask.mat',I_name));
%         BW3 = imdilate(BW3,strel('disk',1));
%         save(sprintf('C:/Users/Andy/Documents/School/Thesis/Images/Kahikai/Binary_masks/%s_mask',I_name),'BW3');
%         clear BW3;
     end



end