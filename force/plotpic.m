function varargout = plotpic(varargin)
% PLOTPIC MATLAB code for plotpic.fig
%      PLOTPIC, by itself, creates a new PLOTPIC or raises the existing
%      singleton*.
%
%      H = PLOTPIC returns the handle to a new PLOTPIC or the handle to
%      the existing singleton*.
%
%      PLOTPIC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOTPIC.M with the given input arguments.
%
%      PLOTPIC('Property','Value',...) creates a new PLOTPIC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plotpic_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plotpic_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help plotpic

% Last Modified by GUIDE v2.5 09-Jan-2021 21:41:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @plotpic_OpeningFcn, ...
                   'gui_OutputFcn',  @plotpic_OutputFcn, ...
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


% --- Executes just before plotpic is made visible.
function plotpic_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plotpic (see VARARGIN)

handles.session=1;
handles.trial=1;
handles.channel=4;
handles.fs=1000;
handles.pathname='/Users/long/BCI/matlab_scripts/force/data/cwt/plot/';
filename=strcat(handles.pathname,num2str(handles.session),'-',num2str(handles.trial),'-',num2str(handles.channel),'.jpg');
i=imread(filename);
imshow(i);

set(handles.sessionT,'String',handles.session);
set(handles.trialT,'String',handles.trial);
set(handles.channelT,'String',handles.channel);
% Choose default command line output for plotpic
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plotpic wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = plotpic_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in previous.
function previous_Callback(hObject, eventdata, handles)
% hObject    handle to previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(0, 'CurrentFigure', handles.ff);
handles.channel=handles.channel-1;
filename=strcat(handles.pathname,num2str(handles.session),'-',num2str(handles.trial),'-',num2str(handles.channel),'.jpg');
i=imread(filename);
imshow(i);

set(handles.sessionT,'String',handles.session);
set(handles.trialT,'String',handles.trial);
set(handles.channelT,'String',handles.channel);

guidata(hObject, handles);

% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.channel=handles.channel+1;
filename=strcat(handles.pathname,num2str(handles.session),'-',num2str(handles.trial),'-',num2str(handles.channel),'.jpg');
i=imread(filename);
imshow(i);


set(handles.sessionT,'String',handles.session);
set(handles.trialT,'String',handles.trial);
set(handles.channelT,'String',handles.channel);

handles.output = hObject;
guidata(hObject, handles);

function sessionT_Callback(hObject, eventdata, handles)
% hObject    handle to sessionT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sessionT as text
%        str2double(get(hObject,'String')) returns contents of sessionT as a double


% --- Executes during object creation, after setting all properties.
function sessionT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sessionT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trialT_Callback(hObject, eventdata, handles)
% hObject    handle to trialT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trialT as text
%        str2double(get(hObject,'String')) returns contents of trialT as a double


% --- Executes during object creation, after setting all properties.
function trialT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trialT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function channelT_Callback(hObject, eventdata, handles)
% hObject    handle to channelT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of channelT as text
%        str2double(get(hObject,'String')) returns contents of channelT as a double


% --- Executes during object creation, after setting all properties.
function channelT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.session = str2num(get(handles.sessionT,'string'));
handles.trial = str2num(get(handles.trialT,'string'));
handles.channel = str2num(get(handles.channelT,'string'));

filename=strcat(handles.pathname,num2str(handles.session),'-',num2str(handles.trial),'-',num2str(handles.channel),'.jpg');
i=imread(filename);
imshow(i);

set(handles.infoT,'String',tt);
set(handles.sessionT,'String',handles.session);
set(handles.trialT,'String',handles.trial);
set(handles.channelT,'String',handles.channel);

guidata(hObject, handles);



function infoT_Callback(hObject, eventdata, handles)
% hObject    handle to infoT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of infoT as text
%        str2double(get(hObject,'String')) returns contents of infoT as a double


% --- Executes during object creation, after setting all properties.
function infoT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to infoT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
