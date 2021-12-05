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


%%---------------------------------------------------------------------------------------------------%%
rkey1=KbName('UpArrow');
rkey2=KbName('RightArrow');
rkeyorder=[rkey1 rkey2];

image1=imread('D:/arrow_up','jpg');
image2=imread('D:/arrow_right','jpg');
image_text1=Screen('MakeTexture',w,image1);
image_text2=Screen('MakeTexture',w,image2);
arroworder=[image_text1 image_text2];

text1='Go';
text2='No Go';
textorder={text1,text2};

ntrial=10;
trialn=[ones(1,ntrial*0.7) ones(1,ntrial*0.3)+1];
trialrandom1=trialn(randperm(ntrial));
trialrandom2=trialn(randperm(ntrial));
accuracy=zeros(ntrial,2);
rtime=zeros(ntrial,2);


%  Remind subject to prepare.
text='Press a Key When You Are Ready!';
Screen('TextSize', w ,60);
width=RectWidth(Screen('TextBounds',w,text));
Screen('Drawtext',w,text,xc-width/2,yc,[255 255 255]);
Screen('Flip',w);
KbWait;

%%---------------------------------------------------------------------------------------------------%%
Priority(2);
for i=1:ntrial
 %检查所有按键都已经被释放   
    KeyIsDown=1;
    while KeyIsDown
         [KeyIsDown,~,~]=KbCheck;
         WaitSecs(0.001);
    end
 % 在屏幕上出现随机↑ →       
    Screen('FillOval',w,[0 255 0],[xc-50,yc-50,xc+50,yc+50]);
    arrowsel=randperm(2);
    Screen('DrawTexture',w,arroworder(arrowsel(1)));
    subjst_onset=Screen('Flip',w);
    
    Screen('DrawTexture',w,arroworder(arrowsel(2)));
    subjnd_onset=Screen('Flip',w,subjst_onset+0.5-slack);  %此处的0.5是第一个方向的显示时间
    
    Screen('FillRect',w,[0 0 0]);
    Screen('Flip',w,subjnd_onset+0.5-slack);  %此处的0.5是第二个方向的显示时间
    WaitSecs(rand*0.3);  %0~300ms随机延时
    
    Screen('TextSize', w ,100);
    width=RectWidth(Screen('TextBounds',w,textorder{trialrandom1(i)}));
    Screen('Drawtext',w,textorder{trialrandom1(i)},xc-width/2,yc,[255 255 255]);
    
    tipst_onset=Screen('Flip',w);
    WaitSecs(0.5);  %此处的0.5是第一个提示的持续时间***0.5→2
    
    keyisdown1=0;
    real_time=GetSecs;
    while ~keyisdown1  && (real_time- tipst_onset)<2   %用 (real_time- tipst_onset)<2 来控制反应时限*** 2→5
        [keyisdown1,seconds1,keycode1]=KbCheck;
        real_time=GetSecs;
    end
    
    
     if keyisdown1==1
        if keycode1(rkeyorder(arrowsel(1))) && trialrandom1(i)==1
            
            rtime(i,1)=seconds1-tipst_onset;
            accuracy(i,1)=1;
            feedback1='True';
        else
            rtime(i,1)=seconds1-tipst_onset;
            feedback1='False';
        end
    else
        if trialrandom1(i)==2
            rtime(i,1)= real_time-tipst_onset;
            accuracy(i,1)=1;
            feedback1='True';
        else
            rtime(i,1)= real_time-tipst_onset;
            feedback1='False';
        end
    end
    
%     Screen('TextSize', w ,100);
    Screen('FillRect',w,[0 0 0]);
    Screen('Flip',w);
    width=RectWidth(Screen('TextBounds',w,textorder{trialrandom2(i)}));
    Screen('Drawtext',w,textorder{trialrandom2(i)},xc-width/2,yc,[255 255 255]);
    tipnd_onset=Screen('Flip',w,tipst_onset+ rtime(i,1)+0.5+rand*0.3-slack);    %两个移动指令之间的随机延时
    WaitSecs(0.5);   %此处的0.5是第二个提示的持续时间*** 0.5→2
    
    keyisdown2=0;
    real_time=GetSecs;
    while ~keyisdown2  && (real_time- tipnd_onset)<2   %用 (real_time- tipst_onset)<2 来控制反应时限*** 2→5
        [keyisdown2,seconds2,keycode2]=KbCheck;
        real_time=GetSecs;
    end
    
    if keyisdown2==1
        if keycode2(rkeyorder(arrowsel(2)))&& trialrandom2(i)==1
            
            rtime(i,2)=seconds2-tipnd_onset;
            accuracy(i,2)=1;
            feedback2='True';
        else
            rtime(i,2)=seconds2-tipnd_onset;
            feedback2='False';
        end
    else
        if trialrandom2(i)==2
            rtime(i,2)= real_time-tipnd_onset;
            accuracy(i,2)=1;
            feedback2='True';
        else
            rtime(i,2)= real_time-tipnd_onset;
            feedback2='False';
        end
    end
    
    Screen('FillRect',w,[0 0 0]);
    Screen('Flip',w);
    text=strcat(feedback1,'\',feedback2);
    width=RectWidth(Screen('TextBounds',w,text));
    Screen('Drawtext',w,text,xc-width/2,yc,[255 255 255]);
    Screen('Flip',w,tipnd_onset+ rtime(i,2)+0.5-slack);
    WaitSecs(0.5);    %最后结果显示的持续时间
    
end
Priority(0);
%%---------------------------------------------------------------------------------------------------%%
%  Record the end time of trial.
Sub.EndTime=datestr(now,13);
InfFileName=strcat('D:\Result\',Sub.Name,'_gonogo');
InfFileName=InfFileName{1};

%  Prevent overwriting generated files by forgetting to change information
%  at the beginning of the trial.
if exist(InfFileName,'dir')
    dig=isstrprop(InfFileName,'digit');
    if isempty(InfFileName(dig))
        InfFileName=strcat('D:\Result\',Sub.Name,'(',num2str(1),')','_gonogo');
        InfFileName=InfFileName{1};
    else
        InfFileName=strcat('D:\Result\',Sub.Name,'(',num2str(str2double(InfFileName(dig))+1),')','_gonogo');
        InfFileName=InfFileName{1};
    end
end

%Save information.
mkdir(InfFileName);
strname=strcat(InfFileName,'\inf.mat');
save(strname,'Sub','accuracy','rtime');
%%---------------------------------------------------------------------------------------------------%%


Screen('CloseAll');
ShowCursor;

questdlg('Experiment Finished!');



