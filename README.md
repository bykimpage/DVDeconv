# DVDeconv
Deconvolution Matlab toolbox for fluorescence microscopy. 

<div>
<img src="https://user-images.githubusercontent.com/21983302/100435316-1ac7ab00-30e1-11eb-8d9f-93dd54db63d1.jpg" width="370" height="370">

<img src="https://user-images.githubusercontent.com/21983302/100435333-1dc29b80-30e1-11eb-9a6f-6fde4d9ff186.jpg" width="370" height="370">
</div>

DVDeconv contains below 3 folders.  

* PSFGenerator_GUI
* Deconv_GUI
* DataSet
  
"PSF Generator" and "Deconv_GUI" include Matlab GUI based tools for generating PSF and restoring images, respectively.  
"DataSet" includes a script for generating dataset.  

## Usage  
### PSFGenerator_GUI  
1. Launch Matlab.  
2. Add path.  
  addpath('PSFGenerator_GUI')  
3. Run.  
  PSFGenerator  
4. After inputting parameters, click 'Generate' button.

### Deconv_GUI
1. Launch Matlab.  
2. Add path.  
  addpath('Deconv_GUI')   
3. Run.  
  Deconv_GUI  
4. Click "Open" in Image section. And select folder that include images to restore.  
(ex) DataSet/G10-P  
5. Click "Open" in PSF section. And select folder that include PSF.  
(ex) DataSet/variantPSF  
6. Select algorithm and setting parameters in Algorithm section.  
(ex) GEM algorithm, γ = 0.0005 , c = 5  
7. After setting options for deconvolution in Result section, click "Run".  

### DataSet
When you want to generate bars image under depth-variant image model, refer dataset_variant.m script.  
When you want to generate bars image under depth-invariant image model, refer dataset_invariant.m script.

### Estimating aberration values  
(main function) DVDeconv/PSFGenerator_GUI/ToFindParameters.m  
(loss function) DVDeconv/PSFGenerator_GUI/myobjfun.m  
When PSF is unknown, aberration values for PSF generation are estimated by referring to the code above.  

## Demo in the paper 
### PSFGenerator_GUI  
1. Launch Matlab.  
2. Add path.  
  addpath('PSFGenerator_GUI')  
3. Run.  
4-1. Leaving the initial values, click 'Generate' button.  
Then, the PSFs for depth-variant asymmetric algorithms are generated and saved in the current folder.  
The PSF for depth-invariant asymmetric algorithm is h00064.mat  
The generated results can be downloaded from 'DataSet/DVAsymPSF', 'DataSet/InvAsymPSF'  
4-2. Set W8 and W12 to 0, click 'Generate' button.  
Then, the PSFs for depth-variant symmetric algorithms are generated and saved in the current folder.  
The PSF for depth-invariant symmetric algorithm is h00064.mat  
The generated results can be downloaded from 'DataSet/DVSymPSF', 'DataSet/InvSymPSF'  

### Deconv_GUI
1. Launch Matlab.  
2. Add path.  
  addpath('Deconv_GUI')    
3. Run.  
  Deconv_GUI  
4. Click "Open" in Image section. And select folder that include images to restore.    
For 15dB Dataset, set the path as 'DataSet/G15-P'  
For 10dB Dataset, set the path as 'DataSet/G10-P'   
5. Click "Open" in PSF section. And select folder that include PSF.  
Select the PSF folder that matches the algorithm you want to execute.  
ex) DataSet/DVAsymPSF for Depth-variant asymmetric OSL/GEM algorithm  
ex) DataSet/InvSymPSF for Depth-invariant symmetric OSL/GEM algorithm  
6. Select algorithm and setting parameters in Algorithm section.  
In the experiment in the paper,  
γ was set to 0.00001,  c was set to 0.6 in the 15dB dataset.  
γ was set to 0.0006, c was set to 5  for depth-variant GEM algorithm in the 10dB dataset.  
γ was set to 0.0001 for depth-variant algorithm except GEM in the 10dB dataset.  
7. After setting options for deconvolution in Result section, click "Run".  
The Depth-variant deconvolution results are obtained after 29 iterations.  
The Depth-invariant deconvolution results are obtained after 20 iterations.  
  
## References and License
If you find my work helpful in your research, please kindly cite below papers.

References:

[1] Kim, B., & Naemura, T. (2015). Blind depth-variant deconvolution of 3D data in wide-field fluorescence microscopy. Scientific reports, 5, 9894.  
[2] Kim, B., & Naemura, T. (2016). Blind deconvolution of 3D fluorescence microscopy using depth‐variant asymmetric PSF. Microscopy research and technique, 79(6), 480-494.  
[3] Kim, B (2021). An Open-Source MATLAB Toolbox for Depth-Variant Asym-metric Deconvolution of Fluorescence Micrographs. (in submission)  
  
If you have any questions please feel free to contact me at by1110.kim@samsung.com 
  
  
Author: Boyoung Kim  
Copyright (c) 2021 Boyoung Kim  
All rights reserved.


