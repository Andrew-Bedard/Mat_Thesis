function windowed_average = window_mean(rgb_values, window_size)

%Takes colour values in for of rgb (:,:,3) array, takes average over window
%of size: window_size, outputs average values centered at every point.

dummy_array = zeros(size(rgb_values));

for i = 1:length(dummy_array)
    
    %Circular shift array. This allows us to avoid using mode(), as matlab
    %isn't very happy with 0 indexed arrays.
    
    shifted_rgb = circshift(rgb_values,-i + (window_size/2));
    window = shifted_rgb(1:window_size + 1,:);
    
    %For each colour channel calculate mean of given window
    for j = 1:3       
        dummy_array(i,j) = mean(window(:,j));
    end
end

windowed_average = dummy_array;
    