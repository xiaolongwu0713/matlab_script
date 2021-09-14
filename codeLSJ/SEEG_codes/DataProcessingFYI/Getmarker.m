function [ Fea_label ] = Getmarker( data,CLASS_NUM,TRIAL_NUM)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This function is used to finder the trigger index of each class among
%   each session's data
%   Suitable for the data that acquired using NKH system in the hospital
%   and the experiment is conducted using e-prime software.
%   Data is the matrix that stores the data of triggers, (M x CLASS_NUM)
%   CLASS_NUM is the number of classes to be classified.
%   TRIAL_NUM is the number of trials conducted.
%   Fea_label is the sequnece of each class label shown in the experiment.
%   By Liguangye (liguangye.hust@gmail.com),@2016.04.27 @SJTU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
markerindex=zeros(TRIAL_NUM,CLASS_NUM);
L=size(data,1);
Fea_label=zeros(L,1);
New_data=zeros(L,CLASS_NUM);

if size(data,2)<CLASS_NUM
    error('Column of data matrix shall be greater than number of classes! ');
else
    New_data=data(:,1:CLASS_NUM);
end

for i=1:CLASS_NUM
    mid_data=(max(New_data(:,i))+min(New_data(:,i)))/2;
    index_mod=0;
    for j=1:L-1
        if New_data(j,i)<mid_data && New_data(j+1,i)>=mid_data
            index_mod=index_mod+1;
            markerindex(index_mod,i)=j;
        end
    end
end
% save('mark.mat','markerindex');
temp_label=reshape(markerindex,TRIAL_NUM*CLASS_NUM,1);
[new_label,index_sort]=sort(temp_label);
value_order=zeros(TRIAL_NUM*CLASS_NUM,1);
for i=1:CLASS_NUM
  for j=1:length(new_label)
    if index_sort(j)>=(i-1)*TRIAL_NUM+1 && index_sort(j)<=i*TRIAL_NUM
        value_order(j)=i;
    end
  end
end

for i=1:length(new_label)
    Fea_label(new_label(i))=value_order(i);
end

end

