lpl = 0:0.1:1;
pl = 0:1:20;
wl = 0:1:20;
tmin = 0.0001:0.001:0.0081;
tmax = 0.90:0.01:0.99;



Image_orig = Ivessel;
Edge_master = zeros(size(Ivessel));


for lpl = 0:0.1:1
    for pl = 0:2:20;
        for wl = 0:2:20;
            for tmin = 0.0001:0.002:0.0081;
                for tmax = 0.90:0.02:0.98;
                    
                    % low-pass filtering (also called localization) parameter
                    handles.LPF=lpl; % Gaussian low-pass filter Full Width at Half Maximum (FWHM) (min:0 , max : 1)

                    % PST parameters
                    handles.Phase_strength=pl;  % PST  kernel Phase Strength
                    handles.Warp_strength=wl;  % PST Kernel Warp Strength

                    % Thresholding parameters (for post processing)
                    handles.Thresh_min=-tmin;      % minimum Threshold  (a number between 0 and -1)
                    handles.Thresh_max=tmax;  % maximum Threshold  (a number between 0 and 1)

                    [Edge, ~]= PST(Image_orig,handles,1);
                    Edge_master = Edge_master + Edge;
                end
            end
        end
    end
end


