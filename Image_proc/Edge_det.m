%Using standard methods to grab edges directly from in-situ

I = imread('Bmp2_4_early_gast.jpg');
I = rgb2gray(I);
%figure, imshow(I), title('original image');
[~, threshold] = edge(I, 'sobel');
fudgeFactor = 0.6;
BWs = edge(I,'sobel',threshold * fudgeFactor);
%figure, imshow(BWs), title('binary gradient mask');
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
BWsdil = imdilate(BWs, [se90 se0]);
B = bwboundaries(BWsdil,4,'holes');
%figure, imshow(B), title('this new thing');
%figure, imshow(BWsdil), title('dilated gradient mask');
BWdfill = imfill(BWsdil, 'holes');
%figure, imshow(BWdfill);, title('holes filled');
BWnobord = imclearborder(BWdfill, 4);
%figure, imshow(BWnobord), title('Clear border image');
seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
figure, imshow(BWfinal), title('segmented image');
BWoutline = bwperim(BWfinal);
Segout = I;
Segout(BWoutline) = 255;
figure, imshow(Segout), title('outlined original');

