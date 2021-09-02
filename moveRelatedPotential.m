movetype=4;
movement=strcat('move',num2str(movetype));
data=load_data(99999,movement);
avg=mean(data,3);
N=4;
favg=bpfilter(avg',N,0.5,300,fs); 
favg=favg';
%figure();subplot(2,1,1);pspectrum(epoch(110,:,1));subplot(2,1,2);pspectrum(epochl(110,:,1));
tmp= abs(cubeHilbert(single(favg')));
power= tmp.^2; power=power';

baseline=[10000,11000];
basemean=mean(power(:,baseline(1):baseline(2)),2);
power_norm=power-basemean;

%plot(avg(101,:));hold on; plot(favg(101,:));hold on; plot(power_norm(101,:));

if movetype==1
    x0=2;
    x1=5;
    x2=7.5;
elseif movetype==2
    x0=2;
    x1=11;
    x2=13.5;
elseif movetype==3
    x0=2;
    x1=3;
    x2=5.5;
elseif movetype==4
    x0=2;
    x1=5;
    x2=7.5;
end
x0=x0*1000;x1=x1*1000;x2=x2*1000;
x=[[x0,x0];[x1,x1];[x2,x2]];
y=[[0,1000];[0,1000];[0,1000]];

set(0,'DefaultFigureVisible','off');
for i=[1:28]
    for j=[1:4]
        subplot(4,1,j);
        chann=(i-1)*4 + j
        plot(favg(chann,:));hold on;
        plot(x',y');
        ylabel(strcat('channel',+ num2str(chann)));
        titlee=strcat(movement,'_',num2str(i),'_',+num2str(chann));
        %title(titlee);
    end
    filename=strcat(movement,'/',movement,'_',num2str(i));
    path='/Users/long/BCI/matlab_scripts/force/plots/moveRelatePotential/';
    filename=strcat(path,filename,'.jpg');
    saveas(gcf,filename);
    clf('reset');
    close all;
end
set(0,'DefaultFigureVisible','on');        
