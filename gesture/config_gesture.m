function [SubInfo] = config_gesture(subj)

switch subj

    case 2
        SubInfo.Session_num=[1:2];
        SubInfo.UseChn=[1:19,21:37,43:44,47:129];
        SubInfo.EmgChn=[145:146];
        SubInfo.TrigChn=[38:42];
    case 3
        SubInfo.Session_num=[1,3];
        SubInfo.UseChn=[1:19,21:37,44:45,48:189];
        SubInfo.EmgChn=[192:193];
        SubInfo.TrigChn=[38:42];
    case 4
        SubInfo.Session_num=[2,3];
        SubInfo.UseChn=[1:19,21:37,43:44,47:68];
        SubInfo.EmgChn=[75:76];
        SubInfo.TrigChn=[38:42];
    case 5
        SubInfo.Session_num=[1,3];
        SubInfo.UseChn=[1:19,21:37,43:44,47:150,151:166,167:186]; % N1 has some drifts during the entire session, and need to be removed in the future
        SubInfo.EmgChn=[187:188];
        SubInfo.TrigChn=[38:42];
    case 7
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:19,21:37,44:45,48:126,128:153];
        SubInfo.EmgChn=[162:163];
        SubInfo.TrigChn=[38:42];
    case 8
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:36,53:141,143:186]; % N1 has some drifts during the entire session, and need to be removed in the future
        SubInfo.EmgChn=[193:194];
        SubInfo.TrigChn=[38:42];
    case 9
        SubInfo.Session_num=[1:2];
        SubInfo.UseChn=[1:19,21:37,44:45,48:123];
        SubInfo.EmgChn=[124:125];
        SubInfo.TrigChn=[38:42];
    case 10
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:19,21:33,39:60,63:216];
        SubInfo.EmgChn=[61:62];
        SubInfo.TrigChn=[34:38];
    case 11
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:19,21:35,44:45,48:143,146:151,154:209];
        SubInfo.EmgChn=[216:217];
        SubInfo.TrigChn=[36:40];
    case 12
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:19,21:37,43:44,47:102];
        SubInfo.EmgChn=[109:110];
        SubInfo.TrigChn=[38:42];
    case 13
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:19,21:35,52:119];
        SubInfo.EmgChn=[126:127];
        SubInfo.TrigChn=[44:48];
    case 14
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:17,19:35,44:139];
        SubInfo.EmgChn=[142:143]; % not the correct EMG
        SubInfo.TrigChn=[36:40];
    case 16
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:19,21:37,46:179];
        SubInfo.EmgChn=[186:187];
        SubInfo.TrigChn=[38:42];
    case 17
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:19,21:37,46:153];
        SubInfo.EmgChn=[160:161];
        SubInfo.TrigChn=[38:42];
    case 18
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:19,21:35,52:161];
        SubInfo.EmgChn=[182:183];
        SubInfo.TrigChn=[44:48];
    case 19
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:19,21:37,46:146];
        SubInfo.EmgChn=[153:154];
        SubInfo.TrigChn=[38:42];
    case 20
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:19,21:37,47:48,51:120];
        SubInfo.EmgChn=[127:128];
        SubInfo.TrigChn=[39:43];
    case 21
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:19,21:37,46:47,50:129];
        SubInfo.EmgChn=[136:137];
        SubInfo.TrigChn=[38:42];
    case 22
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:17,19:33,42:159];
        SubInfo.EmgChn=[160:161];
        SubInfo.TrigChn=[34:38];
    case 23
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:16,18:34,43:161,168:213];
        SubInfo.EmgChn=[214:215];
        SubInfo.TrigChn=[35:39];
    case 24
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:14,16:30,47:145];  % miss K5 & A3 ,add two virtual channels for P24, and should be defined as bad channels.
        SubInfo.EmgChn=[146:147];
        SubInfo.TrigChn=[39:43];
    case 25
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:15,17:30,40:146]; % H9 is missing, create one virtual channel H9 for P25
        SubInfo.EmgChn=[147:148];
        SubInfo.TrigChn=[32:36];
    case 26
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:17,19:33,43:163]; % L6 is missing for P26
        SubInfo.EmgChn=[164:165];
        SubInfo.TrigChn=[35:39];

    case 29
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:15,17:29,38:119];
        SubInfo.EmgChn=[120:121];
        SubInfo.TrigChn=[30:34];
    case 30
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:15,17:29,38:103,106:119];
        SubInfo.EmgChn=[120:121];
        SubInfo.TrigChn=[30:34];
    case 31
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:17,19:33,42:81];
        SubInfo.EmgChn=[82:83];
        SubInfo.TrigChn=[34:38];
    case 32
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:19,21:37,46:47,50:67];
        SubInfo.EmgChn=[68:69];
        SubInfo.TrigChn=[38:42];

    case 34
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:15,17:31,43:114];
        SubInfo.EmgChn=[117:118];
        SubInfo.TrigChn=[35:39];
    case 35
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:19,21:31,40:41,44:57,60:87,90:151];
        SubInfo.EmgChn=[88:89];
        SubInfo.TrigChn=[32:36];
    case 36
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:15,17:25,34:126];
        SubInfo.EmgChn=[127:128];
        SubInfo.TrigChn=[26:30];
    case 37
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:15,17:23,32:73];
        SubInfo.EmgChn=[74:75];
        SubInfo.TrigChn=[24:28];

        
    case 41
        SubInfo.Session_num=[1,2];
        SubInfo.UseChn=[1:19,21:37,54:207];
        SubInfo.EmgChn=[210:211];
        SubInfo.TrigChn=[46:50];
    otherwise
        error(strcat("No subject Infor found for sid:",str(subj),'.'))

end

