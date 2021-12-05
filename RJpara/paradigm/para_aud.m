clear all;clc;
KbName('UnifyKeyNames');
Screen('Preference','SkipSyncTests',0);


%%---------------------------------------------------------------------------------------------------%% 
%  Collect subject's information.
Sub.inf=inputdlg({'Name','Age','Gender','Left-handed or Right-handed Experiments','Paradigm Types','Start Time'},...
                     'Subject Information',1,{'Name()','Age','Gender','Right or Left','ParadigmTypes','HH:MM:SS'});
Sub.Name=Sub.inf(1);
Sub.StartTime=Sub.inf(6);
%Sub=cell2struct(Sub.inf,{'Name'},1);


%%---------------------------------------------------------------------------------------------------%%
[w,rect]=Screen('OpenWindow',0,[0 0 0]);
[xc,yc]=RectCenter(rect);
slack=Screen('GetFlipInterval',w)/2;
HideCursor;
Screen('Screens');


[Au1,Fs1]=audioread('D:/ScissorMI_01.mp3');
[Au2,Fs2]=audioread('D:/ScissorME_01.mp3');
[Au3,Fs3]=audioread('D:/RockMI_01.mp3');
[Au4,Fs4]=audioread('D:/RockME_01.mp3');
[Au5,Fs5]=audioread('D:/PaperMI_01.mp3');
[Au6,Fs6]=audioread('D:/PaperME_01.mp3');
[Au7,Fs7]=audioread('D:/pleasestart_01.mp3');

pattern_Au={Au1,Au2,Au3,Au4,Au5,Au6};
pattern_Fs={Fs1 Fs2 Fs3 Fs4 Fs5 Fs6};
%%---------------------------------------------------------------------------------------------------%%

%  Remind subject to prepare.
text='Press a Key When You Are Ready!';
Screen('TextSize', w ,60);
width=RectWidth(Screen('TextBounds',w,text));
Screen('Drawtext',w,text,xc-width/2,yc,[255 255 255]);
Screen('Flip',w);
KbWait;

repeattimes=1;
patternlist=1:length(pattern_Au);
patternlist=repmat(patternlist,1,repeattimes);
randomlist=Shuffle(patternlist);

Priority(2);
for i=1:length(randomlist) 

%  Resting state, showing cross.
    Screen('DrawLine',w,[255 255 255],xc-300,yc,xc+300,yc,10);
    Screen('DrawLine',w,[255 255 255],xc,yc-300 ,xc,yc+300,10);
%     tic;
    trest_onset=Screen('Flip',w);
%     WaitSecs(2.5);
    
%  auditory cues appear randomly.  
    Screen('FillRect',w,[0 0 0]);
    tcue_onset=Screen('Flip',w,trest_onset+2.5-slack);
    sound(pattern_Au{randomlist(i)},pattern_Fs{randomlist(i)});   
%%---------------------------------------------------------------------------------------------------%%   
%     obj = serial('COM?');       % 
%     fopen(obj);                 %
%     
%     if randomlist(i)==1
%         fwrite(obj,'xxx'); 
%     elseif randomlist(i)==2
%         fwrite(obj,'xxx'); 
%     elseif randomlist(i)==3
%         fwrite(obj,'xxx'); 
%     elseif randomlist(i)==4
%         fwrite(obj,'xxx'); 
%     elseif randomlist(i)==5
%         fwrite(obj,'xxx'); 
%     elseif randomlist(i)==6
%         fwrite(obj,'xxx');
%     end
%%---------------------------------------------------------------------------------------------------%%   

  
%     WaitSecs(0.8);

%  500ms~1500ms random delay.
    r=0.5+rand;
    Screen('FillRect',w,[0 0 0]);
    twait_onset=Screen('Flip',w,tcue_onset+0.8-slack);
%     WaitSecs(r);
    
%  Voice Tip: Start MI/ME.
 
    Screen('FillRect',w,[0 0 0]);
    tstart_onset=Screen('Flip',w, twait_onset+r-slack);
%     tic;
    sound(Au7,Fs7);
   

%  MI/ME
    Screen('FillRect',w,[0 0 0]);
    Screen('Flip',w,tstart_onset+0.8-slack);
    WaitSecs(3);
%     disp(['toc计算第',num2str(i),'次循环运行时间：',num2str(toc)]);
    
end
Priority(0);

%  Record the end time of trial.
Sub.EndTime=datestr(now,13);
InfFileName=strcat('D:\Result\',Sub.Name,'_auditory');
InfFileName=InfFileName{1};

%  Prevent overwriting generated files by forgetting to change information
%  at the beginning of the trial.
if exist(InfFileName,'dir')
    dig=isstrprop(InfFileName,'digit');
    if isempty(InfFileName(dig))
        InfFileName=strcat('D:\Result\',Sub.Name,'(',num2str(1),')','_auditory');
        InfFileName=InfFileName{1};
    else
        InfFileName=strcat('D:\Result\',Sub.Name,'(',num2str(str2double(InfFileName(dig))+1),')','_auditory');
        InfFileName=InfFileName{1};
    end
end

%Save information.
mkdir(InfFileName);
strname=strcat(InfFileName,'\inf.mat');
save(strname,'Sub');

Screen('CloseAll');
ShowCursor;

questdlg('Experiment Finished!');