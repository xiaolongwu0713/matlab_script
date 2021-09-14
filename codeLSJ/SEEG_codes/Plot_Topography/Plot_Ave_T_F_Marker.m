
%$ This script is used to plot the Time-Frequency Map averaged among all trials for each class
%$ By Li Guangye(liguangye.hust@gmail.com) @2017.04.12 @USA
%% plot the T-F
function Plot_Ave_T_F_Marker(CLASS_SER,Fs,CN,plot_type)
addpath('C:\Files\MATLAB\altmany-export_fig');
addpath('C:\Files\MATLAB\shadeerrorbar');
address=pwd;
MT=load(strcat(address(1:end-20),'\2_Data_Alignment_Resize\meantime_1'));
meandelay=MT.meantime;
MT=load(strcat(address(1:end-20),'\2_Data_Alignment_Resize\meantime_2'));
meandelay=(meandelay+MT.meantime)/2;

nLevel=2048/2;
Time=5;
tp=2;
L=Fs*Time;
t=(-tp*Fs+1)/Fs:1/Fs:(L+3)/(Fs);
f=linspace(0,Fs/2,nLevel/2);
CLASS_NUM=length(CLASS_SER);
rr=0;
if plot_type==0
    load('Time_Fre_Marker\TAspec_Marker');
for w=1:length(CN)
    
     C=CN(w);  
    
    for k=1:CLASS_NUM
       
            Tspec=TAspec{1,w}(:,:,k);
           
            subplot(5,CLASS_NUM,mod(w-1,5)*CLASS_NUM+k)
            imagesc(t,f,10*log10(Tspec));
            axis([min(t) max(t) 0 300]);
            set(gca,'Ydir','normal');
            c=get(gca,'CLim');
            set(gca, 'CLim', [min(c)*0.13 max(c)*0.3]);
            colormap jet;
            
              xlabel('Time/s');
              ylabel('Frqunecy/Hz');
              motionval=strcat('Motion\_',num2str(k),'\_C\_',num2str(CN(w)));
              title(motionval);           

            grid off;
            shading interp;
            set(gcf,'Color','white');
            
            hold on;
            plot([0,0],[0,300],'--m','Linewidth',2);
			hold on;
			plot([meandelay/Fs,meandelay/Fs],[0,300],'--g','Linewidth',2);
            hold on;
            if (mod(w,5)==0 || w==length(CN)) && k==CLASS_NUM
                 rr=rr+1;
                scrsz = get(0,'ScreenSize');
                set(gcf,'Position',scrsz);
                name=strcat('Time_Fre_Marker\Figure',num2str(rr),'.jpg');
                export_fig(name,'-m4','-painters');
                close();             
                clf;
            end

        end

end

else

load('PSD_Marker\PSD_Marker.mat');
RLENW=(tp-0.5)/0.25+1;
T=[20,20,20,20,20];
 rr=0;   
    for w=1:length(CN)
        w
        %plot the result
        for k=1:CLASS_NUM
            for j=1:LENW
              
                MEAN_1(j)=mean(cell_1{1,k}(1:T(k),CN(w),j));
                Std_1(j)=std(cell_1{1,k}(1:T(k),CN(w),j))/sqrt(length([1:T(k)])); % S.E
                MEAN_2(j)=mean(cell_2{1,k}(1:T(k),CN(w),j));
                Std_2(j)=std(cell_2{1,k}(1:T(k),CN(w),j))/sqrt(length([1:T(k)]));% S.E
                MEAN_3(j)=mean(cell_3{1,k}(1:T(k),CN(w),j));
                Std_3(j)=std(cell_3{1,k}(1:T(k),CN(w),j))/sqrt(length([1:T(k)]));%S.E
            end
            MEAN_1=MEAN_1-mean(MEAN_1);
            MEAN_2=MEAN_2-mean(MEAN_2);
            MEAN_3=MEAN_3-mean(MEAN_3);
%             MEAN_1=MEAN_1-repmat(mean(MEAN_1(1:RLENW)),1,LENW);
%             MEAN_2=MEAN_2-repmat(mean(MEAN_2(1:RLENW)),1,LENW);
%             MEAN_3=MEAN_3-repmat(mean(MEAN_3(1:RLENW)),1,LENW);
            subplot(5,CLASS_NUM,mod(w-1,5)*CLASS_NUM+k)
            
            XlabelV=linspace(-2,8,LENW);  
            shadedErrorBar(XlabelV,MEAN_1,Std_1,'b',1);
          
            motionval=strcat('M',num2str(k),'\_','Chn',num2str(CN(w)));
            title(motionval,'fontsize',6);
            
            c=get(gca,'YLim');
            axis([-2,8,min(c),max(c)]);
            
            set(gcf,'Color','white');
                       
            hold on;
            shadedErrorBar(XlabelV,MEAN_2,Std_2,'g',1);
            hold on;
            shadedErrorBar(XlabelV,MEAN_3,Std_3,'r',1);   
            
            hold on;
            plot([0,0],[min(c),max(c)],'--k','Linewidth',2);
			hold on;
            plot([meandelay/Fs,meandelay/Fs],[min(c),max(c)],'--m','Linewidth',2);           
            if (mod(w,5)==0 || w==length(CN)) && k==CLASS_NUM
                rr=rr+1;
                 saveas(gcf,strcat('PSD_Marker\Figure',num2str(rr),'_1.fig'));            
                 clf;

            end
            
        end
        
    end

end
end