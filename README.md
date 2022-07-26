This repository contains codes for performing voxel-based morphometry analysis of longitudinal structural MRI data utilizing SPM

CYJ_SPMlongitudinal_VBM_normalPatients_main: for normal subjects
CYJ_SPMlongitudinal_VBM_patientsWithLesion: for patients with lesion masks

The longitudinal VBM processing included the following procedures: 
1) for each participant, an average image across the longitudinal images was generated using the Serial Longitudinal Registration toolbox; 
2) the participant-specific average images were bias-corrected and segmented into GM, WM, and cerebrospinal fluid probability maps. These tissue-segmented images were then registered to the template in the MNI space, resulting in a participant-specific GM probability map in MNI space; 
3) the GM probability maps were then modulated with two-fold Jacobian determinants: from the native space of each time point to the participant-average space and from the participant-average space to MNI space. For each participant, this resulted in a GMV map in MNI space for each time point, in which each voxel’s value represents its corresponding GMV in the native space. 
4) Finally, all of these GMV images were smoothed with an 8-mm full width half maximum Gaussian kernel. 

In all procedures, each participant’s stroke lesion had been masked out.
