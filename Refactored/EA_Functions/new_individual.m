function out_array = new_individual(number_of_individuals, boundary_name)
%NEW_IND:
%   Creates an array to hold the properties for PST and/or Frangi filter.
%   If boundary_name = outer then only the following are used
%   Rows are individuals, columns are properties
%   LPF between 0 and 1
%   Phase_Strength between 0 and 100
%   Warp_Strength between 0 and 100
%   Thresh_min between -1 and 0
%   Thresh_max between 0 and 1
%   If boundary_name == inner the parameters of the Frangi filter are
%   included

if strcmp(boundary_name,'Outer')
    
    dummy_array = zeros(number_of_individuals,5);

    for i = 1:number_of_individuals

        %Parameters for PST
        LPF = rand;
        Phase_Strength = randi(100,1);
        Warp_Strength = randi(100,1);
        Thresh_min = -1*rand/(50 + 50*rand);
        Thresh_max = rand;

        dummy_array(i,:) = [LPF, Phase_Strength, Warp_Strength, Thresh_min, Thresh_max];

    end

    out_array = dummy_array;
else
    
    dummy_array = zeros(number_of_individuals,10);

    for i = 1:number_of_individuals
           
        % Parameters for PST
        LPF = rand;
        Phase_Strength = randi(100,1);
        Warp_Strength = randi(100,1);
        Thresh_min = -1*rand/(50 + 50*rand);
        Thresh_max = rand;
        
        % Parameters for Frangi filter
        ScaleRange = randi(20,1);
        StepSize = randi(5,1);
        Correction = 0.5 + 0.5*rand;
        Correction2 = randi(8,1);
        BlackWhite = 1;

        dummy_array(i,:) = [LPF, Phase_Strength, Warp_Strength, Thresh_min, Thresh_max, ...
            ScaleRange, StepSize, Correction, Correction2, BlackWhite];

    end

    out_array = dummy_array;
end