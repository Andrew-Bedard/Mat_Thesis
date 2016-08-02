function [bool_value_in, bool_value_out] = error_checking(bw_in, bw_out)

%Function to check error conditions with edge placement

in_filled = imfill(bw_in, 'holes');
out_filled = imfill(bw_out, 'holes');

%Does the inner edge extend beyond the outer

combined_filled = in_filled + out_filled;
remainder = combined_filled - out_filled;

if sum(sum(remainder)) ~= 0
    bool_value_in = false;
end

%Do either or both edges take only a small fraction of the images area

im_area = length(bw_out)^2;

if sum(sum(out_filled)) <= 0.3*im_area
    bool_value_out = false;
end

if bool_value_out == false
    bool_value_in = false;
end
