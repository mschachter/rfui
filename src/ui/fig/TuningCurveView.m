function varargout = TuningCurveView(varargin)
% TUNINGCURVEVIEW MATLAB code for TuningCurveView.fig
%      TUNINGCURVEVIEW, by itself, creates a new TUNINGCURVEVIEW or raises the existing
%      singleton*.
%
%      H = TUNINGCURVEVIEW returns the handle to a new TUNINGCURVEVIEW or the handle to
%      the existing singleton*.
%
%      TUNINGCURVEVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TUNINGCURVEVIEW.M with the given input arguments.
%
%      TUNINGCURVEVIEW('Property','Value',...) creates a new TUNINGCURVEVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TuningCurveView_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TuningCurveView_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TuningCurveView

% Last Modified by GUIDE v2.5 14-Feb-2013 11:18:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TuningCurveView_OpeningFcn, ...
                   'gui_OutputFcn',  @TuningCurveView_OutputFcn, ...
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


% --- Executes just before TuningCurveView is made visible.
function TuningCurveView_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TuningCurveView (see VARARGIN)

% Choose default command line output for TuningCurveView
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TuningCurveView wait for user response (see UIRESUME)
% uiwait(handles.TuningCurveView);


% --- Outputs from this function are returned to the command line.
function varargout = TuningCurveView_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function CellNumberEdit_Callback(hObject, eventdata, handles)
% hObject    handle to CellNumberEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CellNumberEdit as text
%        str2double(get(hObject,'String')) returns contents of CellNumberEdit as a double


% --- Executes during object creation, after setting all properties.
function CellNumberEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CellNumberEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PreviousCellButton.
function PreviousCellButton_Callback(hObject, eventdata, handles)
% hObject    handle to PreviousCellButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in NextCellButton.
function NextCellButton_Callback(hObject, eventdata, handles)
% hObject    handle to NextCellButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
