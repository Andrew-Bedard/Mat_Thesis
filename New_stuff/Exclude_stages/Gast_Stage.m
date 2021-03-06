function [bool_range, hpf_range] = Gast_Stage(Im_name, Dev_stages, effective_index)

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
bool_range = false;

for i = 1:length(effective_index)
    
    stage = Dev_stages.abrevs{effective_index(i)};
    
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

if bool_range == true;
    %Get rid of zeros
    dummy_index = dummy_index(dummy_index ~= 0);
    dummy_lengths = dummy_lengths(dummy_lengths ~= 0);

    %Find the index of the abreviation with the longest length
    longest_index = find(max(dummy_lengths));

    %The index of the abreviation with the longest length is the gastrulation
    %stage we are looking for, grab its hpf range
    hpf_index = effective_index(dummy_index(longest_index));
    hpf_range = Dev_stages.hpf{hpf_index};
end