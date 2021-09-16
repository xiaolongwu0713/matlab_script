function gen_pac_matrix_all(subject)


%% general stuff, path, samplerate, etc

samplerate=1000;
fmax=50; num_bins=24;

%% load relevant data
load(['data/' subject '/' subject '_fingerflex'],'data'), data=car(data); % load re-reffed data from "decoupled" file
load(['data/' subject '/' subject '_pc_ts'],'lnA') % loads lnA (broadband)

%% gen pacs in normalized units - note embedded zscore call

pac_matrix=zeros(fmax,num_bins,size(data,2));
amp_corr=zeros(fmax,size(data,2));
    
disp('calculating palettes')
for chan = 1:size(data,2) 
    disp([subject ' channel ' num2str(chan) ' / ' num2str(size(data,2))])
    [pac_matrix(:,:,chan), amp_corr(:,chan), bin_centers]=phase_pac_range(zscore(lnA(:,chan)),data(:,chan),samplerate,num_bins,fmax);    
end


%% save

save(['data/' subject '/' subject '_pac_all'],'pac_matrix','bin_centers'),


