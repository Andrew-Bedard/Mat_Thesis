% Example,


% import original image
Image_orig=imread('chordin.jpg');

% if image is a color image, convert it to grayscale
try
    Image_orig=rgb2gray(Image_orig);
catch
end

% convert the grayscale image do a 2D double array
Image_orig=double(Image_orig);

for scale = 1:1:5
    for scl_range = 10:1:30
        for beta_one = 0.09:0.1:0.99

    options = struct('FrangiScaleRange', [1 scl_range], 'FrangiScaleRatio', scale, 'FrangiBetaOne', beta_one, 'FrangiBetaTwo', 1, 'verbose',false,'BlackWhite',true);

    Ivessel=FrangiFilter2D(Image_orig, options);
    imshow(Ivessel,[0 0.25])
%     subplot(1,2,1), imshow(Image_orig,[]);
%     subplot(1,2,2), imshow(Ivessel,[0 0.25]);
        end
    end
end