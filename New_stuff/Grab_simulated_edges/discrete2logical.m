function [bw_in, bw_out] = discrete2logical(rounded_in, rounded_out)

%For use in csv2logical, takes rounded_in and rounded_out an converts both
%into logical arrays where bw_in(i,j) == 1 if rounded_in(X,X) = (i;j)

bw_in = zeros(max(rounded_out(2,:)), max(rounded_out(1,:)));
bw_out = zeros(max(rounded_out(2,:)), max(rounded_out(1,:)));

for i = 1:length(rounded_in(1,:))
    bw_in(rounded_in(2,i),rounded_in(1,i)) = 1;
    bw_out(rounded_out(2,i), rounded_out(1,i)) = 1;
end

bw_in = imresize(bw_in,[500,500]);
bw_in = logical(bw_in);


bw_out = imresize(bw_out,[500,500]);
bw_out = logical(bw_out);