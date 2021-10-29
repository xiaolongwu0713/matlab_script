function calculate_corration_ccep(ccep,runvars,stimulation)

if ccep.calculate_corration_ccep{1}
    mgam_bl = squeeze(mean(runvars.traces(:,:,1:runvars.control_samps/2),3));
    mgam_tk = squeeze(mean(runvars.bins(:,:,1:runvars.bin_samps*3),3));
    mgam    = mean(mgam_tk-mgam_bl,1)';
    save([ccep.results_folder '/' runvars.current_matfile_name(1:end-4) '_mgam.mat'],'mgam');

    % show the figure
    figure('color','w','position',[10 50 800 800],'visible',ccep.calculate_corration_ccep{2}); 
    col    = [1 0 0];
    actnum = runvars.good_channels;
    chan1  = stimulation.stim_channel_1;
    chan2  = stimulation.stim_channel_2;
    temp   = sort(mgam(actnum),'descend');
    mgam(mgam==temp(1)) = mgam(mgam==temp(2));
    r_DCS  = mgam./max(mgam(actnum)).*400;
    r_DCS(r_DCS<=0) = 1;
    coords = runvars.ElectrodeLocation;
    scatter(coords(actnum,2),coords(actnum,3),r_DCS(actnum),'MarkerEdgeColor',col,'MarkerFaceColor',col,'LineWidth',1);hold on;
    scatter(coords([chan1 chan2],2),coords([chan1 chan2],3),300,'h','MarkerEdgeColor','g','MarkerFaceColor','g','LineWidth',1);
    xlim([0 1]);ylim([0 1]);axis off; rectangle('position',[0 0 1 1],'linewidth',1);   
    name = ['DCS Correlation: Chan' num2str(chan1(1)) '_' num2str(chan2(1))];title(name,'fontsize',16,'interpreter','none');    
    title(name,'fontsize',30,'interpreter','none');
    saveas(gcf,[ccep.figpath '/' runvars.current_matfile_name(1:end-4) '_corr'],'png');
    
    % with label
    figure('color','w','position',[10 50 800 800],'visible',ccep.calculate_corration_ccep{2}); 
    scatter(coords(actnum,2),coords(actnum,3),r_DCS(actnum),'MarkerEdgeColor',col,'MarkerFaceColor',col,'LineWidth',1);hold on;
    scatter(coords([chan1 chan2],2),coords([chan1 chan2],3),300,'h','MarkerEdgeColor','g','MarkerFaceColor','g','LineWidth',1);
    text(coords(actnum,2),coords(actnum,3),num2cell(actnum),'HorizontalAlignment','center','VerticalAlignment','middle','fontsize',8);hold on;
    xlim([0 1]);ylim([0 1]);axis off; rectangle('position',[0 0 1 1],'linewidth',1);   
    name = ['DCS Correlation: Chan' num2str(chan1(1)) '_' num2str(chan2(1))];title(name,'fontsize',16,'interpreter','none');    
    title(name,'fontsize',30,'interpreter','none');
    saveas(gcf,[ccep.figpath '/' runvars.current_matfile_name(1:end-4) '_corr_label'],'png');
    
    
    disp('calculate_corration_ccep Done');
end

end

