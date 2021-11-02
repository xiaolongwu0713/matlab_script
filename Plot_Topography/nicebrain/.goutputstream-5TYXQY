Welcome to nicebrain

nicebrain takes raw MRI and CT images in DICOM format and produces brain models with electrodes on them.

Prerequistes for use:
Good CT and MRI scans in DICOM format
The proper subject directory layout (see below)
MATLAB
freesurfer (with freeview)
nicebrain folder on MATLAB path
spm8 on MATLAB path
freesurfer/matlab/ on MATLAB path

Proper subject directory layout:

SubjectDirectory
\_ DICOM
  \_ CT
  \_ MRI


To use nicebrain, start with the MATLAB function called nicebrain() located in this directory. The nicebrain() function will produce a segmentation of the brain, coregister the CT and MRI scans, and allow you to select the electrodes. 

Next, use the MATLAB function called plotusingmatlab() to take the output of the nicebrain() function and wrap it up into a data structure compatible with activateBrain.

Contact Nick with any questions:
nickcollisson@me.com
nickcollisson@gmail.com