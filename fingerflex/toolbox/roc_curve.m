function [auc]=roc_curve(data2,data1,plot_opt)
% function [auc]=roc_curve(data2,data1,plot_opt)
% calculates the area under the roc curve for data1 (noise) and data2 (signal+noise)
% if you reverse order, than auc -> 1-auc
% if you want to plot an auc curve, pass 'y' to plot_opt
% kjm 02/09

if exist('plot_opt')~=1, plot_opt='n'; end

%reshape inputs and concatenate, etc.
s1=size(data1); if s1(2)>s1(1), data1=data1'; end
s2=size(data2); if s2(2)>s2(1), data2=data2'; end

%generate bin edges for probability distribution fxns
m=mean([data1; data2]); s=std([data1; data2]); bs=(m-3*s):(s/10):(m+3*s); %bin size is 1/10th of standard dev

%generate probability distribution fxns
h1=hist(data1,bs+s/20); h1=h1/sum(h1);
h2=hist(data2,bs+s/20); h2=h2/sum(h2);

%true positive rates and false positive rates
fp=1-cumsum(h1);
tp=1-cumsum(h2);

%prune vectors (here done the lazy way) so fitting isn't biased later
q=0*tp; for k=2:length(tp), if and(tp(k)==(tp(k-1)),fp(k)==(fp(k-1))), q(k)=1; end, end
tp(find(q))=[]; fp(find(q))=[];bs(find(q))=[];
%clip near corners b/c of overrepresentation
a=find(or(and(tp<.02,fp<.02),and(tp>.98,fp>.98))); fp(a)=[]; tp(a)=[];

%area under curve - polynomial fit to interpolate
p=polyfit(fp,tp,10); %10th order fit
y=polyval(p,[0.01:0.01:1]); %resample
y(find(y<0))=0; y(find(y>1))=1; %because  of polynomial overfitting near 0,0 and 1,1
auc=sum(y)*.01;%area under curve
if or(auc>1,auc<0), error('a','a'),end

%plotting
if plot_opt=='y'
    figure,bar(bs+s/20, [fp,tp]),legend('False pos','True pos')
    
    figure, plot(fp,tp,'o')
    hold on, plot(x,y,'r')
    xlabel('false positive'),ylabel('true positive'),title('ROC curve')
end
