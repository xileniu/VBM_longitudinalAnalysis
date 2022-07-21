function CYJ_dartel_normalise_to_MNI(flowfield,tissue,dartelTemplate6,modulate_ind,smooth_ind)

% one tissue one time

matlabbatch{1}.spm.tools.dartel.mni_norm.template = {dartelTemplate6};
matlabbatch{1}.spm.tools.dartel.mni_norm.data.subjs.flowfields = {flowfield};
matlabbatch{1}.spm.tools.dartel.mni_norm.data.subjs.images = {
                                                              {tissue}
                                                              }';
matlabbatch{1}.spm.tools.dartel.mni_norm.vox = [NaN NaN NaN];
matlabbatch{1}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                               NaN NaN NaN];
matlabbatch{1}.spm.tools.dartel.mni_norm.preserve = modulate_ind;
matlabbatch{1}.spm.tools.dartel.mni_norm.fwhm = [smooth_ind smooth_ind smooth_ind];
spm_jobman('run', matlabbatch);