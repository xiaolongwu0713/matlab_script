function [pvals,tvals]=kjm_natbar(data,dt_cols,bar_off)
% this function makes modified vertical barplots that also show individual 
% datapoints, with errorbars showing the standard error of the mean
% it expects: 
%    data{M} in cell array format, with each of M array elements containing a column vector 
%    dt_cols - an Mx3 matrix (e.g. M by [r g b])
% 
% it plots:
%    - a databar in the background, decreased in intensity by 0.8
%    - all datapoints, distributed at random points within the width of the bar
%    - a horizontal black line at the mean of the data, with the same width
%    as the bar
%    - bars of 1/2 width at mean +/- SEM
%
% it returns:
%    - pvals - pvalue by unpaired ttest that difference in means is signficant - 
%              if only one column of data is sent, it returns value vs 0
%              if multiple, it returns a matrix of values in lower diagonal
%    - tvals - tstat by unpaired ttest that difference in means is signficant - 
%              if only one column of data is sent, it returns value vs 0
%              if multiple, it returns a matrix of values in lower diagonal
%
% kjm 9/2018


%%
% default gray dots if no dt_cols input
    if exist('dt_cols')~=1, dt_cols= .4+zeros(length(data),3); end 
    bg_cols=dt_cols+.5*(1-dt_cols); % background colors for bars

% default to having background bar on
if exist('bar_off')~=1, bar_off='n'; end

% bar width
    barwid=.5; pointwid=.7*barwid; errbarwid=.5*barwid;

%% plot each bar and data

for k=1:length(data)
    %%
    hold on
    dt=data{k};
    % plot bar if desired
    if bar_off~='y'
    bar(k,mean(dt),barwid,'FaceColor',bg_cols(k,:),'LineStyle','none')
    end
    
    % plot points
    hold on, plot(k-pointwid/2+pointwid*rand(size(dt)),dt,'.','Color',dt_cols(k,:),'MarkerSize',12)
    
    % plot mean line
    hold on, plot([k-barwid/2 k+barwid/2],mean(dt)*[1 1],'k-','LineWidth',2)
    
    % plot vertical line for +/- SEM
    hold on, plot(k*[1 1],mean(dt)+sem(dt)*[-1 1],'k-','LineWidth',1)
    
    % plot horizontal line at + SEM
    hold on, plot(k+errbarwid/2*[-1 1],mean(dt)+sem(dt)*[1 1],'k-','LineWidth',1)
    
    % plot horizontal line at - SEM
    hold on, plot(k+errbarwid/2*[-1 1],mean(dt)-sem(dt)*[1 1],'k-','LineWidth',1)
    

end

%% 
set(gca,'xlim',[0 length(data)+1],'xtick',[1:length(data)])

%% stats
if length(data)==1,
    [h,p]=ttest(data{1});
    [tmp1,p,tmp2,TTstats]=ttest(data{1});
    pvals=p; tvals=TTstats.tstat;
else
    for k=2:length(data)
        for q=1:(length(data)-1)
            [tmp1,p,tmp2,TTstats]=ttest2(data{k},data{q});
            pvals(k,q)=p; tvals(k,q)=TTstats.tstat;
        end
    end
end




    