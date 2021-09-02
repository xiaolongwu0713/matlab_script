% RJ_EEG_Raw_Data.
clear;clc;
subjNum = 12;
inf_STAT = cell(subjNum, 1);
for i = 1:subjNum
    strname = strcat('D:\lsj\RJ_Raw_Data\P', num2str(i), '\inf1.mat');
    load(strname, 'Sub');
    tamp_Name = Sub.Name{1};
    if contains(tamp_Name, 'Name(')
        inf_STAT{i, 1} = tamp_Name(6:end-1);
    elseif contains(tamp_Name, '(')
        inf_STAT{i, 1} = tamp_Name(2:end-1);
    else
        inf_STAT{i, 1} = tamp_Name;
    end
end
strname = strcat('D:\lsj\RJ_Raw_Data\inf_STAT.mat');
save(strname, 'inf_STAT');