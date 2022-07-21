function CYJ_SPM_smooth_nomask(image,FWHM)
image = {[image ',1']};

matlabbatch{1}.spm.spatial.smooth.data = image;
matlabbatch{1}.spm.spatial.smooth.fwhm = [FWHM FWHM FWHM];
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';
spm_jobman('run', matlabbatch);