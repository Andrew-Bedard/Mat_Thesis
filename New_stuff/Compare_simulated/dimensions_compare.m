function out_to_in_ratio = dimensions_compare(bw_in, bw_out)

%Compare the size of bw_resized inner and outer, to the size of bw_in and
%bw_out. The idea is if there is a huge discrepancy then there may be
%something funky happening, usually with bw_resized_inner, use default size
%relative to bw_resized_outer.

[in_x_diff, in_y_diff, ~] = extreme_diff(bw_in);
[out_x_diff, out_y_diff, ~] = extreme_diff(bw_out);

out_to_in_ratio = [(out_x_diff/in_x_diff), (out_y_diff/in_y_diff)];

