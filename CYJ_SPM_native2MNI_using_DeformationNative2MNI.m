function CYJ_SPM_native2MNI_using_DeformationNative2MNI(tobeMove,deformation,MNIref,outpath,prefix,interp_ind,FWHM_ind)
% interp_ind 0:nn;1:trilinear;2-7:B-spline;-1:categorical(it is for label)
matlabbatch{1}.spm.util.defs.comp{1}.def = {deformation};
matlabbatch{1}.spm.util.defs.comp{2}.id.space = {MNIref};
matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {tobeMove};
matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.saveusr = {outpath};
matlabbatch{1}.spm.util.defs.out{1}.pull.interp = interp_ind;
matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [FWHM_ind FWHM_ind FWHM_ind];
matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = [prefix '_'];
spm_jobman('run', matlabbatch);