function out_array = new_ind(number_of_individuals)
%NEW_IND Summary of this function goes here
%   Creates an array to hold the properties for PST
%   Rows are individuals, columns are properties
%   LPF between 0 and 1
%   Phase_Strength between 0 and 100
%   Warp_Strength between 0 and 100
%   Thresh_min between -1 and 0
%   Thresh_max between 0 and 1

dummy_array = zeros(number_of_individuals,5);

for i = 1:number_of_individuals
    
    LPF = rand;
    Phase_Strength = randi(100,1);
    Warp_Strength = randi(100,1);
    Thresh_min = -1*rand;
    Thresh_max = rand;
    
    dummy_array(i,:) = [LPF, Phase_Strength, Warp_Strength, Thresh_min, Thresh_max];

end

out_array = dummy_array;