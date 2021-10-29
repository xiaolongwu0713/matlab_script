function [kEleAllTrialAllSession,kEleEverySession,kEleAllSession]=activeChannels(k)
sessions=4;
for session=[1:sessions]
    act{session}=activation(session); % act: channel * trial
    subplot(2,2,session)
    surface(act{session});
end

k=5;
for session=[1:sessions]
    [klargest,kEleAllTrial]=maxk(act{session},k);% tenlargest:10values*40trials index:10index*40trials
    % k most activated ele for each trial. column is ele, row is trial.
    kEleAllTrialAllSession{session}=kEleAllTrial; % A
    for ele=[1:109]
        occur(ele)=sum(sum(kEleAllTrial==ele));
    end
    eleActCountsAllSession{session}=occur;
    [countsEverySession{session},kEleEverySession{session}]=maxk(occur,k); % B
    %[occurances{session},eleindex{session}]=maxk(occur,10);
end
eleActCounts=[eleActCountsAllSession{1};eleActCountsAllSession{2};eleActCountsAllSession{3};eleActCountsAllSession{4}];
eleActCounts=sum(eleActCounts,1);
[countsAllSession,kEleAllSession]=maxk(eleActCounts,k); % C

% test the selection process
%a=repmat([0,1,2,9,8,7,6,5,4,3],1,11);a=a(1:109);
%act{1}=repmat(a',1,40);act{2}=repmat(a',1,40);act{3}=repmat(a',1,40);act{4}=repmat(a',1,40);
