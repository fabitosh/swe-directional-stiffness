vol_0deg = load('MaskedVolume_SWE_C190201_L3L4_0deg_2019_07_31_15_3.mat');
vol_90deg = load('MaskedVolume_SWE_C190201_L3L4_90deg_2019_07_31_15_4.mat');
vol_0deg = vol_0deg.masked_vol;
vol_90deg = vol_90deg.masked_vol;

center_0deg = Centroid(vol_0deg);
center_90deg = Centroid(vol_90deg);
tf = center_90deg - center_0deg;