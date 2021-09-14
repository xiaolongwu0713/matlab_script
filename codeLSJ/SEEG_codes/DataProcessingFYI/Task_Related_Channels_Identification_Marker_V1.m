for l=1:length(T)
f_i=T(l);
if f_i==7
load('Chnnum_bip.mat');
else
load('Chnnum.mat');    
end
switch f_i
    case 0
        f_str='WITHOUTCAR';
    case 1
        f_str='WITHCAR';
    case 2
        f_str='WITHCAR_CW_GROUPED';
    case 3
        f_str='LOCALREF';
    case 4
        f_str='WITHCAR_Median';
    case 5
        f_str='WITHCAR_Chn_Spec';
    case 6
        f_str='WITHCAR_Ele_Spec';
    case 7
        f_str='BiPolar';
end

for i=Ele_Ts_Ser
    switch i
        case 1
        DatName=strcat(f_str,'\Power_P',num2str(pn),'_H1_S12_C12345_B0.5_4.mat');        
        case 2
        DatName=strcat(f_str,'\Power_P',num2str(pn),'_H1_S12_C12345_B4_8.mat');
        case 3
        DatName=strcat(f_str,'\Power_P',num2str(pn),'_H1_S12_C12345_B8_12.mat');
        case 4
        DatName=strcat(f_str,'\Power_P',num2str(pn),'_H1_S12_C12345_B18_26.mat');
        case 5
        DatName=strcat(f_str,'\Power_P',num2str(pn),'_H1_S12_C12345_B60_140.mat');
        otherwise
            error('This Band does not exist, check the input!');       
    end     
[FF PP]=location_identification_Marker(DatName,Fs,chan,f_str);
Reactive_Ele.f{i}=[FF',PP'];
figure
scatter(FF,i*ones(1,length(FF)));
hold on;
end
reactive_ele=Reactive_Ele.f;
save(strcat(f_str,'\Ele_Identify\reactive_file.mat'),'reactive_ele');
end