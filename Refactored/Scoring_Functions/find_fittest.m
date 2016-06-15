function [fittest_individual, loop_break_counter] = find_fittest(population, children,...
    children_scores, score_vec, loop_break_counter, fittest_individual, disp_output)

%FIND_FITTEST: takes entire population including new children, score vector,
%loop break counter and fittest individual up until this point. If current generations fittest
%individual has a fitness greater than that of the previous, it replaces
%the old one and resets the loop break counter, otherwise the fittest
%individual and loop break counter remain unchanged. 


% add children to population

population = [population; children];

% add children_scores to score_vec

score_vec = [score_vec children_scores];

% sort the scores in score vector
sorted_scores = sort(score_vec, 'descend');

% find index of individual with highest score in score vector
generation_winner = find(score_vec == sorted_scores(1));
% in case of it, ensure only one member is chosen
generation_winner = generation_winner(1);

% Save best winning individuals score and parameters thus far, if fittest
% individual is different than previous generation, reset loop break
% counter

if sorted_scores(1) > fittest_individual(end)
    fittest_individual(end) = sorted_scores(1);
    fittest_individual(1:(end - 1)) = population(generation_winner,:);
    loop_break_counter = 0;
end

% output score of fittest individual if disp_output = true

if disp_output == true
    sprintf('best score: %d', fittest_individual(end))
end;

