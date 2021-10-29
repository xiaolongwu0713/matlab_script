%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CODE FOR SUBJECT 1  Taken using hospital software @2014.8.27 %
% BY LGY      @2016.01.18                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1 thumb
% 2 index
% 3 middle
% 4 ring
% 5 little
%%
clc
clear all
load('P2_H1_1.mat');
NDATA=Data;
clear Data;
%% ?
% chn=[1:14,17:22,24:26,28:30];%P1_H1_TRAIN 可用通道
% chn=[1:22,24:30];%P1_H2_TRAIN  P1_H1_M1 可用通道
chn=1:50;
%%
clc
clear all
Fs=1000;
% T=20; %Trial Num
Time=5;
CLASS_NUM=5;
% Data=zeros(Fs*Time*2*T*CLASS_NUM,AC);
% ntData=cell(1,3);

Ts=0.5;
slide_length=round(Fs*Ts/2);
Window_length=round(Ts*Fs);
DF=[8,30,60,185];%%Segment of frequency band
N=length(DF)/2;
pLEN=513; %length(psd);
segSEQ=round(DF*pLEN*2/Fs);
LENW=(5-Ts)*2/Ts+1;
nfft=1024;
CN=[12]; %可能通道
% CN=[1:50]; %可能通道
ARPSD_base=zeros(pLEN,1);
threeArray_1=zeros(pLEN,length(CN),2*LENW);
threeArray_2=zeros(N,length(CN),2*LENW);
T=[9,10,10,10,10];

threeArray_3=zeros(10,length(CN),2*LENW);
threeArray_4=zeros(10,length(CN),2*LENW);
threeArray_5=zeros(10,length(CN),2*LENW);
threeArray_6=zeros(10,length(CN),2*LENW);

cell_1=cell(1,CLASS_NUM);
cell_2=cell(1,CLASS_NUM);
cell_3=cell(1,CLASS_NUM);
cell_4=cell(1,CLASS_NUM);


%% PSD_Est

tic;
    for k=1:CLASS_NUM
 
        for i=1:T(k)
            if k==1
                value_motion=num2str(k);
                value_trial=num2str(i+1);
                %             testcase=num2str(v+1);
                name=strcat('Data_P2_WNF_H1_M1_CAR\Data_motion_',value_motion,'_',value_trial,'.mat');
            else
                value_motion=num2str(k);
                value_trial=num2str(i);
                %             testcase=num2str(v+1);
                name=strcat('Data_P2_WNF_H1_M1_CAR\Data_motion_',value_motion,'_',value_trial,'.mat');
            end
                
            Ndata=load(name);
            nData=Ndata.Ndata;
            nData1=nData(1:5*Fs,:);
            nData2=nData(5*Fs+1:end,:);
            for j=1:2*LENW
                if j==1
                basedata=nData1(1:Window_length,:);
                end
                if j>1 && j<=LENW
                basedata=nData1((j-1)*slide_length+1:(j-1)*slide_length+Window_length,:);
                end
                
                if j==LENW+1
                 basedata=nData2(1:Window_length,:);  
                end
                if j>LENW+1 && j<=2*LENW
                 basedata=nData2((j-LENW-1)*slide_length+1:(j-LENW-1)*slide_length+Window_length,:);
                end
                for m=1:length(CN)
                    ARPSD_base(:)=pburg(basedata(:,CN(m)),40,nfft,Fs);                
%                     if any(isinf(ARPSD_base))~=0
%                         ARPSD_base(isinf(ARPSD_base))=max(ARPSD_base(~isinf(ARPSD_base)));                   
%                     end
                    threeArray_1(:,m,j)=ARPSD_base;
                end
                for r=1:N                
                    threeArray_2(r,:,j)=mean(10*log10(threeArray_1(segSEQ(2*r-1):segSEQ(2*r),:,j)));
                end             
            end
            
            threeArray_3(i,:,:)=threeArray_2(1,:,:);%band1         
            threeArray_4(i,:,:)=threeArray_2(2,:,:);%band2
            threeArray_5(i,:,:)=threeArray_2(3,:,:);%band3
%             threeArray_6(i,:,:)=threeArray_2(4,:,:);%band4
        end
            cell_1{1,k}=threeArray_3;%BAND1
            cell_2{1,k}=threeArray_4;%BAND2    
            cell_3{1,k}=threeArray_5;%BAND3 
%             cell_4{1,k}=threeArray_6;%BAND2 
    end
    %%
 rr=0;   
    for w=1:length(CN)
        %plot the result
        for k=1:CLASS_NUM
            for j=1:2*LENW
                MEAN_1(j)=mean(cell_1{1,k}(1:T(k),w,j));
                Std_1(j)=std(cell_1{1,k}(1:T(k),w,j));
                MEAN_2(j)=mean(cell_2{1,k}(1:T(k),w,j));
                Std_2(j)=std(cell_2{1,k}(1:T(k),w,j));
                MEAN_3(j)=mean(cell_3{1,k}(1:T(k),w,j));
                Std_3(j)=std(cell_3{1,k}(1:T(k),w,j));
%                 MEAN_4(j)=mean(cell_4{1,k}(1:T(k),w,j));
%                 Std_4(j)=std(cell_4{1,k}(1:T(k),w,j));
            end
            
%             MEAN_1=MEAN_1-repmat(mean(MEANV),1,2*LENW);
%             MEAN_2=MEAN_2-repmat(mean(MEANV),1,2*LENW);
%             MEAN_3=MEAN_3-repmat(mean(MEANV),1,2*LENW);
%             MEAN_4=MEAN_4-repmat(mean(MEANV),1,2*LENW);
            MEAN_1=MEAN_1-repmat(mean(MEAN_1(1:LENW)),1,2*LENW);
            MEAN_2=MEAN_2-repmat(mean(MEAN_2(1:LENW)),1,2*LENW);
            MEAN_3=MEAN_3-repmat(mean(MEAN_3(1:LENW)),1,2*LENW);
%             MEAN_4=MEAN_4-repmat(mean(MEAN_4(1:LENW)),1,2*LENW);
            subplot(5,5,mod(w-1,5)*CLASS_NUM+k)
            shadedErrorBar(1:2*LENW,MEAN_1,Std_1,'b',1);
            
            xlabel('Time');
            ylabel('PSD (DB/Hz)');
            motionval=strcat('Motion',num2str(k),'\_','Channel',num2str(CN(w)));
            title(motionval);
                      
            set(gcf,'Color','white');
            
            hold on;
            shadedErrorBar(1:2*LENW,MEAN_2,Std_2,'r',1);
%             hold on;
%             
%             shadedErrorBar(1:2*LENW,MEAN_3,Std_3,'g',1);
            
%             hold on;
%             shadedErrorBar(1:2*LENW,MEAN_4,Std_4,'m',1);
            
             c=get(gca,'YLim');
              
             hold on;
             plot([LENW+0.5,LENW+0.5],[min(c),max(c)],'--k','Linewidth',2);
             
             
%             if (mod(w,5)==0 || w==length(CN)) && k==CLASS_NUM
%                 rr=rr+1;
%                 saveas(gcf,strcat('Figure',num2str(rr)),'fig');
%                 clf;
%                 %                 close Figure 1
%             end
            
        end
        
    end
    toc






