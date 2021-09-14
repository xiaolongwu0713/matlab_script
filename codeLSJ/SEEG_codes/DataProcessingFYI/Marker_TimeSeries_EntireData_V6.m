function  Marker_TimeSeries_EntireData_V6(hn,sn,pn,CLASS,Fs,carind)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is used to reload the filtered data of the entire
% experiment to make classification. Data is then saved as mat file for
% further use.
% Column(electrode), the last column is feature label.
% hn is the number of movement mode hn=1,2
% sn is the number of series in each movement, sn=1,2,3
% TRIAL_NUM is the number of each motion
% each trial contains 5s rest and then 5s movements, Fs=1000 default
% written by liguangye (liguangye.hust@gmail.com) @2016.05.01 @SJTU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Updated @2016.05.04 by liguangye, use this function to load 3 classes data
%
% Data=zeros(TRIAL_NUM*CLASS_NUM*10000,)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Updataed @2016.09.10 by liguangye. update the format of input elements.
% CLASS shall be a number array.
% First check if the CLASS is a number array.
if length(CLASS)>5
    error('Length of the class arry over 5! Please reduce the length CLASS!');
end
if length(sn)>2
    error('Session num shall be <=2, update the function if it is greater than 2!');
end
classname='';
for i=1:length(CLASS)
    classname=strcat(classname,num2str(CLASS(i)));
end
%% Reload filtered Data
CLASS_NUM=length(CLASS);
sessionname='';
T=zeros(CLASS_NUM,1);
Wdata_T=[];

for l=hn
    hncase=num2str(l);
    for m=1:length(sn)
        sncase=num2str(sn(m));
        sessionname=strcat(sessionname,sncase);
         if carind==0
           dir_path=strcat('WITHOUTCAR\P',num2str(pn),'_H',hncase,'_',sncase,'_Marker_Selected');
        elseif carind==1
            dir_path=strcat('WITHCAR\P',num2str(pn),'_H',hncase,'_',sncase,'_Marker_Selected');
        elseif  carind==2
			dir_path=strcat('WITHCAR_CW_GROUPED\P',num2str(pn),'_H',hncase,'_',sncase,'_Marker_Selected');
        elseif carind==3
            dir_path=strcat('LOCALREF\P',num2str(pn),'_H',hncase,'_',sncase,'_Marker_Selected');
        elseif carind==4
            dir_path=strcat('WITHCAR_Median\P',num2str(pn),'_H',hncase,'_',sncase,'_Marker_Selected');
        elseif carind==5
            dir_path=strcat('WITHCAR_Chn_Spec\P',num2str(pn),'_H',hncase,'_',sncase,'_Marker_Selected');
        elseif carind==6
            dir_path=strcat('WITHCAR_Ele_Spec\P',num2str(pn),'_H',hncase,'_',sncase,'_Marker_Selected');
        elseif carind==7
            dir_path=strcat('BiPolar\P',num2str(pn),'_H',hncase,'_',sncase,'_Marker_Selected');
        else
            error('Wrong CAR index!!!');
        end
        load(dir_path);  
        Ndata=Data(:,1:end-2);
        fealabel=Data(:,end);
        clear Data;
        
        for n=1:CLASS_NUM
            k=CLASS(n);
            index=find(fealabel==k);
            TRIAL_NUM(n)=length(index);
            for dl=1:length(index)
                label=[zeros(2*Fs,1);n*ones(5*Fs,1);zeros(3*Fs,1)];
                tindex=index(dl);
                 Wdata=Ndata(tindex-Fs*2+1:tindex+Fs*8,:);               
                    for cc=1:size(Ndata,2)
                        if m==1
                          Wdata_T(:,(n-1)*(2*TRIAL_NUM(n))+dl,cc)=Wdata(:,cc);
                        else
                            Wdata_T(:,(n-1)*(2*TRIAL_NUM(n))+TRIAL_NUM(n)+dl,cc)=Wdata(:,cc);
                        end
                    end
            end
        end
        
    end
 

   datasetname=strcat('TSeries_P',num2str(pn),'_H',hncase,'_S12_C',...
            classname,'.mat');
 if carind==0
 save(['WITHOUTCAR\',datasetname],'Wdata_T','goodchs');
elseif carind==1
 save(['WITHCAR\',datasetname],'Wdata_T','goodchs');
elseif carind==2
 save(['WITHCAR_CW_GROUPED\',datasetname],'Wdata_T','goodchs');
 elseif carind==3
 save(['LOCALREF\',datasetname],'Wdata_T','goodchs');
 elseif carind==4
 save(['WITHCAR_Median\',datasetname],'Wdata_T','goodchs');
 elseif carind==5
 save(['WITHCAR_Chn_Spec\',datasetname],'Wdata_T','goodchs');
 elseif carind==6
 save(['WITHCAR_Ele_Spec\',datasetname],'Wdata_T','goodchs');
elseif carind==7
  save(['BiPolar\',datasetname],'Wdata_T','goodchs');  
else
end       
end