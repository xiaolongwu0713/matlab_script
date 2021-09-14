function delete_files(carind,index,type,pn)
BAND{1}=[0.5,4];
BAND{2}=[4,8];
BAND{3}=[8,12];
BAND{4}=[12,30];
BAND{5}=[30,60];
BAND{6}=[60,140];
for i=index
    if index==0
        return;
    else
        BandUse=BAND{i};
        if type ==1
            filename=strcat('Time_P',num2str(pn),'_H1_S12_C12345_B',num2str(BandUse(1)),'_',num2str(BandUse(2)),'.mat');
        else
            filename=strcat('Power_P',num2str(pn),'_H1_S12_C12345_B',num2str(BandUse(1)),'_',num2str(BandUse(2)),'.mat');
        end
        for j=carind
            switch j
                case 0
                    named=strcat('WITHOUTCAR\',filename);
                    if exist(named)
                        delete(named);
                    end
                case 1
                    named=strcat('WITHCAR\',filename);
                    if exist(named)
                        delete(named);
                    end
                case 2
                    named=strcat('WITHCAR_CW_GROUPED\',filename);
                    if exist(named)
                        delete(named);
                    end
                case 3
                    named=strcat('LOCALREF\',filename);
                    if exist(named)
                        delete(named);
                    end
                case 6
                    named=strcat('WITHCAR_Ele_Spec\',filename);
                    if exist(named)
                        delete(named);
                    end
                case 7
                    named=strcat('BiPolar\',filename);
                    if exist(named)
                        delete(named);
                    end
            end
        end
    end
end