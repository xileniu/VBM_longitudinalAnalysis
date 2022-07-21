function CYJ_SPMlongitudinal_createAvgT2(T1s,T2s,deformation2Avgs,avgT1,outpath)
% T1 T2 have to be nii not nii.gz
% T1s,T2s,deformation2Avgs can not have empty
tmp_output=[outpath '/tmp' num2str(floor(rand(1)*10000))];
[~,T2names,~]=cellfun(@(x) fileparts(x),T2s,'UniformOutput',false);
CYJ_copycells(T2s,tmp_output);
T2s_2=cellfun(@(x) [tmp_output '/' x '.nii'],T2names,'UniformOutput',false);
for i=1:length(T1s)
    matlabbatch={};
    matlabbatch{1}.spm.spatial.coreg.estimate.ref = {[T1s{i} ',1']};
    matlabbatch{1}.spm.spatial.coreg.estimate.source = {[T2s_2{i} ',1']};
    matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    spm_jobman('run', matlabbatch);
    matlabbatch={};
    matlabbatch{1}.spm.util.defs.comp{1}.def = {deformation2Avgs{i}};
    matlabbatch{1}.spm.util.defs.comp{2}.id.space = {avgT1};
    matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {T2s_2{i}};
    matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.saveusr = {tmp_output};
    matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 7;
    matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
    matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
    matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = 'T2inAvgSpace_';
    spm_jobman('run', matlabbatch);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T2inAvgSpace=g_ls([tmp_output '/T2inAvgSpace*']);
[~,avgT1name,~]=fileparts(avgT1);
avg_T2name = ['avgT2_' avgT1name];

T2inAvgSpace_2=cellfun(@(x) [' -add ' x],T2inAvgSpace(2:end),'UniformOutput',false);
system(['fslmaths ' T2inAvgSpace{1} strjoin(T2inAvgSpace_2,' ') ' -div ' num2str(length(T2inAvgSpace)) ' ' outpath '/' avg_T2name ';gunzip ' outpath '/' avg_T2name '.nii.gz']);

system(['rm -rf ' tmp_output]);




