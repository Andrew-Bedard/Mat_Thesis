function Children = crossover(Individuals_vec, Tournament_winners )
%CROSSOVER Summary of this function goes here
%   Simple crossover for creation of children
%   Creates 1 child for every 2 randomly selected parents

%Crossover

Children = zeros(length(Tournament_winners)/2,5);

dummy_child = zeros(5,1);

dummy_counter = 1;

for i = 1:2:length(Tournament_winners)
    parent1 = Individuals_vec(Tournament_winners(i),:);
    parent2 = Individuals_vec(Tournament_winners(i+1),:);
    for j=1:5
        if rand > 0.5
            dummy_child(j) = (parent1(j) + parent2(j))/2;
        elseif rand > 0.5
            dummy_child(j) = parent1(j);
        else
            dummy_child(j) = parent2(j);
        end
    end
    
    Children(dummy_counter,:) = dummy_child;
    dummy_counter = dummy_counter + 1;
end

end

