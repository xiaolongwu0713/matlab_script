% 'AMC069' 'AMC070' 'AMC071' 'AMC074' 'AMC077'
% 'AMC079' 'AMC081' 'AMC082' 'AMC083' 'AMC085'
% 'AMC086' 'AMC087' 
% CCEP&aud [3,6,8:12]

clc,clear;close all
patient_AudvsStim = [1 2 4 5 6 7];
for i = 1:6 
    [CMP, runvars] = main_audCMPstim(patient_AudvsStim(i));
    %savename_ccep{i,1} = runvars.savename_ccep; 
end

% alpha vs gamma
clc,clear;close all
for pt_ID = 5%[1,2,4,5]
    [CMP, runvars] = main_audCMPstim(pt_ID);
    %savename_ccep{i,1} = runvars.savename_ccep; 
end

%% AudvsStim sensitivity & specificity
clc,clear;close all
patient_AudvsStim = [1 2 4 5 6 7];
for i = 1:6 
    [CMP, runvars] = main_audCMPstim(patient_AudvsStim(i));
    aud_act     = runvars.aud_chans_act;
    ccep_act    = runvars.ccep_chans_act;
    aud_silent  = setdiff(runvars.chans_gd,aud_act);
    ccep_silent = setdiff(runvars.chans_gd,ccep_act);
    TP(i) = length(intersect(ccep_act,aud_act))/length(aud_act)*100;
    TN(i) = length(intersect(ccep_silent,aud_silent))/length(aud_silent)*100;
end

% show all 
figure('color',[1 1 1]); hold on;
for i=1:6
    bar(i-0.15,TP(i),0.25,'facecolor',[0.8 0.8 0.8],'edgecolor','k','linewidth',1)
    bar(i+0.15,TN(i),0.25,'facecolor',[0.4 0.4 0.4],'edgecolor','k','linewidth',1)
end
% show average
bar(i+1.5-0.15,mean(TP),0.25,'facecolor',[0.8 0.8 0.8],'edgecolor','k','linewidth',1)
bar(i+1.5+0.15,mean(TN),0.25,'facecolor',[0.4 0.4 0.4],'edgecolor','k','linewidth',1)
errorbar(i+1.5-0.15,mean(TP),std(TP)/length(TP),'linewidth',3,'color','k')
errorbar(i+1.5+0.15,mean(TN),std(TN)/length(TP),'linewidth',3,'color','k')
xlim([0.5 6+1.8])
ylim([0 100])
% labels
%ylabel('Percentage (%)');
set(gca,'xtick',[],'yticklabel',[],'fontsize',18); 
saveas(gcf,[CMP.figpath '/anatomic/global_AudvsStim_bar'],'epsc');

% show single 
figure('color',[1 1 1]); hold on;
for i=1
    bar(i-0.15,TP(i),0.25,'facecolor',[0.8 0.8 0.8],'edgecolor','k','linewidth',1)
    bar(i+0.15,TN(i),0.25,'facecolor',[0.4 0.4 0.4],'edgecolor','k','linewidth',1)
end
ylim([0 100])
xlim([0 2])
% labels
%ylabel('Percentage (%)');
set(gca,'xtick',[],'yticklabel',[],'fontsize',18); 
saveas(gcf,[CMP.figpath '/anatomic/global_AudvsStim_bar_sub1'],'epsc');


%% AudvsStim global scatter
clc,clear;close all
patient_AudvsStim = [1 2 4 5 6 7];
ecol  = brewermap(6,'Dark2'); % brewermap('plot')
fcol  = {[.5 .5 .5],'none',[.5 .5 .5],'none',[.5 .5 .5],'none',[.5 .5 .5],'none'};
X = [];Y = [];x_fit=[];y_fit=[];y_con=[];DELTA=[];
for i = 1:6
    [CMP, runvars] = main_audCMPstim(patient_AudvsStim(i));
    x = runvars.aud_cor_scatter(runvars.union_chans_act);
    y = runvars.ccep_gmm_scatter(runvars.union_chans_act);
    X = [X; x];
    Y = [Y; y];
    aud_cor_scatter{i}  = x;
    ccep_gmm_scatter{i} = y;
    [par_p, par_S] = polyfit(x,y,1);
    x_fit{i}       = linspace(min(x),max(y));
    [y_con{i}, DELTA{i}] = polyconf_x(par_p,x_fit{i},par_S);
    [r(i),p(i)] = corr(x,y,'type','pearson');
end
[par_p, par_S] = polyfit(X,Y,1);
x_fit{i+1}     = linspace(min(X),max(Y));
[y_con{i+1}, DELTA{i+1}] = polyconf_x(par_p,x_fit{i+1},par_S);
[r(i+1),p(i+1)] = corr(X,Y,'type','pearson');

% plot the summary figure
figure('color',[1 1 1],'position',[10 10 1000 600]); hold on;
k = 1;
for i=1:6
    h1(i) = plot(aud_cor_scatter{i},ccep_gmm_scatter{i},'o','MarkerSize',10,...
    'MarkerEdgeColor','none','MarkerFaceColor',ecol(i,:));hold on;
end
k = 1;
for i = 1:6
    h2(i) = plot(x_fit{i}, y_con{i},'color',ecol(i,:),'linewidth',3);
end
h2(i+1) = plot(x_fit{i+1}, y_con{i+1},'color','k','linewidth',4,'linestyle','--');
xlim([-2 6]);ylim([-2 8])
for i = 1:7
    p0 = p(i);
    if p0<0.001; plabel = '; p<0.001'; p0 = 10; end
    if p0<0.01;  plabel = '; p<0.01';  p0 = 10; end
    if p0<0.05;  plabel = '; p<0.05';  p0 = 10; end
    if p0~=10; plabel = ['; p=' num2str(round(p0*100)/100)];end   
    ltext{i} = ['Sub' num2str(i) ': r=' num2str(round(r(i)*100)/100) plabel];
end
set(gca,'fontsize',35);  
legend(h1,ltext(1:6),'location','northeastoutside');
saveas(gcf,[CMP.figpath '/anatomic/global_AudvsStim_scatter_a'],'epsc');
legend(h2,ltext,'location','northeastoutside');
saveas(gcf,[CMP.figpath '/anatomic/global_AudvsStim_scatter__b'],'epsc');

% single figure
figure('color',[1 1 1],'position',[10 10 600 400]); hold on;
plot(aud_cor_scatter{1},ccep_gmm_scatter{1},'o','MarkerSize',10,...
'MarkerEdgeColor','none','MarkerFaceColor','k');hold on;
h2(i) = plot(x_fit{1}, y_con{1},'color','k','linewidth',3);
set(gca,'fontsize',20)
xlim([-2 6]);ylim([-2 8])
saveas(gcf,[CMP.figpath '/anatomic/global_AudvsStim_scatter_sub1'],'epsc');

%% AudvsStim raw data
clc,clear;close all
% plot_AudvsStim_topography == true
[CMP, runvars] = main_audCMPstim(1);

chans = [13,96,99]; % AMC071
load([CMP.dtpath '/process_data/' runvars.savename_aud '_process.mat'],'par_process','signal_gmm');
aud_par_process = par_process;
aud_gmm = signal_gmm(:,chans);
aud_gmm = abs(hilbert(aud_gmm));
for i=1:size(aud_gmm,2)
    aud_gmm(:,i) = smooth(aud_gmm(:,i),100);
end
load([CMP.dtpath '/process_data/' runvars.savename_ccep '_process.mat'],'par_process','signal_gmm');
ccep_par_process = par_process;
ccep_gmm = signal_gmm(:,chans);
ccep_gmm = abs(hilbert(ccep_gmm));
for i=1:size(ccep_gmm,2)
    ccep_gmm(:,i) = smooth(ccep_gmm(:,i),50);
end

% aud figure
nums   = [20 27];
locs   = aud_par_process.stimlocs(nums(1):nums(2));
fs     = aud_par_process.fs;
rng_pt = locs(1)-1*fs : locs(end)+2*fs;
rng_t  = (0:length(rng_pt)-1)./fs;
dat    = aud_gmm(rng_pt,:);
figure; hold on;
for i=1:3
    plot(downsample(rng_t,100), downsample(dat(:,i)+i*10,100));
end
ylim([10 40])
for i=1:length(locs)
    plot([1 1].*rng_t(rng_pt==locs(i)),[10 35]);
    text(rng_t(rng_pt==locs(i)),20,aud_par_process.stimtype{nums(1)+i-1});
end
saveas(gcf,[CMP.figpath '/anatomic/aud_raw'],'epsc');

% ccep figure
nums   = [125 130];
locs   = ccep_par_process.stimlocs(nums(1):nums(2));
fs     = ccep_par_process.fs;
rng_pt = locs(1)-0.3*fs : locs(end)+0.3*fs;
rng_t  = (0:length(rng_pt)-1)./fs;
dat    = ccep_gmm(rng_pt,:);
figure; hold on;
for i=2:3
    plot(downsample(rng_t,50), downsample(dat(:,i)+i*10,50));
end
ylim([10 40])
for i=1:length(locs)
    plot([1 1].*rng_t(rng_pt==locs(i)),[20 45]);
    %text(rng_t(rng_pt==locs(i)),20,num2str(i));
end
saveas(gcf,[CMP.figpath '/anatomic/ccep_raw'],'epsc');

%% AlphavsGamma: stimulation data
% clc,clear;
% rlts = plot_stimdata_modulate_topography();
% save('stimdata_modulate_rlts.mat','rlts');
% load('stimdata_modulate_rlts.mat','rlts');

% baseline vs task~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mtype = {'ev','ins','phase','amp'}; 
atype = {'act','non'};
ptall_indx = [3,6,8:12];
for pt = 1:length(ptall_indx)
    figure('position',[1500 10 4*200 3*200]);k=1;
    for a = 1:2
        for m = 1:4
            subplot(2,4,k);hold on; k=k+1;
            mr = [];
            eval(['chinfo = rlts.ch' atype{a} 'info;']);
            locs = find(cell2mat(chinfo(:,2))==ptall_indx(pt));
            eval(['blval = rlts.rall' mtype{m} atype{a} '_bl(locs);'])
            eval(['tkval = rlts.rall' mtype{m} atype{a} '_tk(locs);'])
            % compare distribution
            x = -0.5:0.01:0.5;
            h1 = bar(x,histc(blval,x),'FaceColor','b','EdgeColor','none','FaceAlpha',.5); 
            h2 = bar(x,histc(tkval,x),'FaceColor','r','EdgeColor','none','FaceAlpha',.5); 
            [~,p0]=ttest2(blval, tkval);
            title({[mtype{m} ' ' atype{a} '_bl: ' num2str(mean(blval))],...
                   [mtype{m} ' ' atype{a} '_tk: ' num2str(mean(tkval))],...
                   [chinfo{locs(1),1}(1:6) ': p=' num2str(p0)]},'interpreter','none')
            xlabel('pearson r value');
            ylabel('electrodes number')
            set(gca,'fontsize',14)
        end
    end
    saveas(gcf,['results 2020-03-25/alpha_vs_gamma/bltk_' num2str(pt)],'png');
end

figure('position',[1500 10 4*200 3*200]);k=1;
for a = 1:2
    for m = 1:4
        subplot(2,4,k);hold on; k=k+1;
        mr = [];
        eval(['chinfo = rlts.ch' atype{a} 'info;']);
        eval(['blval = rlts.rall' mtype{m} atype{a} '_bl;'])
        eval(['tkval = rlts.rall' mtype{m} atype{a} '_tk;'])
        % compare distribution
        x = -0.5:0.01:0.5;
        h1 = bar(x,histc(blval,x),'FaceColor','b','EdgeColor','none','FaceAlpha',.5); 
        h2 = bar(x,histc(tkval,x),'FaceColor','r','EdgeColor','none','FaceAlpha',.5); 
        [~,p0]=ttest2(blval, tkval);
        title({[mtype{m} ' ' atype{a} '_bl: ' num2str(mean(blval))],...
               [mtype{m} ' ' atype{a} '_tk: ' num2str(mean(tkval))],...
               ['ALL: p=' num2str(p0)]},'interpreter','none')
        xlabel('pearson r value');
        ylabel('electrodes number')
        set(gca,'fontsize',14)
    end
end
saveas(gcf,['results 2020-03-25/alpha_vs_gamma/bltk_all'],'png');


for a = 1:2
    for m = 2%:2
        eval(['blval = rlts.rall' mtype{m} atype{a} '_bl;'])
        eval(['tkval = rlts.rall' mtype{m} atype{a} '_tk;'])
        % compare distribution
        figure; hold on;
        x = -0.5:0.01:0.5;
        h1 = bar(x,histc(blval,x),'FaceColor','b','EdgeColor','none','FaceAlpha',.5); 
        h2 = bar(x,histc(tkval,x),'FaceColor','r','EdgeColor','none','FaceAlpha',.5); 
        legend([h1,h2],{'bl','tk'})
        [~,p0]=ttest2(blval, tkval);
        title({['rall ' mtype{m} ' ' atype{a} '_bl: mean=' num2str(mean(blval))],...
               ['rall ' mtype{m} ' ' atype{a} '_tk: mean=' num2str(mean(tkval))],...
               ['p=' num2str(p0)]},'interpreter','none')
        xlabel('pearson r value');
        ylabel('electrodes number')
        set(gca,'fontsize',14)
        
    end
end

% % difference distribution
% figure; hold on;
% x = -0.5:0.01:0.5;
% h1 = bar(x,histc(tkval-blval,x),'FaceColor','k','EdgeColor','none','FaceAlpha',.5); 
% legend(h1,{'tk-bl'})
% [~,p0]=ttest(tkval-blval);
% title({['rall ' mtype{m} ' tk-bl: mean=' num2str(mean(tkval-blval))],...
%        ['p=' num2str(p0)]},'interpreter','none')
% xlabel('pearson r value of tk-bl');
% ylabel('electrodes number')
% set(gca,'fontsize',14)

%% rest~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mtype      = {'ev','ins','phase','amp'}; 
atype      = {'act','non'};
cols       = brewermap(11,'RdYlBu'); %brewermap_view
cols       = cols(end:-1:1,:);
ptall_indx = [3,6,8:12];
mrall      = [];
close all;
for pt = 1:length(ptall_indx)
    figure('position',[1500 10 4*200 3*200]);k=1;
    for a = 1:2
        for m = 1:4
            subplot(2,4,k);hold on; k=k+1;
            mr = [];
            eval(['chinfo = rlts.ch' atype{a} 'info;']);
            locs = find(cell2mat(chinfo(:,2))==ptall_indx(pt));
            for i=1:10
                eval(['tmp = rlts.rall' mtype{m} atype{a} '_trlrest(locs,(i-1)*20+1:i*20);'])
                tmp = tmp(:);tmp(isnan(tmp))=[];
                mr(i) = mean(tmp);
            end
            mrall(pt,a,m,:) = mr;
            bar(1:10,mr,'facecolor','k','edgecolor','none');xlim([0 11])
            xlabel('Time Period');ylabel('mean r value');
            title([chinfo{locs(1),1}(1:6) '_' mtype{m} '_' atype{a}],'interpreter','none');
        end
    end
    saveas(gcf,['results 2020-03-25/alpha_vs_gamma/trlrestbar_' num2str(pt)],'png');
end

close all;
figure('position',[1500 10 4*200 3*200]);k=1;
for a = 1:2
    for m = 1:4
        subplot(2,4,k);hold on; k=k+1;
        mr = [];
        eval(['chinfo = rlts.ch' atype{a} 'info;']);
        for i=1:10
            eval(['tmp = rlts.rall' mtype{m} atype{a} '_trlrest(:,(i-1)*20+1:i*20);'])
            tmp = tmp(:);tmp(isnan(tmp))=[];
            mr(i) = mean(tmp);
            rall{i} = tmp;
        end
        bar(1:10,mr,'facecolor','b','edgecolor','none');xlim([0 11])
        if m==1;ylim([0 0.02]);else;ylim([-0.035 0]);end
        for i = 1:10
            for j = i:10
                [~,p] = ttest2(rall{i},rall{j});
                if p<0.05
                    plot([i j], [1 1].*max(mean(rall{i}), mean(rall{j}))-0.003,'k');
                end
            end
        end 
        xlabel('Time Period');ylabel('mean r value');
        title(['ALLSUB_' mtype{m} '_' atype{a}],'interpreter','none');
    end
end

[h,p] = ttest2(rall{3},rall{10})

figure;
histogram(rall{2})

figure('position',[1500 10 4*200 3*200]);k=1;
for a = 1:2
    for m = 1:4
        subplot(2,4,k);hold on; k=k+1;
        tmp = squeeze(mrall(:,a,m,:));
        [h,p] = ttest(tmp(:,1),tmp(:,10));
        for i=1:10
            bar(i,mean(tmp(:,i)),'facecolor','b','edgecolor','none');
            errorbar(i,mean(tmp(:,i)),std(tmp(:,i))./size(tmp,1),'linewidth',1,'color','k')
        end
        xlim([0 11])
        xlabel('Time Period');ylabel('mean r value');
        title({['ALLSUB_' mtype{m} '_' atype{a}] ['p=' num2str(p)]},'interpreter','none');
    end
end


% turning curve for all periods
% for index = 1:11
%     data    = rlts.rallinsact_rest(:,1+(index-1)*laglen:index*laglen);
%     [row,~] = find(isnan(data)==true);
%     data(unique(row),:)=[];
%     h(index) = plot(rlts.lags_rest./4.8,mean(data),'-o','linewidth',1,'color','k','markerfacecolor',cols(index,:));
% end
% legend(h,{'pre-stim','post-stim 1','post-stim 2','post-stim 3','post-stim 4','post-stim 5'...
%                     ,'post-stim 6','post-stim 7','post-stim 8','post-stim 9','post-stim 10'},'location','eastoutside')
% title('Tuning Trend for Gamma Response Eles')
% xlabel('Time (ms)');
% ylabel('mean r value of ins')
% set(gca,'fontsize',14)

%% turning curve for single period
laglen = length(rlts.lags_rest);
figure('position',[1500 10 4*200 3*200]);k=1;
for a = 1:2
for m = 2:4
for index = 11%:11
    subplot(2,3,k);hold on; k=k+1;
    eval(['data = rlts.rall' mtype{m} atype{a} '_rest(:,1+(index-1)*laglen:index*laglen);'])
    [row,~] = find(isnan(data)==true);
    data(unique(row),:)=[];
    data = data';
    [~,colu] = find((data>0.3)==1);
    colu     = unique(colu);
    % show the figure
    plot(rlts.lags_rest./4.8,data(:,colu),'color',[0.8 0 0]);
    plot(rlts.lags_rest./4.8,data(:,setdiff(1:size(data,2),colu)),'color',[0.5 0.5 0.5]);
    d1 = mean(data(:,colu),2);
    d2 = mean(data(:,setdiff(1:size(data,2),colu)),2);
    plot(rlts.lags_rest./4.8,d1,'linewidth',4,'color','r');
    plot(rlts.lags_rest./4.8,d2,'linewidth',4,'color','k');
    plot(rlts.lags_rest./4.8,ones(length(d1),1).*0.3,'linestyle','--','color','k');
    %[r,~] = corr(d1,d2,'type','pearson');
    title(['AMC082_' mtype{m} '_' atype{a}],'interpreter','none');
    ylim([-0.6 0.6])
    xlabel('Time (ms)');
    ylabel('mean r value')
    set(gca,'fontsize',14)
end
end
end

% 2D distribution
figure('position',[1500 10 4*200 3*200]);k=1;
for a = 1:2
for m = 2:4
    subplot(2,3,k);hold on; k=k+1;
    for index = 1:11
        eval(['data = rlts.rall' mtype{m} atype{a} '_rest(:,1+(index-1)*laglen:index*laglen);'])
        [row,~] = find(isnan(data)==true);
        data(unique(row),:)=[];
        data = data';
        x = data(rlts.lags_rest==0,:);
        %y = max(data)-min(data);
        y = max(data);
        h(index) = scatter(x,y,10,'markerfacecolor',cols(index,:),'markeredgecolor','none');
    end
    title(['AMC082_' mtype{m} '_' atype{a}],'interpreter','none');
    %legend(h,{'pre-stim','post-stim 1','post-stim 2','post-stim 3','post-stim 4','post-stim 5'...
    %                    ,'post-stim 6','post-stim 7','post-stim 8','post-stim 9','post-stim 10'},'location','eastoutside')
    xlabel('r value at time 0');
    %ylabel('max(r)-min(r)')
    ylabel('max(r)')
    ylim([-0.2 0.8]);xlim([-0.5 0.5])
    set(gca,'fontsize',14)
end
end




%% AlphavsGamma: resting state data
%clc,clear;
%rlts = plot_restdata_modulate_topography();
% save('restdata_modulate_rlts.mat','rlts');
% load('restdata_modulate_rlts.mat','rlts');

close all;
mtype = {'ev','ins','phase','amp'}; 
atype = {'', 'sf'};
atypename = {'seg', 'shift'};
cols  = {'r','g','b'};
ptall_indx = [3,6,8:12];

for pt = 1:length(ptall_indx)
    [CMP, runvars] = main_audCMPstim(ptall_indx(pt));
    locs     = find(cell2mat(rlts.chinfo(:,2))==ptall_indx(pt));
    savename = rlts.chinfo{locs(1),1};
    load([CMP.dtpath '/process_data/' savename '_rest_process.mat'],'par_process');
    
    % show the r trace
    figure('position',[1500 10 4*200 3*200]);k=1;
    for a = 1:2
    for m = 1:4
        subplot(2,4,k);hold on; k=k+1;
        eval(['data = rlts.rall' atype{a} '_' mtype{m} '(locs,:);'])
        eval(['t = rlts.' atype{a} 't' ';'])
        plot(t,data','color',[0.8 0.8 0.8]);
        plot(t,mean(data),'color','r','linewidth',2);
        xlabel('lag time (ms)');
        ylabel('r value')
        title([rlts.chinfo{locs(1),1} '_' mtype{m} '_' atypename{a}],'interpreter','none');
        set(gca,'fontsize',14)
    end
    end
    saveas(gcf,['results 2020-03-25/alpha_vs_gamma/resttrace_' num2str(pt)],'png');
    close(gcf)
    
    % show topography
    for m=1:4
        eval(['data = rlts.rallsf_' mtype{m} '(locs,:);'])
        radius = zeros(length(par_process.bdchans)+length(par_process.gdchans),1);
        radius(par_process.gdchans) = (max(data,[],2)-min(data,[],2)).*10;
        cols     = [1 0 0];
        fig_name = mtype{m};
        show_restdata_modulate_topography(CMP,runvars,radius,cols,savename,fig_name,'off')
    end
end

%%




            






for m = 1:2
    figure; hold on;
    x  = -0.5:0.01:0.5;
    h  = [];
    rm = [];
    for n = 1:3
        eval(['rall = rlts.rall_' mtype{m} '(:,' num2str(num(n)) ');'])
        h(n)    = bar(x,histc(rall,x),'FaceColor',cols{n},'EdgeColor','none','FaceAlpha',.5); 
        rm(:,n) = rall;
    end
    legend(h,{['rng: [' num2str(rng(num(1),1)) ' ' num2str(rng(num(1),2)) ']ms; mean=' num2str(mean(rm(:,1)))], ...
              ['rng: [' num2str(rng(num(2),1)) ' ' num2str(rng(num(2),2)) ']ms; mean=' num2str(mean(rm(:,2)))], ...
              ['rng: [' num2str(rng(num(3),1)) ' ' num2str(rng(num(3),2)) ']ms; mean=' num2str(mean(rm(:,3)))]},...
              'location','northoutside')
    [~,p0]=ttest2(rm(:,1), rm(:,3));
    title({mtype{m}, ['bl vs tk: p=' num2str(p0)]})
    xlabel('pearson r value');
    ylabel('electrodes number')
    set(gca,'fontsize',14)
    
    % difference distribution
    figure; hold on;
    x = -0.5:0.01:0.5;
    h1 = bar(x,histc(rm(:,3)-rm(:,1),x),'FaceColor','k','EdgeColor','none','FaceAlpha',.5); 
    legend(h1,{'tk-bl'})
    [~,p0]=ttest(rm(:,3)-rm(:,1));
    title({['rall ' mtype{m} ' tk-bl: mean=' num2str(mean(rm(:,3)-rm(:,1)))],...
           ['p=' num2str(p0)]},'interpreter','none')
    xlabel('pearson r value of tk-bl');
    ylabel('electrodes number')
    set(gca,'fontsize',14)
end

% tuning figure
figure;
plot(mean(rng,2),mean(rlts.rall_ins),'k-o','linewidth',4,'MarkerSize',15,'MarkerFaceColor','r','MarkerEdgeColor','r')
title('Tuning Trend')
xlabel('Time (ms)');
ylabel('mean r value of ins')
set(gca,'fontsize',14)

figure;
plot(mean(rng,2),mean(rlts.rall_ev),'k-o','linewidth',4,'MarkerSize',15,'MarkerFaceColor','r','MarkerEdgeColor','r')
title('Tuning Trend')
xlabel('Time (ms)');
ylabel('mean r value of ev')
set(gca,'fontsize',14)

% raw shift
for m = 1:2
    figure; hold on;
    x  = -0.5:0.01:0.5;
    h  = [];
    rm = [];
    for n = 1:3
        eval(['rall = rlts.rallsf_' mtype{m} '(:,' num2str(num(n)) ');'])
        h(n)    = bar(x,histc(rall,x),'FaceColor',cols{n},'EdgeColor','none','FaceAlpha',.5); 
        rm(:,n) = rall;
    end
    legend(h,{['rng: [' num2str(rng(num(1),1)) ' ' num2str(rng(num(1),2)) ']ms; mean=' num2str(mean(rm(:,1)))], ...
              ['rng: [' num2str(rng(num(2),1)) ' ' num2str(rng(num(2),2)) ']ms; mean=' num2str(mean(rm(:,2)))], ...
              ['rng: [' num2str(rng(num(3),1)) ' ' num2str(rng(num(3),2)) ']ms; mean=' num2str(mean(rm(:,3)))]},...
              'location','northoutside')
    [~,p0]=ttest2(rm(:,1), rm(:,3));
    title({mtype{m}, ['raw shift bl vs tk: p=' num2str(p0)]})
    xlabel('pearson r value');
    ylabel('electrodes number')
    set(gca,'fontsize',14)
end

figure;
plot(mean(rng,2),mean(rlts.rallsf_ins),'k-o','linewidth',4,'MarkerSize',15,'MarkerFaceColor','r','MarkerEdgeColor','r')
title('Tuning Trend: raw shift')
xlabel('Time (ms)');
ylabel('mean r value of ins')
set(gca,'fontsize',14)

figure;
plot(mean(rng,2),mean(rlts.rallsf_ev),'k-o','linewidth',4,'MarkerSize',15,'MarkerFaceColor','r','MarkerEdgeColor','r')
title('Tuning Trend: raw shift')
xlabel('Time (ms)');
ylabel('mean r value of ev')
set(gca,'fontsize',14)
