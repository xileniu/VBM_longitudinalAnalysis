function CYJ_SPM_MNI2native_using_DeformationNative2MNI(tobeMove,deformation,nativeref,outpath,prefix,modulated_ind,FWHM_ind,mask_ind,threshold)

matlabbatch{1}.spm.util.defs.comp{1}.def = {deformation};
matlabbatch{1}.spm.util.defs.out{1}.push.fnames = {tobeMove};
matlabbatch{1}.spm.util.defs.out{1}.push.weight = {''};
matlabbatch{1}.spm.util.defs.out{1}.push.savedir.saveusr = {outpath};
matlabbatch{1}.spm.util.defs.out{1}.push.fov.file = {nativeref};
matlabbatch{1}.spm.util.defs.out{1}.push.preserve = modulated_ind;
matlabbatch{1}.spm.util.defs.out{1}.push.fwhm = [FWHM_ind FWHM_ind FWHM_ind];
matlabbatch{1}.spm.util.defs.out{1}.push.prefix = [prefix '_'];
spm_jobman('run', matlabbatch);

if mask_ind==1
    [~,name,suffix]=fileparts(tobeMove);
    CYJ_SPM_thr_Image([outpath '/' prefix '_' name  suffix],threshold,outpath,[prefix '_' name suffix]);
end