
 
e2 = Edge;
se = strel('disk',3,8);
e3 = imdilate(e2,se);
figure()
imshow(e3)
e4 = bwareafilt(e3,1,'largest');
figure
imshow(e4)
e5 = imdilate(e4,se);
figure
imshow(e5)
e6 = imerode(e5,se);
figure
imshow(e6)
e7 = imcomplement(e6);
load('C:\Users\Andy\Documents\School\Thesis\Images\Kahikai\Binary_masks\Outer\chordin_blast_mask_Outer.mat')
outedge = BW3;
clear BW3
filledout = imfill(outedge,'holes');
for i = 1:280
    for j = 1:280
        if filledout(i,j) ==0
            e7(i,j) = 0;
        end
    end
end
figure
imshow(e7)
e8 = bwareafilt(e7,1,'largest');
figure
imshow(e8)
e9 = imerode(e8,se);
figure
imshow(e9)
dilated = imdilate(e9,strel('disk',7));
new_edge = bwperim(dilated);
figure
imshow(new_edge)
new_edge = bwareafilt(new_edge,1,'largest');
overlay = double(imoverlay(Img, new_edge/1000000, [1 0 0]));
figure
imshow(overlay/max(max(max(overlay))));
title('Detected features using PST overlaid with original image')