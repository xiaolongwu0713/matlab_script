function [Data]=cAr_EEG(data,AC,ses)
    meanval=mean(data(:,AC),2);
    if ~exist('WITHCAR','dir')
        mkdir('WITHCAR');
    end
    save(strcat('WITHCAR\CAR_Mean_Data_',num2str(ses),'.mat'),'meanval');
    Data=data-repmat(meanval,1,size(data,2));
end