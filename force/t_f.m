function tfeeg(data,)
w=1;
fs=1000; % 20    21    22    24    60    63   109   110
% 8     9    10    18    19    21    22    23    24    69    70    86   106   107   108   109   110
channel=[8 9 10 18 19 20 21 22 23 24 62 63 69 70 105 107 108 109 110];
for j=1:19
    j
%[tf,freqs,times,itcvals]=timefreq(data_resized(:,[1:20,31:40],channel(j),3),Fs,'freqs',[0.5 150],'tlimits',[1000 15000],'winsize',1000);
[tf,freqs,times,itcvals]=timefreq(data(:,[1:20,31:40],channel(j)),fs,'freqs',[0 150],'tlimits',[0 15000],'winsize',1000);

basel=27;
%  tf_all=tf_all+tf;
tf_all= tf; % (freq, time, trial);
baseval=[]; 
      for i=1:size(tf,3) %size(tf,3)锟斤拷trial锟斤拷 2锟斤拷times 1锟斤拷frequency
         baseval(:,:,i)=abs(tf_all(:,(end-basel+1:end),i));
%            baseval(:,:,i)=abs(tf_all(:,(13:(12+basel)),i));
      end
      t_data_trial=[];
      for a=1:length(freqs)
          for b=1:size(tf,2)    
              for c=1:size(tf,3)
                  t_data_trial(c)=abs(tf_all(a,b,c));
              end
              [H,P,C,STAT]=ttest2(t_data_trial',reshape(squeeze(baseval(a,:,:)),size(tf,3)*basel,1));
              T_matrix(a,b,w)=STAT.tstat;
              P_matrix(a,b,w)=P;
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
xlabel('Time/ms','fontsize',12);
ylabel('Frequency/Hz','fontsize',12);
% title('Subject-Averaged CAR Signal Time Frequency T-test Value Map','fontsize',18);
% saveas(gcf,['./','t_f_3_',num2str(best_channel(j)),'.jpg'])
print(gcf,['t_f_3_channel_',num2str(j)],'-r600','-dpng')
end

end