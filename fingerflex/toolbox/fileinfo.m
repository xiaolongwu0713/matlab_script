% fileinfo
% evaluates # hits and misses

%subject='d:\bci2000data\ecog\ck\ck033\ckS033R09.mat';
%subject='d:\bci2000data\ecog\dw\dw002\dwS002R04.mat';
subject='d:\bci2000data\ecog\es\es003\esS003R08.mat';

fprintf(1, 'Loading data file ...\n');
loadcmd=sprintf('load %s', subject);
eval(loadcmd);

trials=unique(trialnr);

numtrials=0;
hits=0;
misses=0;

fprintf(1, 'Going through trials ...\n');
for cur_trial=min(trials)+1:max(trials)
 if (mod(cur_trial+1, 25) == 0)
    fprintf(1, '%03d ', cur_trial+1);
    if (mod(cur_trial+1, 150) == 0)
       fprintf(1, '* /%d\r', max(trials));
    end
 end
 % get the indeces of the samples of the right trial
 trialidx=find(trialnr == cur_trial);
 cur_target=max(TargetCode(trialidx));
 cur_result=max(ResultCode(trialidx));
 if ((cur_target == 0) | (cur_result == 0))
    fprintf(1, 'Error trial=%d target=%d result=%d!!!\n', cur_trial, cur_target, cur_result);
 else
    if (cur_target == cur_result)
       hits=hits+1;
    else
       misses=misses+1;
    end
    numtrials=numtrials+1;
 end
end % session


fprintf('\nThere are %d total trials and %d hits and %d misses\n', numtrials, hits, misses);
