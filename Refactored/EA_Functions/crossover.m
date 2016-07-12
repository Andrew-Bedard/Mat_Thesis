function Children = crossover(population, Tournament_winners )
%CROSSOVER Summary of this function goes here
%   Simple crossover for creation of children
%   Creates 1 child for every 2 randomly selected parents

%Crossover

pop_length = length(population(1,:));

Children = zeros(length(Tournament_winners)/2,pop_length);

dummy_child = zeros(1, pop_length);

dummy_counter = 1;

% Single Arithmetic recombination

for i = 1:2:length(Tournament_winners)
    parent1 = population(Tournament_winners(i),:);
    parent2 = population(Tournament_winners(i+1),:);
    for j=1:pop_length
        if rand > 0.5
            dummy_child(j) = (parent1(j)*rand + parent2(j)*rand)/2;
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

%n-Point crossover

% for i = 1:2:length(Tournament_winners)
%     parent1 = population(Tournament_winners(i),:);
%     parent2 = population(Tournament_winners(i + 1), :);
%     
%     %number_of_crossovers = randi(pop_length);
%     number_of_crossovers = 3;
%     cross_points = randi(number_of_crossovers, pop_length, 1);
%     
%     for j = 1:number_of_crossovers
%         if rand > 0.5
%             dummy_child(1:cross_points(j)) = parent1(1:cross_points(j));
%         else 
%             dummy_child(1:cross_points(j)) = parent2(1:cross_points(j));
%         end
%     end
%     
%     Children(dummy_counter,:) = dummy_child;
%     dummy_counter = dummy_counter + 1;
% end

%Uniform n-Point crossover

% for i = 1:2:length(Tournament_winners)
%     parent1 = population(Tournament_winners(i),:);
%     parent2 = population(Tournament_winners(i+1),:);
%     for j=1:pop_length
%         if rand > 0.5
%             dummy_child(j) = parent1(j);
%         else
%             dummy_child(j) = parent2(j);
%         end
%     end
%     
%     Children(dummy_counter,:) = dummy_child;
%     dummy_counter = dummy_counter + 1;
% end
% 
% end

