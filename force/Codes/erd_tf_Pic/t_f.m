% for i=1:110
%     figure('visible','off');
%     figure;
% %     spectrogram(first_trial(i,:)',256,120,256,2e3,'yaxis');
% %     set(gca, 'ylim', [0, 150/1000])
%     [b,f,t]=specgram(ans,512,2000,512,384);
%     imagesc(t,f,20*log10(abs(b))), axis xy, colormap(jet); % 画时频图
%     set(gca, 'ylim', [0, 150])
%     saveas(gcf,['./','t_f_decomposition_',num2str(i),'.jpg'])
% end

w=1;
Fs=2000;
channel=[8 9 10 18 19 20 21 22 23 24 62 63 69 70 105 107 108 109 110];
for j=1:19
[tf,freqs,times,itcvals]=timefreq(data_resized(:,[1:20,31:40],channel(j),3),Fs,'freqs',[0.5 150],'tlimits',[1000 15000],'winsize',1000);
 basel=27;
%  tf_all=tf_all+tf;
tf_all= tf; 
baseval=[]; 
      for i=1:size(tf,3) %size(tf,3)为trial数 2为times 1为frequency
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