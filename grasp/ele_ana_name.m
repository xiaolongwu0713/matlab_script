load('/Volumes/Samsung_T5/data/grasp_force/seegData/PF1/BrainElectrodes/electrodes_Final_Anatomy_wm.mat')
p1=elec_Info_Final_wm.ana_label_name;
fid = fopen('.txt','w');
for i=[1:102]
    fprintf(fid,'%s\n',p10{i})
end



