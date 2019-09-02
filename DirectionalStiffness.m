%% Set directory to save output files
plotpath = 'mask_vis/';
if ~exist(plotpath, 'dir')
  mkdir(plotpath);
end

%% Loop over experiment folder
datapath = '/Users/fabiomeier/Documents/MATLAB/Maskedvolume_SWE/';
files = dir(strcat(datapath,'*.mat'));
L = length(files);

for ii = 1:2:L
    %% Get corresponding Experiment Pair out of Dataset
    str = split(files(ii).name, "_");
    str2 = split(files(ii+1).name, "_");
    basename = join([str(3), str(4)], "_");
    disp(basename)
    if strcmp(str(5), "0deg") 
        name_0deg = files(ii).name;
        if strcmp(str(3), str2(3)) && strcmp(str(4), str2(4))
            name_90deg = files(ii+1).name;
            disp(name_0deg)
            disp(name_90deg)
        else
            disp('Experiment Files do not match! Make sure they are ordered alphabetically and all experiments have a 0deg and 90deg scan');
            return
        end
    else
        disp('First file of index uneven (1, 3, ...) was not with a 0deg orientation.')
        return
    end
    vol_0deg_mask = load([datapath name_0deg]);
    vol_90deg_mask = load([datapath name_90deg]);
    vol_0deg_mask = vol_0deg_mask.masked_vol;
    vol_90deg_mask = vol_90deg_mask.masked_vol;
    
    uberplotMaskedVolPair(vol_0deg_mask, vol_90deg_mask)
    
    path_png = char(fullfile(plotpath, join([basename, '.png'], "")));
    path_fig = char(fullfile(plotpath, join([basename, '.fig'], "")));
    saveas(gcf, path_png);
%     saveas(gcf, path_fig);
end
