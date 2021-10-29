%for movetype=[1,3,4]
for movetype=[1:4]
    movement=strcat('move',num2str(movetype));
    data=load_data(9999,movement);
    badtrials=badtrial{movetype};
    goodtrials=setdiff([1:40],badtrials);
    channels=[activeChannels,112];
    epoch{movetype}=data(channels,:,goodtrials);
end
clear data;
% epochs=cat(3,epoch{1},epoch{3},epoch{4}); %train on 3 movement, exclude
% move 2
epochs=cat(3,epoch{1},epoch{2},epoch{3},epoch{4});
trialNum=size(epochs,3);
clear flatted;
for i=[1:trialNum]
  if i==1
    flatted=epochs(:,:,i);
  else
  flatted=cat(2,flatted,epochs(:,:,i));
  end
end
cla;
subplot(211);
plot(epochs(end-1,:,1));hold on; plot(epochs(end-1,:,2));legend('1','2');
subplot(212);
plot(flatted(end-1,1:15000)),hold on, plot(flatted(end-1,15001:30000)), legend('1','2')

flatted=flatted';
writematrix(flatted,'moveTemp.csv');
%writematrix(flatted,'move.csv','WriteMode','append');

%verify=readmatrix('move.csv');
% add column name
data=load_data(9999,'move1');
m1trial22=data(activeChannels,:,22);
data=load_data(9999,'move2');




m2trial23=data(activeChannels,:,23);
testdata=cat(2,m1trial22,m2trial23);
writematrix(testdata,'testgoogleautoml.csv');