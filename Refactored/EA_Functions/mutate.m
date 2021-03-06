function Mutant_children = mutate( Children, Algo_depth, boundary_name )
%MUTATE 
%   Basic mutation with added term to decrease mutation size as algorithm
%   progresses

%Override Algo_depth for testing

%Algo_depth = 1;

child_num = length(Children(:,1));

alpha1 = (2*rand-1)/(100+Algo_depth);
alpha2 = (2*rand-1)*(2/Algo_depth);

for i = 1:child_num
   Children(i,1) = Children(i,1) + alpha1;
   Children(i,2) = Children(i,2) + alpha2;
   Children(i,3) = Children(i,3) + alpha2;
   Children(i,4) = Children(i,4) + alpha1;
   Children(i,5) = Children(i,5) + alpha1;
end


if strcmp(boundary_name, 'Inner')
    for i = 1:child_num
       Children(i,6) = round(Children(i,6) + round((2*rand-1)/(Algo_depth)));
       Children(i,7) = round(Children(i,7) + round((2*rand-1)/Algo_depth));
       Children(i,8) = round(Children(i,8) + (2*rand-1)/(100+Algo_depth));
       Children(i,9) = round(Children(i,9) + (2*rand-1)/(Algo_depth));
       Children(i,10) = Children(i,10)*round(rand/(100+Algo_depth));
    end
end

Mutant_children = Children;

end

