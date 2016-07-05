function [bw_in, bw_out] = discrete2logical(rounded_in, rounded_out)

bw_in = zeros(max(rounded_out(2,:)), max(rounded_out(1,:)));
bw_out = zeros(max(rounded_out(2,:)), max(rounded_out(1,:)));

for i = 1:length(rounded_in(1,:))
    bw_in(rounded_in(2,i),rounded_in(1,i)) = 1;
    bw_out(rounded_out(2,i), rounded_out(1,i)) = 1;
end

bw_in = imresize(bw_in,[280,280]);
bw_in = logical(bw_in);


bw_out = imresize(bw_out,[280,280]);
bw_out = logical(bw_out);