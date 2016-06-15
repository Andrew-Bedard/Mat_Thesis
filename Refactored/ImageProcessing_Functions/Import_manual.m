function [ boundary ] = Import_manual( Image_name, boundary_name)
%IMPORT_MANUAL: Imports manually obtained inner or outer boundary

%Load boundary based on Image name and the type of boundary, either Inner
%or Outer

boundary = load(sprintf('%s_mask_%s.mat', Image_name, boundary_name));
boundary = struct2array(boundary);

end

