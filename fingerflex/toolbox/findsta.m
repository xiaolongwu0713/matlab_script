function sta=findsta(filename, before, after, conditions)
%this function generates stimulus triggered averages for each condition,
%triggered to the onset of each stimulus condition,
%a common average reference is first applied
%file denoted by (filename) should have stimuli in vector StimulusCode in column vector
%file denoted by (filename) should have data in signal(pts,channels)
%before denotes time before stimulus to look at
%after (minus 1) denotes time after stimulus to look at
%conditions (array of length n) is n boolean statements on StimulusCode for stimuli to examine 
%conditions should have 

load(filename)
num_chans=length(signal(1,:));
% create a CAR spatial filter
spatfiltmatrix=[];
spatfiltmatrix=-ones(num_chans);
for i=1:num_chans
 spatfiltmatrix(i, i)=num_chans-1;
end
% perform spatial filtering
if (isempty(spatfiltmatrix) ~= 1)
   fprintf(1, 'Spatial filtering\n');
   signal=signal*spatfiltmatrix;
   if (size(signal, 2) ~= size(spatfiltmatrix, 1))
      fprintf(1, 'The first dimension in the spatial filter matrix has to equal the second dimension in the signal');
   end
end

%determine number of channels
channels=length(signal(1,:));

%initialize sta matrix
sta(:,:,:)=zeros(before+after,channels,length(conditions));

for i=1:length(conditions)
    cond=char(conditions(i));
    eval(strcat('indices=find(and(',cond, ',(StimulusCode-[0; StimulusCode(1:length(StimulusCode)-1)])~=0));')) %this will generate the onset of each stimulus of interest
    for j=1:length(indices)
        sta(:,:,i)=sta(:,:,i)+signal(indices(j)-before+1:indices(j)+after,:);
    end
    sta(:,:,i)=sta(:,:,i)/j;
end
    



