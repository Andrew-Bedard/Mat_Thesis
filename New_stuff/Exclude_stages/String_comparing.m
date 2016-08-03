function [bool_range, hpf_range] = Gast_Stage(Dev_stages)



for i = 1:length(abrevs)
    stage = abrevs{i};
    for j = 1:length(abrevs{i})
    k = strfind(name, stage(j));
    if isempty(k) == false
        stage(j)
    end
end
end