function p=resamplevs0(dt)
%this function resamples vs zero by taking 2/3 of the distribution and
%testing vs zero 1000 times, returning the probability that the
%distribution has the same sign as the mean vs zero


%%
    if mean(dt)==0, error('distribution has 0 mean','distribution has 0 mean'), end

    gt0=mean(dt)>0; %test of whether mean is greater than zero

    dlength=length(dt);


%%
    for q=1:1000
        a=randperm(dlength);
        sub_inds=a(1:floor(2*dlength/3));
        mdt(q)=mean(dt(sub_inds))>0;

    end

     


%%

if gt0==1
p=1-sum(mdt)/1000;
else
p=sum(mdt)/1000;
end




