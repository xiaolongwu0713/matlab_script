function [p, sa, cov, r] = linfit(x,y,sy)
%
%  		provides type 1 linear regression statitistics for x on y
%		call as:
%		[a,sa,cov,r] = linfit(x,y,sy)
%			where x is the independent variable
%			where y is the dependent variable
%			where sy is the uncertainty in y
%				NB: x,y,sy must be same length, except
%				    if sy=0 (unweighted fit)
%		    a(1) = intercept	sa(1) = uncertainty in intercept
%		    a(2) = slope	sa(2) = uncertainty in slope
%		    cov = covariance(intercept,slope)
%		    r = linear correlation coefficient
%
% Started 1996:09:15 W. Jenkins, WHOI
% Modif'd 2004:09:19 D. Glover, to fix the correl. coeff.
% Modif'd 2004:11:01 D. Glover, to fix the sign of correl. coeff.
% Modif'd 2005:01:26 W.Jenkins to fix Correl. Coefr. 
%                   (Bevington and Robinson, p. 199, Eq. 11.17)
% Modif'd 2006:09:19 S. Doney, to properly correct the unweighted error
%                    covariance matrix with the reduced Chi-square
% Modif'd 2006:11:02 D. Glover, to remove Mac line artifact introduced last time
% Modified by kjm for personal use, 10/2007
%reshape inputs (kjm)
x=reshape(x,length(x),1);
y=reshape(y,length(y),1);
sy=reshape(sy,length(sy),1);


n=length(x);

%	If sy is a single number, the unweighted, so make weights 1

Iamwtd=1;
if length(sy) == 1; sy=ones(length(x),1); Iamwtd=0; end

%	Next check to make sure the vectors are the same length

if length(y) ~= n; error('x and y must have equal lengths'); end
if length(sy) ~= n; error('x and sy must have equal lengths'); end

%	Construct sums

ssy=(1./sy).^2;		% since always using 1/sig^2 precalculate it
S=sum(ssy);
Sx=sum(x.*ssy);
Sxx=sum(x.*x.*ssy);
Sy=sum(y.*ssy);
Sxy=sum(x.*y.*ssy);

del=S*Sxx-Sx*Sx;		% the determinant for Cramer's rule
if del == 0; error('Your data is degenerate: det = 0'); end

a(1)=(Sxx*Sy-Sx*Sxy)/del;	% the intercept
a(2)=(S*Sxy-Sx*Sy)/del;		% the slope

if Iamwtd == 1
	sa(1)=sqrt(Sxx/del);		% uncertainties if weighted fit
	sa(2)=sqrt(S/del);
        cov=-Sx/del;			% covariance of intercept:slope
end

%       Calculate yhat and assoc. variables

yhat=a(1)+a(2).*x;
Syy=sum(y.*y.*ssy);
Syh=sum(yhat.*ssy);
Syyh=sum(yhat.*yhat.*ssy);

%		Now compute chisquared

A=[ones(n,1) x];
b=A*a';
sig=sum((b-y).^2)/(n-2);
if Iamwtd == 0
	sa(1)=sqrt(sig*Sxx/del);	% uncertainties if unweighted fit
	sa(2)=sqrt(sig*S/del);
        cov=-sig*Sx/del;		% covariance of intercept:slope
end

%r=-Sx/sqrt(S*Sxx);			% correlation coefficient betw errors int:slp
%SSR=Syyh-(Syh.*Syh)./n;     % sum of squares of regression
%SST=Syy-(Sy.*Sy)./n;        % total sum of squares
%r=sign(a(2))*sqrt(SSR/SST); % correlation coefficient of regression
r = (S*Sxy - Sx*Sy)/(S*Sxx - Sx*Sx)^0.5 / (S*Syy - Sy*Sy)^0.5;
p(2)=a(1);
p(1)=a(2);
