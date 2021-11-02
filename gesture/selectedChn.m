pn=10;
%[143, 144, 146, 147, 148, 149, 150, 151, 152, 167]
load('/Volumes/Samsung_T5/data/gesture/preprocessing/P10/preprocessing2.mat');
data=[Datacell{1,1}' Datacell{1,2}'];
selected=[143, 144, 146, 147, 148, 149, 150, 151, 152, 167]+1;
data(144,1:10)

load('/Volumes/Samsung_T5/data/gesture/EleCTX_Files/P10/electrodes_Final_Norm.mat')
ele_name=elec_Info_Final_wm.name; % 208
subInfo = config_gesture(pn);
ele_name(selected)
