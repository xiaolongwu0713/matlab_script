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
slack=Screen('GetFlipInterval',w)/2;
[xc,yc]=RectCenter(rect);
HideCursor;
Screen('Screens');
%%---------------------------------------------------------------------------------------------------%%
% Preloading functions and variables through a pseudo-trial.
% Screen('DrawLine',w,[255 255 255],xc-300,yc,xc+300,yc,10);
% Screen('FillRect',w,[0 0 0]);
% Screen('FillOval',w,[0 255 0],[xc-100,yc-100,xc+100,yc+100]);
% % N1_parametersSetting;   %??
% WaitSecs;
% Screen('FillRect',w,[0 0 0]);
% Screen('Flip',w);
%%---------------------------------------------------------------------------------------------------%%
% imageplus=imread('D:/plus.jpg');
% imageplus_text=Screen('MakeTexture',w,imageplus);

image1=imread('D:/scissor_2','jpg');
image2=imread('D:/rock_2','jpg');
image3=imread('D:/paper_2','jpg');
image4=imread('D:/scissor_2','jpg');
image5=imread('D:/rock_2','jpg');
image6=imread('D:/paper_2','jpg');
image_text1=Screen('MakeTexture',w,image1);
image_text2=Screen('MakeTexture',w,image2);
image_text3=Screen('MakeTexture',w,image3);
image_text4=Screen('MakeTexture',w,image4);
image_text5=Screen('MakeTexture',w,image5);
image_text6=Screen('MakeTexture',w,image6);
pattern=[image_text1 image_text2 image_text3 image_text4 image_text5 image_text6];

%  Remind subject to prepare.
text='Press a Key When You Are Ready!';
Screen('TextSize', w ,60);
width=RectWidth(Screen('TextBounds',w,text));
Screen('Drawtext',w,text,xc-width/2,yc,[255 255 255]);
Screen('Flip',w);
KbWait;


repeattimes=1;
patternlist=1:length(pattern);
patternlist=repmat(patternlist,1,repeattimes);
randomlist=Shuffle(patternlist);

Priority(2);
for i=1:length(randomlist) 

%     Screen('DrawTexture',w,imageplus_text);

%  Resting state, showing cross.
    Screen('DrawLine',w,[255 255 255],xc-300,yc,xc+300,yc,10);
    Screen('DrawLine',w,[255 255 255],xc,yc-300 ,xc,yc+300,10);
%     tic;
    trest_onset=Screen('Flip',w);
%     WaitSecs(2.5);
    
%  Visual cues appear randomly, in which motion execution is framed, and motion imagination is not framed.  
    Screen('DrawTexture',w,pattern(randomlist(i)));
    if randomlist(i)==4||randomlist(i)==5||randomlist(i)==6
        Screen('DrawLine',w,[255 255 255],xc-350,yc+350,xc+350,yc+350,6);
        Screen('DrawLine',w,[255 255 255],xc-350,yc-350 ,xc+350,yc-350,6);
        Screen('DrawLine',w,[255 255 255],xc-350,yc+350,xc-350,yc-350,6);
        Screen('DrawLine',w,[255 255 255],xc+350,yc+350 ,xc+350,yc-350,6);
    end
    
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
    tcue_onset=Screen('Flip',w,trest_onset+2.5-slack);
%     WaitSecs(0.4);

%  500ms~1500ms random delay.
    r=0.5+rand;
    Screen('FillRect',w,[0 0 0]);
    twait_onset=Screen('Flip',w,tcue_onset+0.4-slack);
%     WaitSecs(r);
    
%  Green Point Tip: Start MI/ME.
    Screen('FillOval',w,[0 255 0],[xc-100,yc-100,xc+100,yc+100]);
    tstart_onset=Screen('Flip',w, twait_onset+r-slack);
%     WaitSecs(0.1);

%  MI/ME
%     tic;
    Screen('FillRect',w,[0 0 0]);
    Screen('Flip',w,tstart_onset+0.1-slack);
    WaitSecs(3);
%     disp(['toc计算第',num2str(i),'次循环运行时间：',num2str(toc-r)]);
end
Priority(0);

%  Record the end time of trial.
Sub.EndTime=datestr(now,13);
InfFileName=strcat('D:\Result\',Sub.Name,'_visual');
InfFileName=InfFileName{1};

%  Prevent overwriting generated files by forgetting to change information
%  at the beginning of the trial.
if exist(InfFileName,'dir')
    dig=isstrprop(InfFileName,'digit');
    if isempty(InfFileName(dig))
        InfFileName=strcat('D:\Result\',Sub.Name,'(',num2str(1),')','_visual');
        InfFileName=InfFileName{1};
    else
        InfFileName=strcat('D:\Result\',Sub.Name,'(',num2str(str2double(InfFileName(dig))+1),')','_visual');
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

    
    
    
