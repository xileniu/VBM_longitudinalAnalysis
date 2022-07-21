function CYJ_longitudinal_estim_deformation_native2MNI(native2Avg,avg2MNI_flowfield,ref,DARTELtemplate6,outpath,prefix)
%%%%%%%%%%%%estimate deformation from native to MNI
matlabbatch{1}.spm.util.defs.comp{1}.def = {native2Avg};
matlabbatch{1}.spm.util.defs.comp{2}.dartel.flowfield = {avg2MNI_flowfield};
matlabbatch{1}.spm.util.defs.comp{2}.dartel.times = [1 0];
matlabbatch{1}.spm.util.defs.comp{2}.dartel.K = 6;
matlabbatch{1}.spm.util.defs.comp{2}.dartel.template = {DARTELtemplate6};
matlabbatch{1}.spm.util.defs.comp{3}.id.space = {ref};
matlabbatch{1}.spm.util.defs.out{1}.savedef.ofname = prefix;
matlabbatch{1}.spm.util.defs.out{1}.savedef.savedir.saveusr = {outpath};
spm_jobman('run', matlabbatch);