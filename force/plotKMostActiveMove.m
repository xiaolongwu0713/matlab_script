function plotKMostActiveMove(move,frequencyBand, kchn)
% plotKMostActiveMove(move1,kchn);
global processed_data;
move=strcat('move',num2str(move));
num=size(kchn,2);
pnum=numSubplots(num); % subplot arrangement
if strcmp(frequencyBand,'high')
    bandf = [60 300];
    y=[60,300];
    filename=strcat(processed_data,'/SEEG_Data/',move,'_epochHighAmp.mat'); %move1_epochAmp.mat
elseif strcmp(frequencyBand,'low')
    bandf = [8 30];
    y=[8,30];
    filename=strcat(processed_data,'/SEEG_Data/',move,'_epochLowAmp.mat'); %move1_epochAmp.mat
end
load(filename); % data

if strcmp(move,'move1')
    %[movement,x,y]=movementOfTrial(1,1);
    x=[2,5,7.5];
elseif strcmp(move,'move2')
    x=[2,11,13.5];
elseif strcmp(move,'move3')
    x=[2,3,5.5];
elseif strcmp(move,'move4')
    x=[2,5,7.5];
end

for k=[1:num]
    subplot(pnum(1),pnum(2),k);
    trial=kchn{k}(1,2);
    chn=kchn{k}(1,1);
    [cfs,frq]=cwt(double(data(chn,:,trial)),1000,'FrequencyLimits',bandf);
    tms = (0:numel(data(chn,:,trial))-1)/1000; 
    %save(filename,'cwtplot')
    surface(tms,frq,abs(cfs));
    axis tight
    shading flat
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    set(gca,'yscale','log')
    hold on;
  
    ca=caxis;
    maxcolor=ca(2);
    plot3([x(1),x(1)],[y(1),y(2)],[maxcolor+1,maxcolor+1],'r--');
    hold on;
    plot3([x(2),x(2)],[y(1),y(2)],[maxcolor+1,maxcolor+1],'r--');
    hold on;
    plot3([x(3),x(3)],[y(1),y(2)],[maxcolor+1,maxcolor+1],'r--');
    titlestr=strcat('Trial:',num2str(trial),'. Move type:',move);
    title(titlestr);
end

end