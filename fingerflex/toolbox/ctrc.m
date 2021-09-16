function [tr,sigstat]=ctrc(data,indsa,indsb,d1,d2,st)
% function [taskrelatedcrosscorrelation,significance]=trc(data,eventmarkers_1,eventmarkers_2,first_time,second_time,statisticdecision)
% this function calculates the task related cross correlation for data(t)- 1xN or Nx1, locked
% to task markers of two different types (eventmarkers_1 and eventmarkers_2), examining the time window
% first_time:second_time, with respect to each event marker.  all numbers
% should be in sample units, not time units
% if statisticdecision=1, a bootstrapped statistic is calculated to
% estimate the probability that calculated correlation is due to chance
% kjm 8/2006

Na=length(indsa); %the total number of indices for class "a"
Nb=length(indsb); %the total number of indices for class "b"
dl=length(data); %the total length of the data
ntr2s=10; %the number of random epochs to compare each point with for p-value calc
qntrs=3; %the number of the random epochs to use for each each p-value calc sample
nfp=10000; %the number of samples to calculate p-value from

%joint eventmarkers done here for convenience
inds=[reshape(indsa,1,length(indsa)) reshape(indsb,1,length(indsb))];
Ni=length(inds);

if any((inds+d1)<1),error('crashme, oh yea, crashedme',strcat('error: there is a task related index that has a time within its window prior to it which is before the data')),end
if any((inds+d2)>(length(data))),error('victim of the crash, yes you crashedme, oh yea, crashedme',strcat('error: there is a task related index that has a time in its window following to it which extends beyond the limit of the data')),end



% trs=0;
trs=[];
for i=1:Na
    for j=1:Nb
        Vi=data((indsa(i)+d1):(indsa(i)+d2));
        Vj=data((indsb(j)+d1):(indsb(j)+d2));
%         trs=trs+sum((Vi-mean(Vi)).*(Vj-mean(Vj)));
        trs=[trs sum((Vi-mean(Vi)).*(Vj-mean(Vj))/(var(Vi)*var(Vj))^.5)];
    end
end
tr=sum(trs)/((Na*Nb)*(d2-d1));

if st==1    
    tr2s=zeros(Ni,ntr2s);
    for k=1:Ni
        for l=1:ntr2s
            Vk=data((inds(k)+d1):(inds(k)+d2));
            ri=floor(rand*(max(inds)-min(inds))+min(inds));
            Vl=data((ri+d1):(ri+d2));        
            tr2s(k,l)=sum((Vk-mean(Vk)).*(Vl-mean(Vl))/(var(Vk)*var(Vl))^.5);
        end
    end
    % ds=[];%count for number to see if its inside or outside of range for p estimate
    ds=0;
    for m=1:nfp % can vectorize this and see if it makes bootstrap stat process faster
        da=0;
        for n=1:Ni
            da=da+sum(tr2s(n,ceil(ntr2s*rand(qntrs,1))));
        end
        da=da/((d2-d1)*qntrs*Ni);
        if tr>0
            if da>tr
                ds=ds+1; % if corr exceeds, add in as value
            end
        else
            if da<tr
                ds=ds+1; % if corr exceeds, add in as value
            end
        end
    end
    sigstat=ds/(nfp);
else
    sigstat=[];
end


