function outrsa=rsa(d1,d2)
% function outrsa=rsa(d1,d2)
% this function calculates the signed r-squared cross-correlation for
% vectors d1 and d2.  it is signed to reflect d1>d2
% kjm 2007

d1=reshape(d1,1,[]);
d2=reshape(d2,1,[]);
outrsa=((mean(d1)-mean(d2))^3)/abs(mean(d1)-mean(d2))...
    /var([d1 d2])...
    *(length(d1)*length(d2))/length([d1 d2])^2;