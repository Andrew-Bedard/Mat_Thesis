function tourn_winners = tourn( Score_vec, Tourn_num)
%TOURN Summary of this function goes here
%  Tournament

%Get indicies for individuals in descending order of their score
[~, Ind] = sort(Score_vec,'descend');

%Get rid of all indicies that do not make it into the top Tourn_num
Ind = Ind(1:Tourn_num);

%Generate random list of numbers 1:Tourn_num for tournament
rand_list = randperm(Tourn_num);

%Tournament

tourn_winners = zeros((Tourn_num/4),1);

dummy_counter = 1;

for i = 1:2:Tourn_num/2
    if Ind(rand_list(i)) >= Ind(rand_list(i+1))
        tourn_winners(dummy_counter) = Ind(rand_list(i));
    else
        tourn_winners(dummy_counter) = Ind(rand_list(i+1));
    end
    dummy_counter = dummy_counter + 1;
end


end

