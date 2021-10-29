function show_electrodes()
%%�����Ե缫
addpath(genpath([cd,'/force/nicebrain']));
Electrode_Folder=[cd,'/force/PF6_SYF_2018_08_09_Simply/BrainElectrodes/electrodes_Final_Anatomy_wm.mat']; 
Brain_Model_Folder=[cd,'/force/PF6_SYF_2018_08_09_Simply/BrainElectrodes/WholeCortex.mat'];
load(Electrode_Folder);
load(Brain_Model_Folder);
%
Etala.electrodes=cell2mat(elec_Info_Final_wm.pos');
global val
% val=get(hObject,'value');
switch val
    case 1
        viewBrain(cortex, Etala, {'brain','electrodes'}, 0.1, 50, 'front');
    case 2
        viewBrain(cortex, Etala, {'brain','electrodes'}, 0.1, 50,'top');
    case 3
        viewBrain(cortex, Etala, {'brain','electrodes'}, 0.1, 50,'lateral');
    case 4
        viewBrain(cortex, Etala, {'brain','electrodes'}, 0.1, 50, 'isometric');
    case 5
        viewBrain(cortex, Etala, {'brain','electrodes'}, 0.1, 50, 'right');
    case 6
        viewBrain(cortex, Etala, {'brain','electrodes'}, 0.1, 50, 'left');
end
axis off;
colorbar off
end
