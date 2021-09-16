function out=sub_rand(lower,higher)
% function sub_rand(lower,higher)
% this function picks the number "lower" integer numbers from the number "higher"
% integers at random and exports them in the vector out dim:(1xlower)

a=(rand(1,lower));
out=floor(a*higher)+1;