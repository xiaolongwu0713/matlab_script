function [movement,x,y]=movementOfTrial(session,trial)
global processed_data;
filename=strcat(processed_data,'SEEG_Data/','PF6_F_',num2str(session),'_Info','.mat');
tmp=load(filename); % load Info
Info=tmp.Info;
movements=Info.movement;
movement=movements(trial);
x=Info.xaxis{trial};
x=x(2:4);
y=Info.yaxis{trial};
y=y(2:4);
end

