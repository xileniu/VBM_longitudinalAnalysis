function CYJ_Image_assignMask_WithValue(image,mask,value,outpath,prefix,gz_ind)
if ~exist(outpath,'dir')
    mkdir(outpath);
end
system(['fslmaths ' mask ' -bin -mul ' num2str(value) ' ' outpath '/tmp']);
if gz_ind==1
    system(['fslmaths ' mask ' -bin -sub 1 -mul -1 -mul ' image ' -add ' outpath '/tmp ' outpath '/' prefix]);
elseif gz_ind==0
    system(['fslmaths ' mask ' -bin -sub 1 -mul -1 -mul ' image ' -add ' outpath '/tmp ' outpath '/' prefix ';gunzip -f ' outpath '/' prefix '.nii.gz']);
end
system(['rm -rf ' outpath '/tmp.nii.gz']);