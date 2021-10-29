%% compare the actived electrods extracted by corr/permutation and r-squared method
% main result: both of them extract all most the same electrod
% however cwt plot doesn't show any time-lock phenomenon
%% corr method
movetype=2;
movement=strcat('move',num2str(movetype));
epoch=load_data(1,movement);
bandf = [8 30];
filteredEpoch = bpfilter(double(epoch), 8, bandf(1), bandf(2), 1000);
epochEvenlop= abs(cubeHilbert(single(filteredEpoch)));
power= epochEvenlop.^2;

chns=activationUsingCorr(power,2); 
% move1:20    21    22    24    60    63   109   110
% move2:8     9    10    18    19    21    22    23    24    69    70    86   106   107   108   109   110
% 16    17    19    20    57    60   106
% 6     7    17    19    20    21    30    31   106

%% r-squared
rsq=rsqMove(power,movetype);
surface(rsq);
kchn=kmostactive(rsq,10);% return:(channel,trial)
for k=[1:size(kchn,2)]; act(k)=kchn{k}(1); end;
% move2: 19    20    21   110    22    19    24     9    10    18

%% 
actchn=epoch(19,:,:);
plotActiveChannel(squeeze(actchn),1);
print(gcf,['channel19-40trial-active-move',num2str(movetype)],'-r600','-dpng')



