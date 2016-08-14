function rgb_means = channel_means(Img)

%Calculates the mean colours for each channel column by column, this allows
%us to remove entries that are zero that we intend to ignore without
%affecting the mean value calculated.

%Takes one argument: Img which is our original image

channel_means = zeros(1,length(Img(1,:,1)),3);

for i = 1:3
    for j = 1:length(Img(1,:,1));
        current_col = Img(:,j,i);
        current_col = current_col(current_col ~= 0);
        current_mean = mean(current_col);
        channel_means(1,j,i) = current_mean;
    end
end

redMeans = channel_means(1,:,1);
blueMeans = channel_means(1,:,2);
greenMeans = channel_means(1,:,3);

redMeans = redMeans(isnan(redMeans) == 0);
blueMeans = blueMeans(isnan(blueMeans) == 0);
greenMeans = greenMeans(isnan(greenMeans) == 0);

%Mean value for each channel
rgb_means = [mean(redMeans), mean(blueMeans), mean(greenMeans)];