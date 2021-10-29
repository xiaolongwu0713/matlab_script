function location=read_h5file_electrodes_natomy(filename)
file=load(filename);
tmp=file.elec_Info_Final_wm.ana_label_name;
eleNumber=size(tmp,2);
location = strings;
for ele = [1:eleNumber]
    location(ele)=tmp{ele};
end
savefile=strcat(filename(1:end-4),'converted.mat');
save(savefile,'location');

end