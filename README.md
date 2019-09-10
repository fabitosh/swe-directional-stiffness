# swe-directional-stiffness
The script is developed to be used within a pipeline processing multiple shear wave elastography images into a 3d representation. Stiffness volumes are computed into a voxels grid and fed into this algorithm. In the original purpose of this code, two measurements of the same object, but with different scan orientation are processed and compared.

The two 3d-grid volumes are aligned according to their (ideally identical) object mask. Mask points have -1 stiffness values and are only used to compute the center of the object and to align the two volumes.

The stiffness data is processed and visualised in a cylindrical coordinate system as well as a graphical interface. The directional stiffnesses can be interpreted as function of parameters such as radius, angle etc.

Developed and tested on MATLAB R2018b

## Main.m
Main Executable. Handling the experiment volume pairs, which need to be placed within _datapath_ according to the agreed on naming convetion. After some validation checks of the experiment names, each volume pair is computed with _uberplotMaskedVolPair.m_. The function outputs summarizing plots, which are saved in a user defined directory.

### uberplotMaskedVolPair.m
* Transforms the volumes to pointclouds (pcls)
* Aligns the second pcl to the first using the differences of the principal component analysis (PCA). This alignment is dependant on the similarity of the two masks. As main axes are untouched, a reasonable alignment between the volumes is required. 
* Computes stiffness interpretations of the volumes and visualizes them on top of the masks. The data is flattened onto the x-y-pane and smoothened with a gaussian convolution filter in _compSmoothed2DStiffnessArray()_. Additionaly a threshold is introduced, requiring a minimum amount of measurements to be represented in the plot. 
* Alternatively, stiffness is plotted for different variables. To make the scatter plot better interpretable, _binnedDataVisualisation()_ also mean and standard deviations for _nr_bins_ equally spread segments of the dependent variable. 
