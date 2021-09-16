function [cortex] = fs2ctmr(subject)


%    This function selects the appropriate surface and loads it
%         bfile = 'rh.pial';
%         bfile = 'rh.orig';
%         bfile = 'rh.white';


% fs_dir = '/Applications/freesurfer/subjects/';
fs_dir = 'subjects/';
% fs_dir = '/Volumes/kjm_backup/toolbox/face/brains/';
% fs_dir = '/Volumes/kjm_backup/freesurfer_complete/subjects/'
% fs_dir = '/Users/kai/toolbox/ctmr/'

switch subject
    case 'ap'
%          bfile = 'lh.orig';
%         bfile = 'lh.white';
        bfile = 'lh.pial';
    case 'fp'
         bfile = 'lh.orig';
%         bfile = 'lh.white';
%         bfile = 'lh.pial';
    case 'MF'
%          bfile = 'rh.orig';
%         bfile = 'rh.white';
        bfile = 'rh.pial';
    case 'ca'
%         bfile = 'rh.pial';
        bfile = 'rh.orig'; % also very nice
%         bfile = 'rh.white';        
    case 'cc'
        bfile = 'rh.pial';
%         bfile = 'rh.orig';
%         bfile = 'rh.white';
    case 'lk'
        bfile = 'lh.pial';
%         bfile = 'lh.orig';
%         bfile = 'lh.white';
    case 'fp_a'
%         bfile = 'lh.pial';
%         bfile = 'lh.orig';
        bfile = 'lh.white';
    case 'jp'
%         bfile = 'lh.pial';
%         bfile = 'lh.orig';
        bfile = 'lh.white';
    case 'jc'
        bfile = 'lh.pial';
%         bfile = 'lh.orig';
%         bfile = 'lh.white';
    case 'wm'
        bfile = 'rh.pial';
%         bfile = 'rh.orig';
%         bfile = 'rh.white';
    case 'ht'
        bfile = 'lh.pial';
%         bfile = 'lh.orig';
%         bfile = 'lh.white';
    case 'apra11'
        bfile = 'lh.pial';
%         bfile = 'lh.orig';
%         bfile = 'lh.white';
    case 'wa'
        bfile = 'lh.orig';
%         bfile = 'lh.orig';
%         bfile = 'lh.white';
    case 'mv'
        bfile = 'lh.pial';
%         bfile = 'lh.orig';
%         bfile = 'lh.white';
    case 'wc'
        bfile = 'lh.pial';
%         bfile = 'lh.orig';
%         bfile = 'lh.white';

        
end

%% read data in 
    [cortex.vert,cortex.tri]=read_surf([fs_dir subject '/surf/' bfile]);    
    cortex.tri=cortex.tri+1; % freesurfer starts at 0 for indexing

%% transform into appropriate space for electrodes
    f=MRIread([fs_dir subject '/mri/orig.mgz']);

    for k=1:size(cortex.vert,1)
        a=f.vox2ras/f.tkrvox2ras*[cortex.vert(k,:) 1]';
        cortex.vert(k,:)=a(1:3)';
    end


