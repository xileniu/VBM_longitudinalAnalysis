function CYJ_SPMlongitudinal_registration(T1s,timeNumber)
% subject and timeNumber have to be colume not row
ind=find(~cellfun(@isempty,T1s));
timeNumber1=timeNumber(ind);
subject1=cellfun(@(x) [x ',1'],T1s(ind),'UniformOutput',false);


matlabbatch{1}.spm.tools.longit.series.vols = subject1;
matlabbatch{1}.spm.tools.longit.series.times = timeNumber1';
matlabbatch{1}.spm.tools.longit.series.noise = NaN;
matlabbatch{1}.spm.tools.longit.series.wparam = [0 0 100 25 100];
matlabbatch{1}.spm.tools.longit.series.bparam = 1000000;
matlabbatch{1}.spm.tools.longit.series.write_avg = 1;
matlabbatch{1}.spm.tools.longit.series.write_jac = 1;
matlabbatch{1}.spm.tools.longit.series.write_div = 1;
matlabbatch{1}.spm.tools.longit.series.write_def = 1;

spm_jobman('run', matlabbatch);
