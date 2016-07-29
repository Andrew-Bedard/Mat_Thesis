% figure, imshow(BW,[]);
% %Overlay normals to verify
% hold on
% quiver(c,r,-Onc(idx),Onr(idx));
% 
% angle = 152.1079;
% point = [189, 12];
% x_line = 1:280;
% 
% [line_poly] = line_eqt(angle, point);
% 
% x_line = 1:280;
% 
% y_line = polyval(line_poly, x_line);
% 
% hold on;
% 
% plot(x_line, y_line);

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


bw_filled = imfill(BW, 'holes');
coord_out = bwboundaries(bw_filled);
coord_out = coord_out{1}';

for i = 1:20:length(coord_out)
    
    angle = Onormal(coord_out(1,i),coord_out(2,i));
    
    point = [coord_out(1, i), coord_out(2, i)];
    
    [line_poly] = line_eqt(angle, point);

    y_line = polyval(line_poly, x_line);

    hold on;

    plot(x_line, y_line);
    
    pause(0.1)
end