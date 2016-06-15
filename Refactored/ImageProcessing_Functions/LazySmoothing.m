function [ Edge ] = LazySmoothing(Edge, UseCanny)
%LAZYSMOOTHING: using dilation and thinning. Allows the use of Canny edge
%detection as a method of smoothing.

Edge = imdilate(Edge,strel('disk',7));
Edge = bwmorph(Edge,'thin',inf);
Edge = imfill(Edge,'holes');

%Use canny edge detection. May not be appropriate for all cases
if UseCanny == true
    Edge = edge(Edge,'canny',[],10);
else
    Edge = bwperim(Edge);
end

end

