function CYJ_SPM_thr_Image(in,threshold,outpath,prefix)
matlabbatch = {};
matlabbatch{1}.spm.util.imcalc.input = {in};
matlabbatch{1}.spm.util.imcalc.output = prefix;
matlabbatch{1}.spm.util.imcalc.outdir = {outpath};
matlabbatch{1}.spm.util.imcalc.expression = ['i1>' num2str(threshold)];
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = -7;
matlabbatch{1}.spm.util.imcalc.options.dtype = 16;
spm_jobman('run', matlabbatch);