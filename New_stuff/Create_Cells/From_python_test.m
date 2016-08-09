cell_polygons = loadjson('C:\Users\Andy\Documents\School\Thesis\Py_Thesis\NematostellaMorphGen-master\test3_polygons.json');

field_names = fieldnames(cell_polygons);

dummy_array = zeros(280,280);

bw_dummy = logical(dummy_array);

for i = 1:numel(field_names)
    
    testy = cell_polygons(1).(field_names{i});

    BW = roipoly(dummy_array, testy(:,2), testy(:,1));
    
    bw_dummy = bw_dummy + BW;

    %imshow(BW)
    
    %pause(0.1)
end

imshow(bw_dummy)