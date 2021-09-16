function gen_figs(ptname)


load(strcat(cd,'\stafiles\power\sta_',ptname))
load(strcat(cd,'\stats\stats_',ptname))
before=100; after=500;
imthresh=2; %threshold for imagesc saturation in units of std of the windows


%pchans=find(and(((((p_fb*length(p_fr))<.05)+((p_fr*length(p_fr))<.05)+((p_hb*length(p_fr))<.05)+((p_hfb*length(p_fr))<.05)+((p_hfr*length(p_fr))<.05)+((p_hr*length(p_fr))<.05)+((r_fb_pbs*length(p_fr))<.05)+((r_fhb_pbs*length(p_fr))<.05)+((r_fr_pbs*length(p_fr))<.05)+((r_hb_pbs*length(p_fr))<.05)+((r_hr_pbs*length(p_fr))<.05))>0),or(or(r_fr_m>.15,r_hr_m>.15),or(r_fb_m>.1,r_hb_m>.1))));
pchans=1:length(p_fr);%select all channels

for n=1:length(pchans)
    chan_ind=pchans(n);
    fr=squeeze(facebins_raw(:,chan_ind,:));
    fb=squeeze(facebins_band(:,chan_ind,:));
    hr=squeeze(housebins_raw(:,chan_ind,:));
    hb=squeeze(housebins_band(:,chan_ind,:));

%     [y,i]=max(abs(fb),[],1);%order by peak of band
    [y,i]=max((fb(before+100:after,:)),[],1);%order by peak of band increase
    [y2,ib]=sort(i);
%     [y,i]=max(abs(fr),[],1);%order by peak of raw displacement
    [y,i]=min((fr(before+100:after,:)),[],1);%order by peak of raw decrease
    [y2,ir]=sort(i);

    %plot traces
    plot((-before+1):after,mean(fb,2),'r','LineWidth',2), hold on, plot((-before+1):after,mean(hb,2),'b','LineWidth',2),
    xlabel('time with respect to stimulus (ms)')
    ylabel('displacement from baseline (number of standard deviations)')
    title(strcat(['\chi band power for trials in channel ', num2str(chan_ind)]))
    exportfig(gcf, strcat(cd,'\figs\',ptname,'_',num2str(chan_ind),'_band_trace.jpg'), 'format', 'jpeg', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 3, 'Height', 2);
    clf
    plot((-before+1):after,mean(fr,2),'r','LineWidth',2), hold on, plot((-before+1):after,mean(hr,2),'b','LineWidth',2),
    xlabel('time with respect to stimulus (ms)')
    ylabel('displacement from baseline (potential)')
    title(strcat(['raw, baselined for trials in channel ', num2str(chan_ind)]))
    exportfig(gcf, strcat(cd,'\figs\',ptname,'_',num2str(chan_ind),'_raw_trace.jpg'), 'format', 'jpeg', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 4, 'Height', 2);
    clf
    
    %plot rasters
    mm=imthresh*mean(std(fb,1));    
    imagesc((-before+1):after, 1:size(facebins_raw,3), fb(:,ib)',[-mm mm])
    xlabel('time with respect to stimulus (ms)')
    ylabel('trials')
    title(strcat(['\chi band power for face trials in channel ', num2str(chan_ind), ', by band displacement']))
    colorbar
    exportfig(gcf, strcat(cd,'\figs\',ptname,'_',num2str(chan_ind),'_band_fb','.jpg'), 'format', 'jpeg', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 3, 'Height', 2);
    clf
    
    mm=imthresh*mean(std(fr,1)); 
    imagesc((-before+1):after, 1:size(facebins_raw,3), fr(:,ib)',[-mm mm])
    xlabel('time with respect to stimulus (ms)')
    ylabel('trials')
    title(strcat(['raw, baselined for face trials in channel ', num2str(chan_ind), ', by band displacement']))
    colorbar
    exportfig(gcf, strcat(cd,'\figs\',ptname,'_',num2str(chan_ind),'_raw_fb','.jpg'), 'format', 'jpeg', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 3, 'Height', 2);
    clf
    
    mm=imthresh*mean(std(fb,1)); 
    imagesc((-before+1):after, 1:size(facebins_raw,3), fb(:,ir)',[-mm mm])
    xlabel('time with respect to stimulus (ms)')
    ylabel('trials')
    title(strcat(['\chi band power for face trials in channel ', num2str(chan_ind), ', by raw displacement']))
    colorbar
    exportfig(gcf, strcat(cd,'\figs\',ptname,'_',num2str(chan_ind),'_band_fr','.jpg'), 'format', 'jpeg', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 3, 'Height', 2);
    clf
    
    mm=imthresh*mean(std(fr,1)); 
    imagesc((-before+1):after, 1:size(facebins_raw,3), fr(:,ir)',[-mm mm])
    xlabel('time with respect to stimulus (ms)')
    ylabel('trials')
    title(strcat(['raw, baselined signal for face trials in channel ', num2str(chan_ind), ', by raw displacement']))
    colorbar
    exportfig(gcf, strcat(cd,'\figs\',ptname,'_',num2str(chan_ind),'_raw_fr','.jpg'), 'format', 'jpeg', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 3, 'Height', 2);
    clf
    
    if mean(max(hb(before+100:after,:)))>mean(max(-hb(before+100:after,:)))
        [y,i]=max(hb(before+100:after,:),[],1);
    else
        [y,i]=max(-hb(before+100:after,:),[],1);
    end
    [y2,ihb]=sort(i);
    if mean(max(hr(before+100:after,:)))>mean(max(-hr(before+100:after,:)))
        [y,i]=max(hr(before+100:after,:),[],1);
    else
        [y,i]=max(-hr(before+100:after,:),[],1);
    end
    [y2,ihr]=sort(i);
    
    mm=imthresh*mean(std(hb,1));    
    imagesc((-before+1):after, 1:size(housebins_raw,3), hb(:,ihb)',[-mm mm])
    xlabel('time with respect to stimulus (ms)')
    ylabel('trials')
    title(strcat(['\chi band power for house trials in channel ', num2str(chan_ind), ', by band displacement']))
    colorbar
    exportfig(gcf, strcat(cd,'\figs\',ptname,'_',num2str(chan_ind),'_band_hb','.jpg'), 'format', 'jpeg', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 3, 'Height', 2);
    clf

    mm=imthresh*mean(std(hr,1)); 
    imagesc((-before+1):after, 1:size(housebins_raw,3), hr(:,ihb)',[-mm mm])
    xlabel('time with respect to stimulus (ms)')
    ylabel('trials')
    title(strcat(['raw, baselined for house trials in channel ', num2str(chan_ind), ', by band displacement']))
    colorbar
    exportfig(gcf, strcat(cd,'\figs\',ptname,'_',num2str(chan_ind),'_raw_hb','.jpg'), 'format', 'jpeg', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 3, 'Height', 2);
    clf

    mm=imthresh*mean(std(hb,1)); 
    imagesc((-before+1):after, 1:size(housebins_raw,3), hb(:,ihr)',[-mm mm])
    xlabel('time with respect to stimulus (ms)')
    ylabel('trials')
    title(strcat(['\chi band power for house trials in channel ', num2str(chan_ind), ', by raw displacement']))
    colorbar
    exportfig(gcf, strcat(cd,'\figs\',ptname,'_',num2str(chan_ind),'_band_hr','.jpg'), 'format', 'jpeg', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 3, 'Height', 2);
    clf

    mm=imthresh*mean(std(hr,1)); 
    imagesc((-before+1):after, 1:size(housebins_raw,3), fr(:,ihr)',[-mm mm])
    xlabel('time with respect to stimulus (ms)')
    ylabel('trials')
    title(strcat(['raw, baselined signal for house trials in channel ', num2str(chan_ind), ', by raw displacement']))
    colorbar
    exportfig(gcf, strcat(cd,'\figs\',ptname,'_',num2str(chan_ind),'_raw_hr','.jpg'), 'format', 'jpeg', 'Renderer', 'painters', 'Color', 'cmyk', 'Resolution', 300, 'Width', 3, 'Height', 2);
    clf
end



