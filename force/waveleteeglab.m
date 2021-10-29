function T_Matrix=waveleteeglab(data,movetype)
% data=(:,[1:20,31:40],channel(j)) (time*trials)
w=1;fs=1000;
%[tf,freqs,times,itcvals]=timefreq(data_resized(:,[1:20,31:40],channel(j),3),Fs,'freqs',[0.5 150],'tlimits',[1000 15000],'winsize',1000);
[tf,freqs,times,itcvals]=timefreq(data,fs,'freqs',[0 150],'tlimits',[0 15000],'winsize',1000);

basel=27;
%  tf_all=tf_all+tf;
tf_all= tf; % (freq, time, trial);
baseval=[]; 
      for i=1:size(tf,3)
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

% P_Matrix_Ave=P_Matrix_Ave/size(T_matrix,3);
%%
if movetype==1
    trigger=[2,5,7.5];
elseif movetype==2
    trigger=[2,11,13.5];
elseif movetype==3
    trigger=[2,3,5.5];
elseif movetype==4
    trigger=[2,5,7.5];
end

figure
imagesc(times,freqs,T_matrix,[-3 2]);
hold on;plot([trigger(1)*1000,trigger(1)*1000],[0,200],'--w','LineWidth',3);
hold on;plot([trigger(2)*1000,trigger(2)*1000],[0,200],'--w','LineWidth',3);
hold on;plot([trigger(3)*1000,trigger(3)*1000],[0,200],'--w','LineWidth',3);
%colormap(jet);
shading interp
ax = gca;
%set(gca,'Ydir','normal','Yscale','log');
set(ax,'Ydir','normal');
colorbar;
xlabel('Time/ms','fontsize',12);
ylabel('Frequency/Hz','fontsize',12);
% title('Subject-Averaged CAR Signal Time Frequency T-test Value Map','fontsize',18);
% saveas(gcf,['./','t_f_3_',num2str(best_channel(j)),'.jpg'])
load('/Users/long/BCI/matlab_scripts/LSJ/MyColormaps.mat','mycmap')
colormap(ax,mycmap)
colorbar;
caxis([-1.5,4]);
print(gcf,['t_f_3_channel_',num2str(j)],'-r600','-dpng')

end
