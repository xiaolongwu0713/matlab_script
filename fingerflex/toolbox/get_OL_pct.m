function OL_pct=get_OL_pct(d1,d2)

if size(d1,1)~=size(d2,1), d1=d1.';end
if size(d1,1)~=size(d2,1), error('dimsnotequal','dims of inputs not equal'),end


% overlap pct
if sum(d1.*d2)>0
    OL_pct=sum(d1.*d2)/sum(sort(d1).*sort(d2));
elseif sum(d1.*d2)<0
    OL_pct=sum(d1.*d2)/sum(sort(-d1).*sort(d2)); %flip sign of one to account for anticorr
end
        
%     OL_pct=sum(d1.*d2)/sum(sort(abs(d1)).*sort(abs(d2)));
    
    
    
    