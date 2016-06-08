function Mutant_children = mutate( Children, Algo_depth )
%MUTATE 
%   Basic mutation with added term to decrease mutation size as algorithm
%   progresses

for i = 1:length(Children(:,1))
   Children(i,1) = Children(i,1) + (2*rand-1)/(100+Algo_depth);
   Children(i,2) = Children(i,2) + (2*rand-1)*(2/Algo_depth);
   Children(i,3) = Children(i,3) + (2*rand-1)*(2/Algo_depth);
   Children(i,4) = Children(i,4) + (2*rand-1)/(100+Algo_depth);
   Children(i,5) = Children(i,5) + (2*rand-1)/(100+Algo_depth);
end

Mutant_children = Children;

end

