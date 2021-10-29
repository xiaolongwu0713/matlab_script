function plotActiveChannel(data,movetype)
% plotActiveChannels(data,2). data:2D(time*trials). Plot 40 f-t amplitude for channle 2.

trials=size(data,2);
bandf=[1,300];
tms=[0:size(data,1)-1]/1000;
pnum=numSubplots(trials); 
if movetype==1
    %[movement,x,y]=movementOfTrial(1,1);
    x=[2,5,7.5];
elseif movetype==2
    x=[2,11,13.5];
elseif movetype==3
    x=[2,3,5.5];
elseif movetype==4
    x=[2,5,7.5];
end
y=bandf;
for trial=[1:trials]
    subplot(pnum(1),pnum(2),trial);
    [cfs,frq]=cwt(double(data(:,trial)),1000,'FrequencyLimits',bandf);
    surface(squeeze(tms),squeeze(frq),abs(cfs));
    axis tight
    shading flat
    %xlabel('Time (s)')
    %ylabel('Frequency (Hz)')
    set(gca,'yscale','log')
    hold on;
  
    ca=caxis;
    maxcolor=ca(2);
    plot3([x(1),x(1)],[y(1),y(2)],[maxcolor+1,maxcolor+1],'r--');
    hold on;
    plot3([x(2),x(2)],[y(1),y(2)],[maxcolor+1,maxcolor+1],'r--');
    hold on;
    plot3([x(3),x(3)],[y(1),y(2)],[maxcolor+1,maxcolor+1],'r--');
    %titlestr=strcat('Trial:',num2str(trial),'. Move type:',movetype);
    %title(titlestr);
end

end