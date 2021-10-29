function savecwtplot(session)
set(0,'DefaultFigureVisible','off');
global processed_data;
NumOctaves=10;
VoicesPerOctave=32;
fs=1000;
filename=strcat(processed_data,'SEEG_Data/PF6_F_',num2str(session),'_EPOCH.mat');
myepochs=load(filename);myepochs=myepochs.epoch;
trials=size(myepochs,3); % 41
channels=size(myepochs,1); % 109 channels
for trial = [1:trials]
    for channel=[1:channels]
        data=myepochs(channel,:,trial);
        [cfs,frq]=cwt(double(data),1000,'NumOctaves',NumOctaves,'VoicesPerOctave',VoicesPerOctave);
        tms = (0:numel(data)-1)/1000; 
        %save(filename,'cwtplot')
        surface(tms,frq,abs(cfs));
        axis tight
        shading flat
        xlabel('Time (s)')
        ylabel('Frequency (Hz)')
        set(gca,'yscale','log')
        title_str=strcat('session:',num2str(session),' trial:',num2str(trial),' channel:',num2str(channel));
        title(title_str)
        filename=strcat(processed_data,'cwt/plot/',num2str(session),'-',num2str(trial),'-',num2str(channel),'.jpg');
        saveas(gcf,filename)
        close all;
    end
end
%openfig('SineWave.fig')
set(0,'DefaultFigureVisible','on');
end
