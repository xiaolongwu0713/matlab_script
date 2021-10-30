function h=cubeHilbert(epoch)
% hilbert calculate along the column of matrix

h=zeros(size(epoch));
chns=size(epoch,1);
for chn=[1:chns]
    h(chn,:,:)=hilbert(squeeze(epoch(chn,:,:)));
end

% test good: use data=testDataHilbert(1,2);