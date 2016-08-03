function [bool_range, hpf_range] = Gast_Stage(Im_name, Dev_stages, effective_index)

%Searches image name for information regarding the stage of gastrulation,
%if the stage labelled in the image name is within the effective range,
%then bool_range = true, and the hpf range is given.
%Takes as arguments our Image name: Im_name, Dev_stages structure which holds all info on naming
%conventions, and effetive_range, which is a pre-determined list of stages
%of gastrulation where our algorithm is effective

hpf_range = [0,0];
abrevs = Dev_stages.abrevs;

for i = 1:length(abrevs)
    stage = abrevs{i};
    for j = 1:length(abrevs{i})
        k = strfind(Im_name, stage(j));
        if isempty(k) == false
            stage(j);
        end
    end
end