function CYJ_SPMlongitudinal_VBM_normalPatients(T1s,T2s,subjIDs,timeNumber,TPM,DATREL_templates_1_6,masks_tobeBringBack,segment_flag)
%T1 T2 have to be the same folder,lesionmask don't
%all T1s,T2s,subjIDs,lesionmasks,timeNumber have to go with the max longitudinal, missing data use ''
% need to improve with without T2,and different segment

%%  delete empty
ind=find(~cellfun(@isempty,T1s));
T1s=T1s(ind);subjIDs=subjIDs(ind);timeNumber=timeNumber(ind);


%[~,lesionMnames,~]=cellfun(@(x) fileparts(x),lesionmasks,'UniformOutput',false);
[outpaths,T1names,~]=cellfun(@(x) fileparts(x),T1s,'UniformOutput',false);

%% longitudinal_registration
CYJ_SPMlongitudinal_registration(T1s,timeNumber);
%% bring lesionmask to avg
deformation2Avgs=cellfun(@(x,y) [x '/y_' y '.nii'],outpaths,T1names,'UniformOutput',false);
avgT1=[outpaths{1} '/avg_' T1names{1} '.nii'];

%%
if ~isempty(T2s)
    T2s=T2s(ind);
    % create T2 avg
    CYJ_SPMlongitudinal_createAvgT2(T1s,T2s,deformation2Avgs,avgT1,outpaths{1});
    avgT2=[outpaths{1} '/avgT2_avg_' T1names{1} '.nii'];
    % do segment
    if strcmp(segment_flag,'c')
        CYJ_VBM_segment_T1T2([outpaths{1} '/avg_' T1names{1} '.nii'],[outpaths{1} '/avgT2_avg_' T1names{1} '.nii'],TPM);
    elseif strcmp(segment_flag,'p')
    end
else
    % do segment
    if strcmp(segment_flag,'c')
        CYJ_VBM_segment_T1T2([outpaths{1} '/avg_' T1names{1} '.nii'],'',TPM);
    elseif strcmp(segment_flag,'p')
        CYJ_VBM_segment_T1_CAT12_7([outpaths{1} '/avg_' T1names{1} '.nii'],TPM,1.5,'eastern','dartel',DATREL_templates_1_6{1});
movefile([outpaths{1} '/mri/p1avg_' T1names{1} '.nii'],outpaths{1});
movefile([outpaths{1} '/mri/p2avg_' T1names{1} '.nii'],outpaths{1});
movefile([outpaths{1} '/mri/p3avg_' T1names{1} '.nii'],outpaths{1});
movefile([outpaths{1} '/mri/rp1avg_' T1names{1} '_rigid.nii'],outpaths{1});
movefile([outpaths{1} '/mri/rp2avg_' T1names{1} '_rigid.nii'],outpaths{1});
    end
end
%% do DARTEL
forDARTEL1=cell2mat(g_ls([outpaths{1} '/r' segment_flag '1avg_' T1names{1} '*.nii']));
forDARTEL2=cell2mat(g_ls([outpaths{1} '/r' segment_flag '2avg_' T1names{1} '*.nii']));
CYJ_dartel_existingTemplate(forDARTEL1,forDARTEL2,DATREL_templates_1_6);

%% c1 c2 c3 * jd
gray=[outpaths{1} '/' segment_flag '1avg_' T1names{1} '.nii'];
white=[outpaths{1} '/' segment_flag '2avg_' T1names{1} '.nii'];
csf=[outpaths{1} '/' segment_flag '3avg_' T1names{1} '.nii'];
jd2Avgs=cellfun(@(x,y) [x '/j_' y '.nii'],outpaths,T1names,'UniformOutput',false);
fun=@(x,y,z) CYJ_nativeTissue_multiply_jd(gray,x,y,['grayXjd_' z]);
cellfun(fun,jd2Avgs,outpaths,subjIDs);
fun=@(x,y,z) CYJ_nativeTissue_multiply_jd(white,x,y,['whiteXjd_' z]);
cellfun(fun,jd2Avgs,outpaths,subjIDs);
fun=@(x,y,z) CYJ_nativeTissue_multiply_jd(csf,x,y,['csfXjd_' z]);
cellfun(fun,jd2Avgs,outpaths,subjIDs);

%% normalise_to_MNI
flowfield=cell2mat(g_ls([outpaths{1} '/u_r' segment_flag '1avg_' T1names{1} '*.nii']));
fun=@(x) CYJ_dartel_normalise_to_MNI(flowfield,x,DATREL_templates_1_6{6},1,0);
grayXjds=cellfun(@(x,y) [x '/grayXjd_' y '.nii'],outpaths,subjIDs,'UniformOutput',false);
whiteXjds=cellfun(@(x,y) [x '/whiteXjd_' y '.nii'],outpaths,subjIDs,'UniformOutput',false);
csfXjds=cellfun(@(x,y) [x '/csfXjd_' y '.nii'],outpaths,subjIDs,'UniformOutput',false);
cellfun(fun,[grayXjds;whiteXjds;csfXjds]);

%% get the native2MNI deformation and bring lesionmask to MNI
fun=@(x,y,z) CYJ_longitudinal_estim_deformation_native2MNI(x,flowfield,[outpaths{1} '/mwgrayXjd_' subjIDs{1} '.nii'],DATREL_templates_1_6{6},y,['deformation_native2MNI_' z]);
cellfun(fun,deformation2Avgs,outpaths,subjIDs);
deformation2MNIs=cellfun(@(x,y) [x '/y_deformation_native2MNI_' y '.nii'],outpaths,subjIDs,'UniformOutput',false);
% fun=@(x,y,z) CYJ_SPM_native2MNI_using_DeformationNative2MNI(x,y,[outpaths{1} '/mwgrayXjd_' subjIDs{1} '.nii'],z,'lesionMInMNI',7,0);
% cellfun(fun,lesionmasks,deformation2MNIs,outpaths);
% lesionMInMNI=cellfun(@(x,y) [x '/lesionMInMNI_' y '.nii'],outpaths,lesionMnames,'UniformOutput',false);
% fun=@(x,y,z) CYJ_SPM_thr_Image(x,0.27,y,['lesionMInMNI_' z]);
% cellfun(fun,lesionMInMNI,outpaths,subjIDs);
% CYJ_deleteCells(lesionMInMNI);
% lesionMInMNI=cellfun(@(x,y) [x '/lesionMInMNI_' y '.nii'],outpaths,subjIDs,'UniformOutput',false);

%% mwc 
MNI_grayXjds=cellfun(@(x,y) [x '/mwgrayXjd_' y '.nii'],outpaths,subjIDs,'UniformOutput',false);
MNI_whiteXjds=cellfun(@(x,y) [x '/mwwhiteXjd_' y '.nii'],outpaths,subjIDs,'UniformOutput',false);
MNI_csfXjds=cellfun(@(x,y) [x '/mwcsfXjd_' y '.nii'],outpaths,subjIDs,'UniformOutput',false);

%% split hemi
fun=@(x,y,z) CYJ_splitHemi_all2rightside(x,60,1,y,['GMV_' z]);
cellfun(fun,MNI_grayXjds,outpaths,subjIDs);
fun=@(x,y,z) CYJ_splitHemi_all2rightside(x,60,1,y,['WMV_' z]);
cellfun(fun,MNI_whiteXjds,outpaths,subjIDs);
fun=@(x,y,z) CYJ_splitHemi_all2rightside(x,60,1,y,['CSF_' z]);
cellfun(fun,MNI_csfXjds,outpaths,subjIDs);

%%smooth
hemi_ind=[cellfun(@(x) 'LH',cell(length(outpaths),1),'UniformOutput',false);cellfun(@(x) 'RH',cell(length(outpaths),1),'UniformOutput',false)];
GMV=cellfun(@(x,y,z) [x '/GMV_' y '_' z '.nii'],[outpaths;outpaths],[subjIDs;subjIDs],hemi_ind,'UniformOutput',false);
WMV=cellfun(@(x,y,z) [x '/WMV_' y '_' z '.nii'],[outpaths;outpaths],[subjIDs;subjIDs],hemi_ind,'UniformOutput',false);
CSF=cellfun(@(x,y,z) [x '/CSF_' y '_' z '.nii'],[outpaths;outpaths],[subjIDs;subjIDs],hemi_ind,'UniformOutput',false);
fun=@(x) CYJ_SPM_smooth_nomask(x,8);
cellfun(fun,[GMV;WMV;CSF]);

%%bringback brainmask
for i=1:length(masks_tobeBringBack)
    fun=@(x,y,z,j) CYJ_SPM_MNI2native_using_DeformationNative2MNI(masks_tobeBringBack{i},x,y,z,[j '_bringBack_0.5'],0,0,1,0.5);
    cellfun(fun,deformation2MNIs,T1s,outpaths,subjIDs);
end
