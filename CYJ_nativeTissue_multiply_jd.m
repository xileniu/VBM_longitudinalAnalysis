function CYJ_nativeTissue_multiply_jd(native_tissue,jd,outpath,prefix)

matlabbatch{1}.spm.util.imcalc.input = {
    [native_tissue ',1']
    [jd ',1']
    };
matlabbatch{1}.spm.util.imcalc.output = prefix;
matlabbatch{1}.spm.util.imcalc.outdir = {outpath};
matlabbatch{1}.spm.util.imcalc.expression = 'i1.*i2';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 16;
spm_jobman('run', matlabbatch);
end