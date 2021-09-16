function [pc1s]=pc_clean(pc1,StimulusCode,cls_cond);
%this function smooths the pcs, puts them in units of mean/std of
%stimulus-code cls_cond


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('cls_cond')
    pc1=(pc1-mean(pc1(find(StimulusCode==cls_cond))))/std(pc1(find(StimulusCode==cls_cond)));
else
    pc1=(pc1-mean(pc1))/std(pc1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%DO SMOOTHING%%%%%%%
% winlength=80;
winlength=250;

pc1s=(conv(pc1,gausswin(winlength)));pc1s(1:floor(winlength/2-1))=[];pc1s((length(pc1s)-floor(winlength/2-1)):length(pc1s))=[]; pc1s=(pc1s-mean(pc1s))/std(pc1s);
