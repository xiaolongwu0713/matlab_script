% function [Data]=cAr_EEG_Local(data,AC,pn)
function [Data]=cAr_EEG_Local(data,AC)
global processed_data;
pathname=strcat(processed_data,'BrainElectrodes');
load([pathname,'/electrode_raw.mat']); % load elec_Info, elecInfo, elecMatrix
load([pathname,'/SignalChanel_Electrode_Registration.mat']); % load CHN 110*1 double 
Data=data'; data=data';
Sub_Chn=cell2mat(elec_Info.number); %elec_Info.number: ele number per shaft
ele_number_seg(1)=1;
for h=1:length(Sub_Chn)
    ele_number_seg(h)=sum(Sub_Chn(1:h-1))+ele_number_seg(1);
end
for jj=1:length(Sub_Chn)
    ele_order=[];
    ele_order=[ele_number_seg(jj):sum(Sub_Chn(1:jj))];
    Chn_Seq=CHN(ele_order);
    for i=1:length(Chn_Seq)
        if i==1 
            if~isempty(intersect(Chn_Seq(1),AC)) && ~isempty(intersect(Chn_Seq(2),AC))
            Data(:,Chn_Seq(i))=data(:,Chn_Seq(i))-data(:,Chn_Seq(i+1));
            end
        elseif i==length(Chn_Seq) 
            if ~isempty(intersect(Chn_Seq(i-1),AC)) && ~isempty(intersect(Chn_Seq(i),AC)) 
            Data(:,Chn_Seq(i))=data(:,Chn_Seq(i))-data(:,Chn_Seq(i-1));
            end
        else 
            if ~isempty(intersect(Chn_Seq(i-1),AC)) && ~isempty(intersect(Chn_Seq(i),AC)) && ~isempty(intersect(Chn_Seq(i+1),AC)) 
            Data(:,Chn_Seq(i))=data(:,Chn_Seq(i))-(data(:,Chn_Seq(i-1))+data(:,Chn_Seq(i+1)))/2;
            end
        end
    end
end
Data=Data';
end