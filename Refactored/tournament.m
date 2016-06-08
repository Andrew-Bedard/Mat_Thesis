function tourn_winners = tournament( Score_vector, Tourn_size)
%TOURN: Tournament for selection of parents. Tourn_size fittest individuals
%are selected for direct comparison. The tournament matchups are randomly
%chosen.

%Get indicies for individuals in descending order of their score
[~, Ind] = sort(Score_vector,'descend');

%Get rid of all indicies that do not make it into the top Tourn_num
Ind = Ind(1:Tourn_size);

%Generate random list of numbers 1:Tourn_num for tournament selection
rand_list = randperm(Tourn_size);

%Tournament

tourn_winners = zeros((Tourn_size/4),1);

dummy_counter = 1;

for i = 1:2:Tourn_size/2
    if Score_vector(Ind(rand_list(i))) >= Score_vector(Ind(rand_list(i+1)))
        tourn_winners(dummy_counter) = Ind(rand_list(i));
    else
        tourn_winners(dummy_counter) = Ind(rand_list(i+1));
    end
    dummy_counter = dummy_counter + 1;
end


end

