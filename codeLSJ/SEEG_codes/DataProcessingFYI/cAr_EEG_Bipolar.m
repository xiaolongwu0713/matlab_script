function [Data,goodchs]=cAr_EEG_Bipolar(data,AC,pn)
 pathname=strcat('E:\Schalk\Data_Analysis\P',num2str(pn),'\S',num2str(pn),'_Demo_Marker/Electrodes');
 load([pathname,'\electrode_raw.mat']);
 load([pathname,'\SignalChanel_Electrode_Registration.mat']);
 load([pathname,'\electrodes_Final_Anatomy_wm.mat']);
Sub_Chn=cell2mat(elec_Info.number);
ele_number_seg(1)=1;

for h=1:length(Sub_Chn)
    ele_number_seg(h)=sum(Sub_Chn(1:h-1))+ele_number_seg(1);
end
bi_index=0;
goodchs=[];
for jj=1:length(Sub_Chn)
    ele_order=[];
    ele_order=[ele_number_seg(jj):sum(Sub_Chn(1:jj))];
    Chn_Seq=CHN(ele_order);
    elec_info_bipolar.number{jj}=length(Chn_Seq)-1;
    elec_info_bipolar.lead{jj}=elec_Info.name{jj};
    for i=2:length(Chn_Seq)
        bi_index=bi_index+1;
        Data(:,bi_index)=data(:,Chn_Seq(i))-data(:,Chn_Seq(i-1));
         if  ~isempty(intersect(Chn_Seq(i-1),AC)) && ~isempty(intersect(Chn_Seq(i),AC))             
            goodchs=[goodchs,bi_index];
         end
        elec_info_bipolar.PTD{bi_index}=[elec_Info_Final_wm.PTD(ele_order(i)),elec_Info_Final_wm.PTD(ele_order(i-1))];
        elec_info_bipolar.LocalPTD{bi_index}=[elec_Info_Final_wm.LocalPTD(ele_order(i)),elec_Info_Final_wm.LocalPTD(ele_order(i-1))];
        elec_info_bipolar.pos{bi_index}=(elec_Info_Final_wm.pos{ele_order(i)}+elec_Info_Final_wm.pos{ele_order(i-1)})/2;
        elec_info_bipolar.name{bi_index}=[{elec_Info_Final_wm.name{ele_order(i)}},{elec_Info_Final_wm.name{ele_order(i-1)}}];
        elec_info_bipolar.ana_label_name{bi_index}=[{elec_Info_Final_wm.ana_label_name{ele_order(i)}},{elec_Info_Final_wm.ana_label_name{ele_order(i-1)}}];
    end
end
if ~exist('BiPolar\Electrodes','dir')
    mkdir('BiPolar\Electrodes');
end
save('BiPolar\Electrodes\electrodes_Final_Anatomy_BiPolar.mat','elec_info_bipolar');
end