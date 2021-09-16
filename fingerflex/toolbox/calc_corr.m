function c=calc_corr(a,b)
% function c=calc_corr(a,b)
% this function calculates the correlation as a function of time between two
% functions a and b, as a function of separation between points.
% First a and b are normalized and clipped to be the same length.  
% It returns a vector c, of the same length, that is the correlation 
% of the two as a function of datapoint separation.
% It is takes the complex conjugate of the the first entry, "a".
% kjm 5/2006

% normalize the vectors and put them in column mode, so the vector sum is
% easier
a=reshape(a,length(a),1); a=(a-mean(a))/std(a);
b=reshape(b,length(b),1); b=(b-mean(b))/std(b);

% clip the vectors so they're the same length
d=min([length(a) length(b)]);
a=a(1:d); b=b(1:d);

% take the correlation for each point and the shifted points
c=0*a; %initialize c
c(1)=sum(conj(a).*b)/d; %first value b/c MATLAB doesn't like zero indices
for i=2:d
    c(i)=sum(conj(a).*[b((d-(i-2)):d); b(1:(d-(i-1)))])/d;
end