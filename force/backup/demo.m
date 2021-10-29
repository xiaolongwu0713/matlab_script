%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Original author Shiwei Peng @2018.12.20 @SJTU @pengshiwei123@163.com  %
% This procedure is for Analysis of the force of SEEG signal            %
% Under MATLAB R2016A                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = demo(varargin)
% DEMO MATLAB code for demo.fig
%      DEMO, by itself, creates a new DEMO or raises the existing
%      singleton*.
%
%      H = DEMO returns the handle to a new DEMO or the handle to
%      the existing singleton*.
%
%      DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMO.M with the given input arguments.
%
%      DEMO('Property','Value',...) creates a new DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help demo

% Last Modified by GUIDE v2.5 28-Dec-2020 10:38:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @demo_OpeningFcn, ...
                   'gui_OutputFcn',  @demo_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before demo is made visible.
function demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to demo (see VARARGIN)
addpath(genpath([cd,'/nicebrain']));
addpath(genpath([cd,'/Codes']));
Electrode_Folder=[cd,'/PF6_SYF_2018_08_09_Simply/BrainElectrodes/electrodes_Final_Anatomy_wm.mat']; 
Brain_Model_Folder=[cd,'/PF6_SYF_2018_08_09_Simply/BrainElectrodes/WholeCortex.mat'];
load(Electrode_Folder);
load(Brain_Model_Folder);
load([cd,'/activation_data/MATLAB/Etala.mat']);
mvc=1.4948;
seeg_force=0;
actual_force=0;
error_rate=0;
set(handles.mvc,'String',num2str(mvc));   %�ɱ༭�ı����ʼ�� mvc���������ֵ��
set(handles.seeg_force,'String',num2str(seeg_force));  
set(handles.actual_force,'String',num2str(actual_force)); 
set(handles.bias,'String',num2str(error_rate)); 
set(gcf,'color','w');
% ��ʼ������
global T
T=1;
handles.T=1;
axes(handles.active_brain)
show_activations(handles);
% viewBrain(cortex,Etala,{'brain'}, 1, 50,'top');
% ��ʼ���缫
global val
set(handles.select_side_1,'value',1)
val=get(handles.select_side_1,'value');
axes(handles.show_electrodes_1);
show_electrodes();
set(handles.select_side_2,'value',2)
val=get(handles.select_side_2,'value');
axes(handles.show_electrodes_2);
show_electrodes();
set(handles.select_side_3,'value',3)
val=get(handles.select_side_3,'value');
axes(handles.show_electrodes_3);
show_electrodes();

% Choose default command line output for demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = demo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function protocal_Callback(hObject, eventdata, handles)
    
function protocal_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function start_Callback(hObject, eventdata, handles)
if(get(hObject,'value'))
        isPaused=true;
end
%%%%����ʱ��%%%%%
% time=timer('StartDelay',0,'TimerFcn',@t_TimerFcn,'Period',25,'ExecutionMode','fixedRate');
% start(time);

%%����С��
axes(handles.axes_force);
hBobble1=line('xdata',0,'ydata',1,'marker','o','markerfacecolor','black','markersize',8);
hBobble2=line('xdata',0,'ydata',1,'marker','o','markerfacecolor','yellow','markersize',8);
hold on
% t=0:0.001:15; %1000hz 15s 15000������ ����Ϊ1/1000 ����Ҫ��ά��400hz
% t=0:0.1:15;
% t1=0:0.1:30;
t=0:0.002:(15-0.002);
t1=0:0.002:(60-0.002);

%%%%%% �������ݲ��ж�����һ�ַ�ʽ
%%%%  axes_force ��ʾ��ʽ
% load('order.mat');
order=[1 2 3 4];
    
%��������
load('./demo_data/seeg_data.mat');
axes(handles.axes_emg);h1=animatedline;
axes(handles.axes_seeg_ch09);h2=animatedline;
axes(handles.axes_seeg_ch21);h3=animatedline;
axes(handles.axes_seeg_ch62);h4=animatedline;
axes(handles.axes_seeg_ch69);h5=animatedline;
axes(handles.axes_seeg_ch70);h6=animatedline;
axes(handles.axes_seeg_ch107);h7=animatedline;
%����force����
load('./demo_data/force_data.mat');
%����emg����
load('./demo_data/emg_data.mat');

%%%%% ��С��켣 %%%%%%%
global y1 y2 i m1 T;
nPos=length(t);
% nTime=length(t1);
iTime=1;
iPos=1;
i=1;
j=1; %ʵʱ��ʾactual force
% n=1;
T=2;
handles.T=2;
%delt=1/200000000; %���µ����ڣ��ٶȿ���
while(isPaused && i<=4)
%%%��emg_colormap%%%%
%     if(mod(iPos,500)==0) %ÿ1s����һ��
    axes(handles.EMG_Colormap)
    imagesc(emg_data(:,i));
    colormap(handles.EMG_Colormap,'jet');
    colorbar;
%     end
 
%%%%%ѡ��ʽ
    axes(handles.axes_force)
    flag=order(i);
    select_protocal(flag);
    if(flag==1)
        set(handles.protocal,'string','20% MVC Slow');  
    end
    if(flag==2)
        set(handles.protocal,'string','60% MVC Slow');
    end
    if(flag==3)
        set(handles.protocal,'string','20% MVC Fast');
    end
     if(flag==4)
        set(handles.protocal,'string','60% MVC Fast');
     end
    while(isPaused && iPos~=nPos+1)
    %%%����actual_force%%%%
        set(handles.actual_force,'string',num2str(force_data(j,i)));
    %%%%���öϵ� ����brain activations%%%%
%         if(iTime==0.5*n*nPos && iTime~=nTime) %if(iPos%1000==0)
%             cla(handles.active_brain,'reset');
%             axes(handles.active_brain);
%             show_activations();
%             n=n+1; %ix=ix+1;
%         end
        if(iPos>500 && mod(iPos,100)==0)            
            cla(handles.active_brain);
            axes(handles.active_brain);
            show_activations(handles);
            T=T+1;
            handles.T=handles.T+1;
        end
    %%%%����С��λ��
        axes(handles.axes_force);
    %     hBobble1=line('xdata',0,'ydata',1,'marker','o','markerfacecolor','black','markersize',8);
    %     hBobble2=line('xdata',0,'ydata',1,'marker','o','markerfacecolor','yellow','markersize',8); 
        set(hBobble1,'xdata',t(iPos),'ydata',y1(iPos));
        set(hBobble2,'xdata',t(iPos),'ydata',y2(iPos));
        drawnow;
    %%%%������ʾ%%%%%
        m2=seeg_ch9(:,i);
        m3=seeg_ch21(:,i);
        m4=seeg_ch62(:,i);
        m5=seeg_ch69(:,i);
        m6=seeg_ch70(:,i);
        m7=seeg_ch107(:,i);
        axes(handles.axes_emg);
        addpoints(h1,t1(iPos+(i-1)*nPos),m1(iPos));
        set(gca,'xlim',[15*i-15 15*i]);
        grid on
        axes(handles.axes_seeg_ch09);
        addpoints(h2,t1(iPos+(i-1)*nPos),m2(iPos));
        set(gca,'xlim',[15*i-15 15*i]);
        grid on
        axes(handles.axes_seeg_ch21);
        addpoints(h3,t1(iPos+(i-1)*nPos),m3(iPos));
        set(gca,'xlim',[15*i-15 15*i]);
        grid on
        axes(handles.axes_seeg_ch62);
        addpoints(h4,t1(iPos+(i-1)*nPos),m4(iPos));
        set(gca,'xlim',[15*i-15 15*i]);
        grid on
        axes(handles.axes_seeg_ch69);
        addpoints(h5,t1(iPos+(i-1)*nPos),m5(iPos));
        set(gca,'xlim',[15*i-15 15*i]);
        grid on
        axes(handles.axes_seeg_ch70);
        addpoints(h6,t1(iPos+(i-1)*nPos),m6(iPos));
        set(gca,'xlim',[15*i-15 15*i]);
        grid on
        axes(handles.axes_seeg_ch107);
        addpoints(h7,t1(iPos+(i-1)*nPos),m7(iPos));
        set(gca,'xlim',[15*i-15 15*i]);
        grid on
        %%%%% save data
    %     str=['C:/Users/lenovo/Desktop','data.xls'];
    %     seeg_force=get(handles.seeg_force,'value');
    %     actual_force=get(handles.actual_force,'value');
    %     bias=get(handles.bias,'value');
    %     dataExcel=cell(length(t),3);
    %     dataExcel(iPos,1)={seeg_force};
    %     dataExcel(iPos,2)={actual_force};
    %     dataExcel(iPos,3)={bias};
    %     xlswrite(str,dataExcel);
    %     a=a+0.05;    %�ӵ����ֵ��0.05��Ҫ��t���Ӧ
    %     axis([a a+2*pi -110 110]); %�ƶ�������
        drawnow;
        %pause(delt)
        iPos=iPos+1;
        iTime=iTime+1;
        j=j+1;
    end
        i=i+1;
        iPos=1;
        j=1;
        cla(handles.axes_force,'reset');
        cla(handles.axes_emg,'reset');
        cla(handles.axes_seeg_ch09,'reset');
        cla(handles.axes_seeg_ch21,'reset');
        cla(handles.axes_seeg_ch62,'reset');
        cla(handles.axes_seeg_ch69,'reset');
        cla(handles.axes_seeg_ch70,'reset');
        axes(handles.axes_force);
        hBobble1=line('xdata',0,'ydata',1,'marker','o','markerfacecolor','black','markersize',8);
        hBobble2=line('xdata',0,'ydata',1,'marker','o','markerfacecolor','yellow','markersize',8);
        hold on
        axes(handles.axes_emg);h1=animatedline;
        axes(handles.axes_seeg_ch09);h2=animatedline;
        axes(handles.axes_seeg_ch21);h3=animatedline;
        axes(handles.axes_seeg_ch62);h4=animatedline;
        axes(handles.axes_seeg_ch69);h5=animatedline;
        axes(handles.axes_seeg_ch70);h6=animatedline;
        axes(handles.axes_seeg_ch107);h7=animatedline;
end

% if(i==10)
%     stop(timer);
% end




function pause_Callback(hObject, eventdata, handles)
findall(gcf,'type','axes')
if(get(hObject,'value'))
    uiwait;
else
    uiresume;
end
    

function reset_Callback(hObject, eventdata, handles)
if(get(hObject,'value'))
    cla(handles.axes_force)
    cla(handles.axes_emg)
    cla(handles.axes_seeg_ch09)
    cla(handles.axes_seeg_ch21)
    cla(handles.axes_seeg_ch62)
    cla(handles.axes_seeg_ch69)
    cla(handles.axes_seeg_ch70)
    cla(handles.axes_seeg_ch107)
    cla(handles.active_brain)
    cla(handles.show_electrodes_1)
    cla(handles.show_electrodes_2)
    cla(handles.show_electrodes_3)
    set(handles.protocal,'string',' ');
end

function Show_Activations_Callback(hObject, eventdata, handles)
axes(handles.active_brain);
show_activations(handles);

function active_brain_CreateFcn(hObject, eventdata, handles)
set(hObject,'xTick',[]);
set(hObject,'ytick',[]);
set(hObject,'box','on');
set(get(hObject,'title'),'string','Active  Brain');

function show_electrodes_1_CreateFcn(hObject, eventdata, handles)
set(hObject,'xTick',[]);
set(hObject,'ytick',[]);
set(hObject,'box','on');
set(get(hObject,'title'),'string','  ');

function show_electrodes_2_CreateFcn(hObject, eventdata, handles)
set(get(hObject,'title'),'string','  ');

function show_electrodes_3_CreateFcn(hObject, eventdata, handles)
set(get(hObject,'title'),'string','  ');

function select_side_1_Callback(hObject, eventdata, handles)
cla(handles.show_electrodes_1)
global val
val=get(hObject,'value');
axes(handles.show_electrodes_1);
show_electrodes();



function select_side_1_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function select_side_2_Callback(hObject, eventdata, handles)
cla(handles.show_electrodes_2)
global val
val=get(hObject,'value');
axes(handles.show_electrodes_2);
show_electrodes();

function select_side_2_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function select_side_3_Callback(hObject, eventdata, handles)
cla(handles.show_electrodes_3)
global val;
val=get(hObject,'value');
axes(handles.show_electrodes_3);
show_electrodes();

function select_side_3_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function actual_force_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function mvc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function seeg_force_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function bias_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function save_data_Callback(hObject, eventdata, handles)
% [fName,pName,index]=uiputfile('*.xls','���Ϊ');
% if index && strcmp(fName(end-3:end),'.xls')
    str=[cd,'/DataRecords/data.xls'];
%     for t=0:0.001:15
        seeg_force=get(handles.seeg_force,'value');
        actual_force=get(handles.actual_force,'value');
        bias=get(handles.bias,'value');
        dataExcel=cell(length(t),3);
        dataExcel(iPos,1)={seeg_force};
        dataExcel(iPos,2)={actual_force};
        dataExcel(iPos,3)={bias};
        xlswrite(str,dataExcel);
%     end
% end


function show_colormap_Callback(hObject, eventdata, handles)


function EMG_Colormap_CreateFcn(hObject, eventdata, handles)
% set(hObject,'xTick',[]);
% set(hObject,'ytick',[]);
set(hObject,'box','on');
set(get(hObject,'title'),'string','EMG  Colormap');



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text17.
function text17_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over edit11.
function edit11_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
