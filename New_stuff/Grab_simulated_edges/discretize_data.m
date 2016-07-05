function [rounded_in, rounded_out] = discretize_data(continuous_in, continuous_out)

%Takes 'continuous' edge data from simulations, transforms into integers
%and ensures no element is less than 1, this makes the other steps of
%extracting a logical array easier. The offset to ensure no elements are
%less than 1 is calculated w.r.t. the outer edge so the size and distance
%between in the inner and outer edge are not changed w.r.t each other.

rounded_out = zeros(size(continuous_out));
rounded_in = zeros(size(continuous_in));

for i = 1:2
    
    dummy_out = continuous_out(i,:).*1000;
    dummy_in = continuous_in(i,:).*1000;
    
    offset = abs(min(dummy_out)) + 1;
    
    dummy_out = dummy_out + offset;
    dummy_in = dummy_in + offset;
    
    dummy_out = round(dummy_out,0);
    dummy_in = round(dummy_in,0);

    rounded_out(i,:) = dummy_out;
    rounded_in(i,:) = dummy_in;
    
end

