% Analyzes data from the BCI2000 P3 spelling paradigm
%
% (1) data has to be converted to a Matlab .mat file using BCI2ASCII
%     IMPORTANT: Set "Increment trial # if state" to "Flashing" and "1"
%
% (2) call this function
%     syntax: [res1ch, res2ch, ressqch] = p3(subject, samplefreq, channel, triallength,
%                                            plotthis, topotime, eloc_file, moviefilename)
%
%             [input]
%             subject          ... data file name (with .mat extension)
%             samplefreq       ... the data's sampling rate (e.g., 240)
%             [hpfreq lpfreq]  ... high- and low pass cutoff for 8th order butterworth (hp/lp<0: no filtering)
%             spatfiltmatrix   ... Spatial filtering matrix of in_channels x out_channels. if list is empty, no filtering is performed
%             eloc_file        ... file that contains the electrode positions (e.g., eloc64.txt, eloc16.txt)
%
%             what2plot        ... 1 (plot voltage spectra), 2 (plot difference spectra)
%
%             [output]
%             res1ch       ... average waveform for 'standard' condition for desired channel
%             res2ch       ... average waveform for 'oddball' condition for desired channel
%             ressqch      ... r-squared between standard and oddball condition for each point in time for desired channel
%             stimulusdata ... average waveforms for each stimulus
%
% (C) Gerwin Schalk 2002
%     Wadsworth Center, NYSDOH
%
function [res1, res2, ressq, freq_bins] = cohanalysis(subject, samplefreq, filters, spatfiltmatrix, channels, topofrequencies, topogrid, eloc_file, parms, spectral_size, spectral_stepping, cond1str, cond2str, cond1txt, cond2txt, what2plot)

fprintf(1, 'Coherence Analysis for BCI2000 Data V1.0\n');
fprintf(1, '(C) 2004 Gerwin Schalk\n');
fprintf(1, '         Wadsworth Center/NYSDOH\n');
fprintf(1, '*******************************************\n');

%channels=[9 11 13];
%samplefreq=160;
%topofrequencies=[1 4 7 10 13 16 19 22 25];  % this defines frequency bins, not frequencies !
%topogrid=[3 3];
%subject='D:\\BCI2000DATA\\SDH6bars\\sdh182\\sdh2_8.mat';
%eloc_file='eloc64.txt';
%spectral_size=48;
%spectral_stepping=32;
%cond1str='(TargetCode == 1) & (Feedback == 1)';
%cond2str='(TargetCode == 6) & (Feedback == 1)';

opengl neverselect;

condition1idxstr=sprintf('condition1idx=find((trialnr == cur_trial) & %s);', cond1str);
condition2idxstr=sprintf('condition2idx=find((trialnr == cur_trial) & %s);', cond2str);

if (topogrid(1)*topogrid(2) < max(size(topofrequencies)))
   fprintf(1, 'Increase size of topography grid !!\n');
end

%triallength=round(triallength*samplefreq/1000);    % convert from ms into samples

% load session
fprintf(1, 'Loading data file ...\n');
loadcmd=sprintf('load %s', subject);
eval(loadcmd);

% perform analog filtering before we do the analysis
hpfreq=filters(1);
lpfreq=filters(2);
if (hpfreq > 0)   % only perform the filtering if we want to
   fprintf(1, 'bandpass filtering signal\n');
   if (lpfreq > 0)
      [b, a]=butter(3, [(hpfreq/samplefreq)*2 (lpfreq/samplefreq)*2]);
   else
      [b, a]=butter(3, (hpfreq/samplefreq)*2);
   end
   for ch=1:size(signal, 2)
    signal(:, ch)=filter(b, a, signal(:, ch));
   end
end

% perform spatial filtering
if (isempty(spatfiltmatrix) ~= 1)
   fprintf(1, 'Spatial filtering\n');
   signal=signal*spatfiltmatrix;
   if (size(signal, 2) ~= size(spatfiltmatrix, 1))
      fprintf(1, 'The first dimension in the spatial filter matrix has to equal the second dimension in the signal');
   end
   %meansignal=mean(signal(:, spatfiltchannels), 2);
   %for ch=1:size(signal, 2)
   % signal(:, ch)=signal(:, ch)-meansignal;
   %end
end

avgdata1=[];
avgdata2=[];
trials=unique(trialnr);
% parms = [start, stop, delta, bandwidth, trend, model order, sampling rate]
%parms=[2.5, 100.5, 0.2, 2, 0, 18, samplefreq];
%parms=[4.5, 30.5, 0.2, 2, 0, 18, samplefreq];
start=parms(1);
stop=parms(2);
bandwidth=parms(4);
num_channels=size(signal, 2);

%spectral_bins=round((stop-start)/bandwidth)-1;       % for AR
spectral_bins=round(spectral_size/2)+1;             % for FFT

fprintf(1, 'Calculating spectra for all trials ...\n');
for cur_trial=min(trials)+1:max(trials)-1
 if (mod(cur_trial+1, 5) == 0)
    fprintf(1, '%03d ', cur_trial+1);
    if (mod(cur_trial+1, 50) == 0)
       fprintf(1, '* /%d\r', max(trials));
    end
 end

 % condition 1
 eval(condition1idxstr);
 if (isempty(condition1idx) == 0)
    % get the data for these samples
    condition1data=double(signal(condition1idx, :));
    [cur_spectrum, freq_bins]=temp_filter_COH(condition1data, spectral_size, samplefreq);
    avgdata1=cat(4, avgdata1, cur_spectrum);
 end

 % condition 2
 eval(condition2idxstr);
 if (isempty(condition2idx) == 0)
    % get the data for these samples
    condition2data=double(signal(condition2idx, :));
    [cur_spectrum, freq_bins]=temp_filter_COH(condition2data, spectral_size, samplefreq);
    avgdata2=cat(4, avgdata2, cur_spectrum);
 end
end % session

fprintf(1, '\r');

fprintf(1, 'Calculating r^2 statistics ...\n');
% calculate average spectra for each condition and each channel
res1=mean(avgdata1, 4);
res2=mean(avgdata2, 4);
%res1=avgdata1;
%res2=avgdata2;

% calculate rvalue/rsqu for each channel and each spectral bin between the two conditions
for i=1:9
 ressq(:, :, i) = calc_rsqu(squeeze(avgdata1(:, :, i, :)), squeeze(avgdata2(:, :, i, :)), 1);
end
% set all the NaN's and inf's to 0
tmp_idx=find(isfinite(ressq) == 0);
ressq(tmp_idx)=0; 
% go through all 9 figures indicating the coherence difference to all
% neighboring channels
idx=find(freq_bins < 100); % all frequencies under 100 Hz
for i=1:9
 %ressq = squeeze(res1(:, :, i)-res2(:, :, i));
 % plot the features
 figure(1);
 subplot(3, 3, i);
 surf(freq_bins(idx), [1:num_channels], ressq(idx, :, i)');
 shading flat;
 view(2);
 colormap jet;
 %colormap gray;
 colorbar;
 axis([min(freq_bins(idx)) max(freq_bins(idx)) 1 num_channels]);
 caxis([0, max(max(max(ressq)))]);
 %axis([1 spectral_bins 1 num_channels]);
 xlabel('Frequency (Hz)');
 ylabel('Channel');
 title('r^2 as a function of frequency and channel');
 % plot the topos
 num_topos=max(size(topofrequencies));
 for cur_topo=1:num_topos
  figure(2+cur_topo-1);
  subplot(3, 3, i);
  data2plot=ressq(topofrequencies(cur_topo), :, i);
  %fprintf(1, '%.4f %.4f\n', min(min(ressq)), max(max(ressq))); 
  %if (isfinite(data2plot))
     topoplot(data2plot, eloc_file, 'maplimits', [0, max(max(max(ressq)))], 'style', 'straight', 'interplimits', 'electrodes', 'headcolor', 'white');
     titletxt=sprintf('%.2f Hz', freq_bins(topofrequencies(cur_topo)));
     title(titletxt); 
     colormap jet;
     colorbar;
  %end
 end
end

return;

