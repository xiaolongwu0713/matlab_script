clear;clc;
pn = 10;Fs = 1000;
strname=strcat('H:/lsj/preprocessing_data/P',num2str(pn),'/preprocessing3_Algorithm/preprocessingALL_3_Algorithm_v3.mat');
load(strname,'preData');
[trials, slices, ~, channelNum, Tpoints] = size(preData);

repeatNum = 100; fbNum = 50;
% GuassMul = 1+0.2*randn(1, repeatNum);
SAVE_PATH = strcat('H:/lsj/Input_perturbation_network_prediction_correlation_map_p10_0910/re4.mat');
load(SAVE_PATH,'GuassMul');
for re = 5:15
    fprintf('re: %d', re);
    Sgn_pertu = zeros(fbNum, trials, slices, channelNum, Tpoints);
    for tr = 1:trials
        for sl = 1:slices
            for chn = 1:channelNum
                Sgn = reshape(preData(tr,sl,1,chn,:), 1, []);
                fft_Sgn = fft(Sgn);
                Am = abs(fft_Sgn);
                Ph = angle(fft_Sgn);
                for fb = 1:fbNum
                    Am_pertu = Am;
                    if fb == 1
                        Am_pertu(2:3) = Am_pertu(2:3)*GuassMul(re);
                        Am_pertu(499:500) = Am_pertu(499:500)*GuassMul(re);
                    else
                        Am_pertu(2*fb-1:2*fb+1) = Am_pertu(2*fb-1:2*fb+1)*GuassMul(re);
                        Am_pertu(501-2*fb:503-2*fb) = Am_pertu(501-2*fb:503-2*fb)*GuassMul(re);
                    end
                    fft_Sgn_pertu = Am_pertu.*cos(Ph) + Am_pertu.*sin(Ph)*1i;
                    ifft_Sgn_pertu = ifft(fft_Sgn_pertu);
                    Sgn_pertu(fb, tr, sl, chn, :) = real(ifft_Sgn_pertu);
                end   
            end
        end
    end
    SAVE_PATH = strcat('H:/lsj/Input_perturbation_network_prediction_correlation_map_p10_0910/re',num2str(re),'.mat');
    save(SAVE_PATH, 'Sgn_pertu' , 'GuassMul', '-v7.3');
end

                
                