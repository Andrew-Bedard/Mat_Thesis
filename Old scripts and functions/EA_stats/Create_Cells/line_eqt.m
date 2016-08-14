function [line_poly] = line_eqt(angle, point)

%Takes point and angle and creates line eqt: y = m*x+b
angle = 180 - angle;
rad = (angle*pi)/180;

m = tan(rad);

b = point(1) - (tan(rad) * point(2));

% if angle - 90 > 0
%     m = m*(-1);
% end

line_poly = [m, b];