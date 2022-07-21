function CYJ_splitHemi_all2rightside(brain,x_cutoff,is_02cutoff_RH,outpath,prefix)
% is_02cutoff_RH==0 wrong
if is_02cutoff_RH==1
    system(['fslmaths ' brain ' -roi 0 ' num2str(x_cutoff) ' 0 -1 0 -1 0 -1  ' outpath '/' prefix '_RH; gunzip -f ' outpath '/' prefix '_RH.nii.gz']);
    system(['fslswapdim ' brain ' -x y z ' outpath '/flip']);
    system(['fslmaths ' outpath '/flip -roi 0 ' num2str(x_cutoff) ' 0 -1 0 -1 0 -1  ' outpath '/' prefix '_LH; gunzip -f ' outpath '/' prefix '_LH.nii.gz']);
elseif is_02cutoff_RH==0
    system(['fslmaths ' brain ' -roi 0 ' num2str(x_cutoff) ' 0 -1 0 -1 0 -1  ' outpath '/' prefix '_LH; gunzip -f ' outpath '/' prefix '_RH.nii.gz']);
    system(['fslswapdim ' brain ' -x y z ' outpath '/flip']);
    system(['fslmaths ' outpath '/flip -roi 0 ' num2str(x_cutoff) ' 0 -1 0 -1 0 -1  ' outpath '/' prefix '_RH; gunzip -f ' outpath '/' prefix '_LH.nii.gz']);
end
system(['rm -rf ' outpath '/flip.nii.gz']);