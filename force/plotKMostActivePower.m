function plotKMostActivePower(session, kchn,filteredEpoch)
num=size(kchn,2);
pnum=numSubplots(num); % subplot arrangement
for k=[1:num]
    subplot(pnum(1),pnum(2),k);
    trial=kchn{k}(1,2);
    chn=kchn{k}(1,1);
    [cfs,frq]=cwt(double(filteredEpoch(chn,:,trial)),1000,'FrequencyLimits',[8 30]);
    tms = (0:numel(filteredEpoch(chn,:,trial))-1)/1000; 
    %save(filename,'cwtplot')
    surface(tms,frq,abs(cfs));
    axis tight
    shading flat
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    set(gca,'yscale','log')
    hold on;
    [movement,x,y]=movementOfTrial(session,trial);
    X=[[x(1);x(1)],[x(2);x(2)],[x(3);x(3)]];
    Y=[[0;100],[0;100],[0;100]];
    ca=caxis;
    maxcolor=ca(2);
    plot3([x(1)-1,x(1)-1],[8,30],[maxcolor+1,maxcolor+1],'r--');
    hold on;
    plot3([x(2)-1,x(2)-1],[8,30],[maxcolor+1,maxcolor+1],'r--');
    hold on;
    plot3([x(3)-1,x(3)-1],[8,30],[maxcolor+1,maxcolor+1],'r--');
    titlestr=strcat('Trial:',num2str(trial),'. Move type:',num2str(movement));
    title(titlestr);
end

end