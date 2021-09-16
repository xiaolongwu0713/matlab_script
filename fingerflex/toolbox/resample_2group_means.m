function p=resample_2group_means(dt1,dt2)
% this function resamples the difference between the means in 2 groups of data by combining them and resampling (with the same subgroup sizes) 10000 times, 
% returning the probability that the difference in means between the two
% groups should be that size or larger.
% kjm 4/17

%% reshape, get vectorlengths, setup joint distribution

    if size(dt1,1)<size(dt1,2), dt1=dt1.'; end
    if size(dt2,1)<size(dt2,2), dt2=dt2.'; end
    dtc=[dt1; dt2]; %combined distribution
    l1=length(dt1); l2=length(dt2); lc=length(dtc);

%% resampling
    for q=1:10000
        tmp_dt=dtc(randperm(lc));
        tmp_meandiff(q)=abs(mean(tmp_dt(1:l1))-mean(tmp_dt(l1+[1:l2])));
    end

%% calculate probability that resampled difference in means is larger     
    true_meandiff=abs(mean(dt2)-mean(dt1));
    p=sum(tmp_meandiff>=true_meandiff)/q;



