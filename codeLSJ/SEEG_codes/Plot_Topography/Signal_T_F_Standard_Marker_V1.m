function [AC]=Signal_T_F_Standard_Marker_V1(pn,CLASS_SER,session,Fs,Chn,type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CODE FOR SUBJECT 1  Taken using hospital software @2014.8.27 %
% BY LGY      @2017.04.12                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subjectnum=pn;
handtype=1;
sessionnum=session;
address=pwd;

Time=5; % General setting
CLASS_NUM=length(CLASS_SER);

L=Fs*Time;
T=[10,10,10,10,10];
value_motion=num2str(CLASS_SER(1));
value_trial=num2str(1);
if length(session)>=1
name=strcat(address(1:end-20),'\2_Data_Alignment_Resize\Data_P',num2str(subjectnum),'_H',num2str(handtype),'_',num2str(sessionnum(1)),'_PrePro_Marker\Data_motion_',value_motion,'_',value_trial,'.mat');
end
Ndata=load(name);
nData=Ndata.Ndata;
AC=size(nData,2)-2; % Tchn
if isempty(Chn)
    Chn=[1:AC];
end
CN=Chn;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
D=2;% -2s to 8s
tp=3;
TvalR=zeros(ceil(D)*Fs,AC);
nLevel=2048/2;
t=(-D*Fs+1)/Fs:1/Fs:(L+tp*Fs)/Fs;
f=linspace(0,Fs/2,nLevel/2);
Tspec=zeros(nLevel/2,L*2);
f0=6;

t1=1/Fs:1/Fs:(D*Fs)/Fs;
t2=1/Fs:1/Fs:(L+Fs*tp)/Fs;

ASpec=zeros(nLevel/2,L*2,CLASS_NUM);
TAspec=cell(1,length(CN));
tmpSpecR=zeros(nLevel/2,D*Fs);
tmpSpec=Tspec;
nData=zeros(L*2,AC);
rr=0;
Atm=cell(1,CLASS_NUM);
if type==1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for w=1:length(CN)
        
        C=CN(w);
        w
        C
        for k=1:CLASS_NUM
           
            
	      for ss=1:length(session)
		  
            for i=1:T(CLASS_SER(k))
                
                value_motion=num2str(CLASS_SER(k));
                value_trial=num2str(i);
				
                name=strcat(address(1:end-20),'\2_Data_Alignment_Resize\Data_P',num2str(subjectnum),'_H',num2str(handtype),'_',num2str(sessionnum(ss)),'_PrePro_Marker\Data_motion_',value_motion,'_',value_trial,'.mat');
                
                Ndata=load(name);
                nData=Ndata.Ndata;
                
                TvalR=nData(1:ceil(D)*Fs,1:AC);
                tmpSpecR=Scalo_pengzk(TvalR(1:D*Fs,C),t1,nLevel,f0,Fs); %
                Fmean=median(tmpSpecR(:,:),2);
                
                tmpSpec=Scalo_pengzk(nData(:,C),t2,nLevel,f0,Fs);
                tmpSpec=tmpSpec./repmat(Fmean,1,size(Spec,2));
                Spec(:,:,ss)=Spec(:,:,ss)+tmpSpec;%                             
               end
			   
			 ASpec(:,:,k)=ASpec(:,:,k)+Spec(:,:,ss);
		   
			end
			 
           ASpec(:,:,k)=ASpec(:,:,k)/(length(session)*T(k));	
            
        end
        TAspec{1,w}=ASpec;
    end
   if ~exist('Time_Fre_Marker', 'dir')
        mkdir('Time_Fre_Marker');
    end
    save('Time_Fre_Marker\TAspec_Marker.mat','TAspec');
    clear Data;

    
else
    %% PSD
    Ts=0.5;
    slide_length=round(Fs*Ts/2);
    Window_length=round(Ts*Fs);
    DF=[8,12,60,140];%%Segment of frequency band
    DF=[8,12,18,26,60,140];%%Segment of frequency band
    N=length(DF)/2;
    pLEN=513; %length(psd);
    segSEQ=round(DF*pLEN*2/Fs);
    LENW=(10-Ts)*2/Ts+1;
    nfft=1024;
    ARPSD_base=zeros(pLEN,1);
    threeArray_1=zeros(pLEN,length(CN),LENW);
    threeArray_2=zeros(N,length(CN),LENW);
    
    
    threeArray_3=zeros(10,length(CN),LENW);
    threeArray_4=zeros(10,length(CN),LENW);

    
    cell_1=cell(1,CLASS_NUM);
    cell_2=cell(1,CLASS_NUM);
    cell_3=cell(1,CLASS_NUM);
    if ~exist('PSD_Marker', 'dir')
        mkdir('PSD_Marker');
    end
    %% PSD_Est
    for k=1:CLASS_NUM
        k
		for ss=1:length(session)
         for i=1:T(CLASS_SER(k))
            value_motion=num2str(CLASS_SER(k));
            value_trial=num2str(i);
            name=strcat(address(1:end-20),'\2_Data_Alignment_Resize\Data_P',num2str(subjectnum),'_H',num2str(handtype),'_',num2str(sessionnum(ss)),'_PrePro_Marker\Data_motion_',value_motion,'_',value_trial,'.mat');%             end
            
            Ndata=load(name);
            nData=Ndata.Ndata;
            nData1=nData(:,1:AC);
            for j=1:LENW
                if j==1
                    basedata=nData1(1:Window_length,:);
                end
                if j>1 && j<=LENW
                    basedata=nData1((j-1)*slide_length+1:(j-1)*slide_length+Window_length,:);
                end
                
                for m=1:length(CN)
                    ARPSD_base(:)=pburg(basedata(:,CN(m)),40,nfft,Fs);
                    threeArray_1(:,m,j)=ARPSD_base;
                end
                for r=1:N
                    threeArray_2(r,:,j)=mean(10*log10(threeArray_1(segSEQ(2*r-1):segSEQ(2*r),:,j)));
                end
            end
			
            threeArray_3((ss-1)*T(CLASS_SER(k))+i,:,:)=threeArray_2(1,:,:);%band1
            threeArray_4((ss-1)*T(CLASS_SER(k))+i,:,:)=threeArray_2(2,:,:);%band2
            threeArray_5((ss-1)*T(CLASS_SER(k))+i,:,:)=threeArray_2(3,:,:);%band3
         end
		
		
        end
        for rr=1:N
        cell_1{1,k}=threeArray_3;%BAND1
        cell_2{1,k}=threeArray_4;%BAND2
        cell_3{1,k}=threeArray_5;%BAND3
    end
    save('PSD_Marker\PSD_Marker.mat','cell_1','cell_2','cell_3','LENW');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
end

end