function exportCwtPlot(movetype)
set(0,'DefaultFigureVisible','off');
global processed_data;
movement=strcat('move',num2str(movetype));
if strcmp(movement,'move1')
    path='/Users/long/BCI/matlab_scripts/force/data/SEEG_Data/';
    filename=strcat(path,'move1.mat');
    tmp=load(filename);
    epoch=tmp.data;
elseif strcmp(movement,'move2')
    path='/Users/long/BCI/matlab_scripts/force/data/SEEG_Data/';
    filename=strcat(path,'move2.mat');
    tmp=load(filename);
    epoch=tmp.data;
elseif strcmp(movement,'move3')
    path='/Users/long/BCI/matlab_scripts/force/data/SEEG_Data/';
    filename=strcat(path,'move3.mat');
    tmp=load(filename);
    tmp=load(filename);
    epoch=tmp.data;
elseif strcmp(movement,'move4')
    path='/Users/long/BCI/matlab_scripts/force/data/SEEG_Data/';
    filename=strcat(path,'move4.mat');
    tmp=load(filename);
    epoch=tmp.data;
elseif strcmp(movement,'move100') % movement 61 data
    filename='/Users/long/BCI/matlab_scripts/force/data/SEEG_Data/move61.mat';
    tmp=load(filename);
    epoch=tmp.data;
end
clear tmp;
if strcmp(movement,'move1')
    %[movement,x,y]=movementOfTrial(1,1);
    x=[2,5,7.5];
elseif strcmp(movement,'move2')
    x=[2,11,13.5];
elseif strcmp(movement,'move3')
    x=[2,3,5.5];
elseif strcmp(movement,'move4')
    x=[2,5,7.5];
elseif strcmp(movement,'move100')
    x=[1,1,1];
end
y=[1,300];

chnNum=size(epoch,1);
trialNum=size(epoch,3);

NumOctaves=10;
VoicesPerOctave=32;

for chn=[1:chnNum]
    chn % tracking process
    for trial=[1:trialNum]
        subplot(5,8,trial);
        [cfs,frq]=cwt(double(epoch(chn,:,trial)),1000,'FrequencyLimits',[1 300]);
        tms = (0:numel(epoch(chn,:,trial))-1)/1000; 
        %save(filename,'cwtplot')
        surface(tms,frq,abs(cfs));
        axis tight
        shading flat
        set(gca,'yscale','log');
        
        ca=caxis;
        maxcolor=ca(2);
        hold on;
        plot3([x(1),x(1)],[y(1),y(2)],[maxcolor+1,maxcolor+1],'r--');
        hold on;
        plot3([x(2),x(2)],[y(1),y(2)],[maxcolor+1,maxcolor+1],'r--');
        hold on;
        plot3([x(3),x(3)],[y(1),y(2)],[maxcolor+1,maxcolor+1],'r--');
    end
        path='/Users/long/BCI/matlab_scripts/force/plots/test/';
        filename=strcat(path,movement,'_',num2str(chn),'.jpg');
        saveas(gcf,filename);
        clf('reset');
        close all;
end

%xlabel('Time (s)')
%ylabel('Frequency (Hz)')
set(0,'DefaultFigureVisible','on');
end