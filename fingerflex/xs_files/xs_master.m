function output=xs_master(subject)


%% to cycle through subjects


subjects = [...
    'aa';...
    'ap';...
    'ca';...
    'de';...
    'fp';...
    'gw';...
    'ha';...
    'hh';...
    'ja';...
    'jm';...
    'jt';...
    'mf';...
    'mv';...
    'rn';...
    'rr';...
    'wc';...
    'wh';...
    'zt';...
    ];


%% make file directories
for k=1:size(subjects,1)
   if exist(['brains/' subjects(k,:)])~=7, 
       mkdir(['brains/' subjects(k,:)]),
   end
end

%% defaults
% subject = 'aa'; % dummy for troubleshooting

% subject specific defaults
switch subject
    case 'aa' 
        clims=[24 60]; % color limits / scaling for MRI
    case 'ap' 
        clims=[150 400]; % color limits / scaling for MRI
    case 'ca' %%%
        clims=[80 125]; % color limits / scaling for MRI
    case 'de' %%%
        clims=[35 120]; % color limits / scaling for MRI
    case 'fp' %%%
        clims=[95 125]; % color limits / scaling for MRI
    case 'gw' %%%
        clims=[50 200]; % color limits / scaling for MRI
    case 'ha' %%%
        clims=[50 130]; % color limits / scaling for MRI
    case 'hh' %%%
        clims=[300 700]; % color limits / scaling for MRI
    case 'ja' %%%         
        clims=[.2 .75]; % color limits / scaling for MRI
    case 'jm' %%%
        clims=[330 650]; % color limits / scaling for MRI
    case 'jt' %%%
        clims=[35 125]; % color limits / scaling for MRI
    case 'mf' %%%
        clims=[225 575]; % color limits / scaling for MRI
    case 'mv' %%%      
        clims=[400 725]; % color limits / scaling for MRI
    case 'rn' %%%
        clims=[225 675]; % color limits / scaling for MRI
    case 'rr' %%%
        clims=[275 675]; % color limits / scaling for MRI
    case 'wc' %%%
        clims=[1000 2500]; % color limits / scaling for MRI
    case 'wh' %%%
        clims=[150 350]; % color limits / scaling for MRI
    case 'zt' %%%
        clims=[300 650]; % color limits / scaling for MRI        
end            

%% steps in co-registration, etc
% 1 - convert MRI into standardized coordinates - must be saved as xx_mri.nii - use SPM - co-register to T1.
% 2 - realign and reslice CT to MRI - must be saved as rxx_ct.nii (resliced) - use SPM - co-register and reslice into MRI from '1'
% 3 - identify color range for MRI - script below
% 4 - localize electrodes
% 5 - assign channel labels -- e.g. location electrode number index corresponds with data electrode number index
% 6 - segregate electrodes by anatomy
% 7 - display and export images by cross=section 

%% 1-2 - done for all
    spm

%% 3 - display intensity limits - done for all
    for k=1:size(subjects,1)
        xs_getclims(subjects(k,:))
    end

%% 4 - find electrode locations. can be done strip by strip and then built together - better if just use ctmr on realigned (not resliced) anatomy
%     [mlocs,slocs]=xs_loc(subject,clims);
    kjm_ctmr

%% 5 - assign channel labels
    locs=kjm_sortElectrodes;

%% 6 - segregate electrodes by anatomy
%     elcode=xs_anat(subject, locs, clims);
    elcode=xs_anat3d(subject, locs, clims);
    
    save(['locs/' subject '_xslocs'],'locs','elcode')

%% 7 - plot activity scaled
    xs_disp(subject, locs, clims) % electrode positions
    xs_weighted(subject, locs, clims, wts) % weighted activities    
    




















