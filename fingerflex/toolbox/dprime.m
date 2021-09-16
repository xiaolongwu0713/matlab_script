function [dprime]=dprime(data1,data2)
% d prime calculation - here using joint dist z-transform. (per heeger) 
% definitions differ, some are in units (data-mean(noise))/std noise
% some use joint std. some use separate. unclear
% kjm 02/09

%reshape inputs and concatenate, etc.
s1=size(data1); if s1(2)>s1(1), data1=data1'; end
s2=size(data2); if s2(2)>s2(1), data2=data2'; end


% what heeger seems to suggest... difference in means of each, in units of
% z-transform of joint distribution. pretty sensible
dprime=(mean(data1)-mean(data2))/std([data1; data2]); % note that i took the abs off so sign remains if you invert inputs


%% what wikipedia seems to suggest (data2 must be the "noise" data) i.e. centered and std w.r.t. noise... stupid
% dprime=abs(mean(data1)-mean(data2))/std(data2); 

%% what potentially could also make sense to me, but seems wrong
% dprime=abs(mean(data1)-mean(data2))/(std(data1)*std(data2))^.5; 

