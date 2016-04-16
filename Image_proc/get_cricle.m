% get a cirlce from roughly the centre of image

len = length(Image_orig(1,:));
wid = length(Image_orig(:,1));

mid = [ceil(len/2), ceil(wid/2)];

t = linspace(0,2*pi,len);
s = linspace(0,2*pi,wid);
h = mid(1);
k = mid(2);
r = wid/4;
x = r*cos(s) + h;
y = r*sin(t) + k;
