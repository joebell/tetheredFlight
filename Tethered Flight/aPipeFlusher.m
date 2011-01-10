function varargout = aPipeFlusher(varargin)
% APIPEFLUSHER M-file for aPipeFlusher.fig
%      APIPEFLUSHER, by itself, creates a new APIPEFLUSHER or raises the existing
%      singleton*.
%
%      H = APIPEFLUSHER returns the handle to a new APIPEFLUSHER or the handle to
%      the existing singleton*.
%
%      APIPEFLUSHER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in APIPEFLUSHER.M with the given input arguments.
%
%      APIPEFLUSHER('Property','Value',...) creates a new APIPEFLUSHER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before aPipeFlusher_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to aPipeFlusher_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help aPipeFlusher

% Last Modified by GUIDE v2.5 14-Sep-2010 13:11:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @aPipeFlusher_OpeningFcn, ...
                   'gui_OutputFcn',  @aPipeFlusher_OutputFcn, ...
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


% --- Executes just before aPipeFlusher is made visible.
function aPipeFlusher_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to aPipeFlusher (see VARARGIN)

% Choose default command line output for aPipeFlusher
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes aPipeFlusher wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = aPipeFlusher_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global running;
    global myTimer;
    
    disp(' ');
    disp('--------------------------');
    disp('    Flushing pipes...     ');
    disp('--------------------------');
    disp(' ');
    ardSetColors(1,0);
    ardDispOn;
    
    running = true;
    myTimer = timer('ExecutionMode','singleShot','StartDelay',5,...
        'TimerFcn',{'flushTimerCallback',handles, 0});
    start(myTimer);


    


% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global running;
    global myTimer;
    global ardVar;
    global USB;
    global daqParams;
    
    if (running)
        running = false;
        disp('Stopping pipe flush...');
        wait(myTimer);
        ardWriteParam(ardVar.Olf1Armed, '0000');
        ardWriteParam(ardVar.Olf2Armed, '0000');
        ardWriteParam(ardVar.Olf3Armed, '0000');
        ardFlip;
        ardSetColors(0,1);
        ardDispOff;
        disp('Pipe flush stopped.');
    end

function repsText_Callback(hObject, eventdata, handles)
% hObject    handle to repsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of repsText as text
%        str2double(get(hObject,'String')) returns contents of repsText as a double


% --- Executes during object creation, after setting all properties.
function repsText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to repsText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
