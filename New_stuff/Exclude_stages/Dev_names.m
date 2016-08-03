stages = {'zygote', 'cleavage', 'earlyblastula', 'midblastula', 'lateblastula', 'earlygastrula', ...
    'midgastrula', 'lategastrula', 'earlyplanula', 'midplanula', 'lateplanula'};

abrevs = {{'zy'}, {'cle'}, {'ebla', 'ebl'}, ...
    {'blastula', 'mbla', 'mbl', 'bla', 'bl', 'br', 'bx', 'bo', 'b1', 'b2', 'b3', 'b4'}, ...
    {'lbla', 'lbl'}, {'ega', 'eg'}, {'mga', 'mg', 'gas', 'gastrula'}, ...
    {'lga', 'lg'}, {'epla', 'epl'}, {'mpla', 'mpl', 'pla', 'planula'}, ...
    {'lpla', 'lpl'}};

hpf = {[0, 2],[2, 12],[12, 14],[14, 18],[18, 20],[20, 28],[28, 32],...
    [32, 50],[50, 60],[60, 70],[70, 80]};

%Create structure with naming conventions and hpf info

Dev_stages = struct('names', stages, 'abrevs', abrevs, 'hpf', hpf);

effective_range = {'earlyblastula', 'midblastula', 'lateblastula', 'earlygastrula', ...
    'midgastrula'};

%Find the index in our data structure where the effective range data lives
index = zeros(1,numel(effective_range));

for i = 1:numel(effective_range)
    index(i) = find(strcmp(stages, effective_range{i}));
end

