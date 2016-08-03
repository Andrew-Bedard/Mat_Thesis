function [bool_range, hpf_range, dummy_index, dummy_lengths, longest_index] = Gast_Stage(Im_name, Dev_stages, effective_index)

%Searches image name for information regarding the stage of gastrulation,
%if the stage labelled in the image name is within the effective range,
%then bool_range = true, and the hpf range is given.
%Takes as arguments our Image name: Im_name, Dev_stages structure which holds all info on naming
%conventions, and effetive_range, which is a pre-determined list of stages
%of gastrulation where our algorithm is effective

hpf_range = [0,0];
dummy_index = zeros(1,20);
dummy_lengths = zeros(1,20);
counter = 0;

for i = 1:length(effective_index)
    
    stage = Dev_stages(effective_index(i)).abrevs;
    
    for j = 1:length(stage)
        
        %Compare strings
        k = strfind(Im_name, stage(j));
        
        %If there is a positive match, save some values
        if isempty(k) == false
            counter = counter + 1;
            %Save the index of effective_index where postiive value found
            dummy_index(counter) = i;
            %Save the length of the abreviation found, as there is overlap
            %in the naming convention we will default to using the longer
            %name as it provides greater specificity
            dummy_lengths(counter) = length(stage{j});
            %bool_range indicates we have found a match
            bool_range = true;
            
        end
    end
end

dummy_index = dummy_index(dummy_index ~= 0);
dummy_lengths = dummy_lengths(dummy_lengths ~= 0);

longest_index = find(max(dummy_lengths));