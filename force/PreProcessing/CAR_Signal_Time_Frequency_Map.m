
Fs=1000;
T_matrix=[];
P_matrix=[];
tf_all=zeros(300,200,100);
Subject_list=2;
for w=1:length(Subject_list)
    
react_name=strcat('..\P',num2str(Subject_list(w)),'\Data_Process_Standard\2_Data_Alignment_Resize\WITHCAR\CAR_P',num2str(Subject_list(w)),'_H1_S12_C12345.mat');
load(react_name);
if Subject_list(w)==11 || Subject_list(w)==12
    Time_Data=resample(Time_Data,2,1);
end 
[tf,freqs,times,itcvals]=timefreq(Time_Data,Fs,'freqs',[0,150],'tlimits',[0 10*Fs],'winsize',1000);
 basel=10;
%  tf_all=tf_all+tf;

tf_all= tf;      

   baseval=[];
      for i=1:size(tf,3)
         baseval(:,:,i)=abs(tf_all(:,[1:basel,end-9:end],i));
      end
      t_data_trial=[];
      for a=1:length(freqs)
          for b=1:size(tf,2)    
              for c=1:size(tf,3)
                  t_data_trial(c)=abs(tf_all(a,b,c));
              end
              [H,P,C,STAT]=ttest2(t_data_trial',reshape(squeeze(baseval(a,:,:)),size(tf,3)*basel*2,1));
              T_matrix(a,b,w)=STAT.tstat;
              P_matrix(a,b,w)=P;
          end
      end
end
T_Matrix_Ave=zeros(size(T_matrix,1),size(T_matrix,2));
for t=1:size(T_matrix,3)
   T_Matrix_Ave=T_Matrix_Ave+T_matrix(:,:,t);
end
T_Matrix_Ave=T_Matrix_Ave/size(T_matrix,3);
% P_Matrix_Ave=P_Matrix_Ave/size(T_matrix,3);
%%
figure
imagesc(times,freqs,T_Matrix_Ave,[-3 2]);
colormap(jet);
shading interp
set(gca,'Ydir','normal');
colorbar;
xlabel('Time/ms','fontsize',16);
ylabel('Frequency/Hz','fontsize',16);
title('Subject-Averaged CAR Signal Time Frequency T-test Value Map','fontsize',18);

figure
[h, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(P_matrix);
imagesc(times,freqs,P_matrix,[0 0.05/(length(freqs)*length(times))]);
% imagesc(times,freqs,P_matrix,[0 crit_p]);
colormap(hot);
colorbar
shading interp
set(gca,'Ydir','normal');

%    datasetname=strcat('CAR_P',num2str(pn),'_H',hncase,'_S',sessionname,'_C',...
%             classname,'.mat');
%  save(['WITHCAR\',datasetname],'Time_Data','tf','times','freqs','T_matrix','P_matrix','crit_p');