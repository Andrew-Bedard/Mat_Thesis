function coord_array = bw2coords(bw_array)

%Takes logical array, outputs array of two vectors that contain the
%indicies of nonzero elements.

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%Don't use this function, instead imfill() then use bwboundaries()
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

coord_array = zeros(2,length(bw_array));

counter = 0;

for i = 1:length(bw_array)
    for j = 1:length(bw_array)
        if bw_array(i,j) == 1
            counter = counter + 1;
            coord_array(1,counter) = i;
            coord_array(2,counter) = j;
        end
    end
end