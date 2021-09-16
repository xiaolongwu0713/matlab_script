function out=randel(outnum, elsize)
%  out=randel(outnum, elsize)
% This function produces a vector of "outnum" random elements from 1 to
% "elsize", using the rand call as a kernel
% the outputted vector does not have any repeats
% kjm 5/2007


a=rand(1,elsize);
[y,k]=sort(a);
out=k(1:outnum);