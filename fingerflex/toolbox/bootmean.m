function p=bootmean(a,b,iter)
% function p=bootmean(a,b,iter)
% bootstrap versus difference in means for distributions a and b, 
% 10^'iter' total iterations
% default iter is 10^4
% kjm 02/09

if exist('iter')~=1, iter=4; end

if size(a,2)>size(a,1), a=a'; end
if size(b,2)>size(b,1), b=b'; end

ptest=zeros(10^iter,1);
la=length(a); lb=length(b);
c=[a; b]; lc=la+lb; 

for k=1:(10^iter)
    tc=c(randperm(lc));
    ptest(k)= mean(tc(1:la))-mean(tc(la+[1:lb]));
end

abdiff=mean(a)-mean(b);
if abdiff<0
    abdiff=-abdiff;
    ptest=-ptest;
end
p=2*sum(ptest>abdiff)/length(ptest); %need to mult by 2 b/c of one-sided

% error('a','a') %debug
