function tf_data=waveletanalinear(data,fs,min_freq,max_freq,num_freq,plotty)
% function waveletana(data,fs,num_wave,min_freq,max_freq,num_freq,ploty)
% data: 1*15000 array
%clear all;
%load sampleEEGdata; 
%t=0:1/1000:15;
%data = chirp(t,0,15,250);
%data=squeeze(EEG.data(23,:,1));
%data=epoch(110,:,1);
min_freq=0.5;max_freq = 200;num_freq=100;
% define wavelet parameters
%frequencies = logspace(log10(min_freq),log10(max_freq),num_freq);
frequencies=linspace(min_freq,max_freq,num_freq);

wavelet_time = -1:1/fs:1;
%s    = logspace(log10(3),log10(40),num_freq)./(2*pi*frequencies);
s    = linspace(3,60,num_freq)./(2*pi*frequencies);
%s=4;
%s    = num_wave./(2*pi*frequencies);
half_of_wavelet_size = (length(wavelet_time)-1)/2;

% definte convolution parameters
n_wavelet            = length(wavelet_time);
n_data               = length(data);
n_convolution        = n_wavelet+n_data-1;
n_conv_pow2          = pow2(nextpow2(n_convolution));


% get FFT of data
%eegfft = fft(reshape(EEG.data(strcmpi(chan2use,{EEG.chanlocs.labels}),:,:),1,EEG.pnts*EEG.trials),n_conv_pow2);
fft_data=fft(data,n_conv_pow2);
% initialize
tf_data = zeros(length(frequencies),n_data); % frequencies X time X trials

%baseidx = dsearchn(EEG.times',[-500 -200]');

% loop through frequencies and compute synchronization
for fi=1:num_freq
    %wavelet = (pi*frequencies(fi)*sqrt(pi))^-.5 * exp(2*1i*pi*frequencies(fi).*wavelet_time) .* exp(-wavelet_time.^2./(2*( s/(2*pi*frequencies(fi)))^2))/frequencies(fi);
    wavelet=sqrt(1/(s(fi)*sqrt(pi))) * exp(2*1i*pi*frequencies(fi).*wavelet_time) .* exp(-wavelet_time.^2./(2*(s(fi)^2)));
    % plot(real(wavelet));
    fft_wavelet = fft(wavelet, n_conv_pow2 );
    % plot(abs(fft_wavelet));
    
    % convolution
    convolution_result_fft = ifft(fft_wavelet.*fft_data);
    convolution_result_fft = convolution_result_fft(1:n_convolution);
    convolution_result_fft = convolution_result_fft(half_of_wavelet_size+1:end-half_of_wavelet_size);
    
    % put power data into time-frequency matrix
    tf_data(fi,:) = abs(convolution_result_fft);
    
    
end

%baselineidx = [ 1 100 ]; % in ms
baselineidx = [1 2000]; % in ms
baseline_avg = mean(tf_data(:,baselineidx(1):baselineidx(2)),2);
tf_data=tf_data-baseline_avg;
for a=1:length(frequencies)
    s=std(tf_data(a,baselineidx(1):baselineidx(2))); %move1
    tf_data(a,:)=tf_data(a,:)./s;
end
%dbconverted = 10*log10( tf_data ./ repmat(baseline_avg,1,n_data) );

if plotty==1
    
    figure()
    cl=12;
    imagesc([1:n_data],[],dbconverted); % time is x-axis
    ytickskip = 2:4:num_freq;
    set(gca,'ydir','normal','clim',[cl*(-1) cl])
    set(gca,'ytick',ytickskip,'yticklabel',round(frequencies(ytickskip)),'clim',[cl*(-1) cl])
    title('Logarithmic frequency scaling')
end
%cfigure=gcf;
%figure
%contourf([1:n_data],frequencies,dbconverted,40,'linecolor','none')
%set(gca,'ytick',round(logspace(log10(frequencies(1)),log10(frequencies(end)),10)*100)/100,'yscale','log','xlim',[0 15000],'clim',[-12 12])
%title('Color limit of -12 to +12 dB')
end

% test:
% t=0:1/1000:15;
% data = chirp(t,0,15,250);
% waveletana(data,1000,2,200,100,1)