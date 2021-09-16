function [OL_pct, OLM, p_val, rs_kurt]=spat_reshuffle(d1,d2, plot_opt)
%  function [OLM, p_val, rs_kurt]=spat_reshuffle(d1,d2, plot_opt)
%  this function quantifies overlap of activation at electrode sites for two
%  conditions, "d1" and "d2", using the resampling technique described in
%  the manuscript "Cortical Activity During Motor Movement, Motor Imagery, 
%  and Imagery-Based Online Feedback," by KJ Miller, et. al. in PNAS 107(9)4430-4435.
%
%  set plot_opt='y' to make plots
%
%  The default number of reshuffling iterations is 10^7. Change manually
%  within the function if you would like it differently.
%
%  The output variables are:
%     OL_pct  -- "Overlap percentage" [0 1] spatial dot product divided
%                by the dot product of the magnitude-sorted dot product
%     OLM     -- the overlap metric, in z-score units of the surrogate
%                distribution. Good measure if surrogate distribution is 
%                roughly Gaussian (ie. rs_kurt is close to 3).
%     p_val   -- the probability that the observed overlap could be due to
%                chance. See discussion of correction because of estimated 
%                cluster size, etc., from paper.
%     rs_kurt -- Kurtosis of surrogate distribution.
%     
%  kjm 11/2009
%  kjm  3/2011 - updated to include overlap pct

%make plots? (plot_opt='y' to make plots)
    if exist('plot_opt')~=1, plot_opt='n'; end

% input variable housekeeping
    if size(d1,1)<size(d1,2),d1=d1.'; end
    if size(d2,1)<size(d2,2),d2=d2.'; end
    if prod(double(size(d1)==size(d2)))~=1, error('dimerr','The dimensions of the two arrays are not the same'), end    
    elnum=size(d1,1);

%default number of reshuffling iterations
% rs_dis=zeros(10^7,1);
    rs_dis=zeros(10^6,1); 

% proper overlap
    OL=sum(d1.*d2); 

% overlap pct
    if sum(d1.*d2)>0
        OL_pct=sum(d1.*d2)/sum(sort(d1,'ascend').*sort(d2,'ascend'));
    elseif sum(d1.*d2)<0
        OL_pct=sum(d1.*d2)/sum(sort(d1,'descend').*sort(d2,'ascend')); %flip one to account for anticorr
    end

% get reshuffling distribution
    for k=1:length(rs_dis), rs_dis(k)=sum(d1(randperm(elnum)).*d2); end, 

% get overlap values, stats
    if OL>mean(rs_dis)
        p_val=sum(rs_dis>OL)/length(rs_dis); %p-value calculation
    else 
        p_val=sum(rs_dis<OL)/length(rs_dis); %p-value calculation
    end

% overlap metric
    mm=mean(rs_dis); ms=std(rs_dis);
    OLM=(OL-mm)/ms; %overlap metric (distance from mean of surrogate distribution, in units of standard deviation "z-score")

% kurtosis    
    rs_kurt=kurtosis(rs_dis);% how good is the gaussian approximation?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp([' '])
    disp(['Overlap pct: ' num2str(OL_pct)])
    disp(['p-value for overlap: ' num2str(p_val)])
    disp(['Overlap (z-score units): ' num2str(OLM)])
    disp(['Kurtosis: ' num2str(rs_kurt)])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% optional plotting
    if plot_opt=='y'
        %histogram to +/- 5 SDs, in .25*SD increments
        [bh,bc]=hist((rs_dis-mm)/ms,(-5):(.25):(5)); bh=bh/sum(bh);

        clf, hold on, %make figure
        bar(bc,bh,'EdgeColor','w','FaceColor',[.3 .3 .3])
        plot([OLM OLM],[0 1.2*max(bh)],'r')
            set(gca,'YLim',[0 1.2*max(bh)])
            legend('Surrogate Distribution', 'Actual overlap','Location','NorthWest')
            xlabel('Overlap measure, in units of SD from mean')
            ylabel('Probability, with binsize 0.25 * SD')
            title(['Overlap, actual vs. surrogate distribution (kurtosis=' num2str(rs_kurt) ')'])
    end
    
    %%
%     error('a','a')