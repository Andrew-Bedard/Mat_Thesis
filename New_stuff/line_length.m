function total_length = line_length(outline_points)

%gives the total length of line, maybe useful for subdividing edges into
%cells

  x = outline_points(1,:);
  y = outline_points(2,:);
  d = diff([x(:) y(:)]);
  total_length = sum(sqrt(sum(d.*d,2)));