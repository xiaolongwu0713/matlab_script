function [ signal_raw, signal_rawerp, signal_tmp_gmm, signal_tmp_alp, par ] = processing_ccep(CMP, runvars, par, index)

disp(runvars.matfiles_ccep(index).name(1:end-4));
load(fullfile(CMP.dat_folder_ccep,runvars.matfiles_ccep(index).name));
load(fullfile(CMP.dat_folder_ccep,'known_bad_channels_xie')); 
parinfo                 = get_subinfo(runvars.patient);

par.stim_exclusion_zone_mm = 5;
par.tmp_rng             = [-200 250];  
par.bdchans             = lookup_bad_channels(ccep_bad_channels,runvars.matfiles_ccep(index),runvars.tala,stimulation);
par.bdchans             = unique([par.bdchans, parinfo.bdchans]);
par.line_frequency      = line_frequency(stimulation);
par.electrode_distances = calculate_distances(runvars.tala,stimulation);
par.close_to_stim_site  = find(par.electrode_distances < par.stim_exclusion_zone_mm); 
par.stimulation         = stimulation;
par.stimlocs            = stimulation.stim_locations;
par.stimtype            = {};
par.fs                  = parameters.SamplingRate.NumericValue;
par.category            = {'Single pulse stim'};

%% processing=======================================================
if strcmp(stimulation.subject(1:3),'AMU');signal = remove_amp_init_artifact(signal,120);end % remove amplifier initialization artifact in asahikawa data
signal        = signal(:,runvars.coords(:,1)); 
par.gdchans   = setdiff(1:size(signal,2),par.bdchans); 
stim_mask_gmm = [0 3.5];

% high-pass filter
signal      = filter_alltype(signal, par.gdchans, 'highpass[0.5]', par.fs);

%% find noise channels
% remove artifact
par.stim_mask_ms  = stim_mask_gmm;
[signal_tmp, par] = remove_artifact(signal,par);

% 3 noise channels
bdchans_auto = calculate_linenoisechannels(signal_tmp, par);
par.bdchans  = union(par.bdchans,bdchans_auto);
par.gdchans  = setdiff(1:size(signal_tmp,2),par.bdchans); 

%% for ERP==================================================================
% re-reference to silent electrode
signal_rawerp   = signal - repmat(mean(signal(:,parinfo.refchans),2),1,size(signal,2));

% remove artifact
par.stim_mask_ms     = stim_mask_gmm;
[signal_rawerp, par] = remove_artifact(signal_rawerp,par);

% notch filter
signal_rawerp  = filter_alltype(signal_rawerp, par.gdchans, 'notch60', par.fs);

% remove artifact
par.stim_mask_ms     = stim_mask_gmm;
[signal_rawerp, par] = remove_artifact(signal_rawerp,par);

% ccep noise channel
[bdchans_n, chans_for_car]  = define_noise_ccep(signal_rawerp, CMP, par, [500 150], true);
par.larg_amp_chans          = bdchans_n;

%% for gamma ===============================================================
% CAR
disp('car filter signal start');
signal_tmp  = signal;
signal_mean = mean(signal(:,chans_for_car),2);
parfor indx=1:size(signal,2)
    signal_tmp(:,indx) = signal_tmp(:,indx)-signal_mean;
    fprintf(1,'.');        
end
disp('car filter signal end');

% remove artifact
par.stim_mask_ms  = stim_mask_gmm;
[signal_tmp, par] = remove_artifact(signal_tmp,par);

% notch filter
signal_tmp  = filter_alltype(signal_tmp, par.gdchans, 'notch60', par.fs);

% subtract template
[signal_tmp, par] = subtract_template(signal_tmp, par);
signal_tmp_gmm    = signal_tmp;
signal_raw        = signal_tmp;

% remove alpha artifact
par.stim_mask_ms      = [0 50];
[signal_tmp_alp, par] = remove_artifact(signal_tmp,par);

% export data
for i = 1:length(par.stimlocs)
    par.stimtype{i,1} = par.category;
end
signal_tmp_gmm = single(signal_tmp_gmm);
signal_tmp_alp = single(signal_tmp_alp);

disp('Processing Done')
