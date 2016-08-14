BW = bw_in;
Orientations = skeletonOrientation(BW,5); %5x5 box
Onormal = Orientations + 90; %easier to view normals
Onr = sind(Onormal); %vv
Onc = cosd(Onormal); %uu
[r,c] = find(BW);    %row/cols
idx = find(BW);      %Linear indices into Onr/Onc
imshow(BW,[]);
%Overlay normals to verify
hold on
quiver(c,r,-Onc(idx),Onr(idx));