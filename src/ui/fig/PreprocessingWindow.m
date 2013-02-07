function varargout = PreprocessingWindow(varargin)
% PREPROCESSINGWINDOW MATLAB code for PreprocessingWindow.fig
%      PREPROCESSINGWINDOW, by itself, creates a new PREPROCESSINGWINDOW or raises the existing
%      singleton*.
%
%      H = PREPROCESSINGWINDOW returns the handle to a new PREPROCESSINGWINDOW or the handle to
%      the existing singleton*.
%
%      PREPROCESSINGWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREPROCESSINGWINDOW.M with the given input arguments.
%
%      PREPROCESSINGWINDOW('Property','Value',...) creates a new PREPROCESSINGWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PreprocessingWindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PreprocessingWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PreprocessingWindow

% Last Modified by GUIDE v2.5 07-Feb-2013 11:05:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PreprocessingWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @PreprocessingWindow_OutputFcn, ...
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


% --- Executes just before PreprocessingWindow is made visible.
function PreprocessingWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PreprocessingWindow (see VARARGIN)

% Choose default command line output for PreprocessingWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PreprocessingWindow wait for user response (see UIRESUME)
% uiwait(handles.PreprocessingWindow);


% --- Outputs from this function are returned to the command line.
function varargout = PreprocessingWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in SpikeRateWindowTypeListbox.
function SpikeRateWindowTypeListbox_Callback(hObject, eventdata, handles)
% hObject    handle to SpikeRateWindowTypeListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SpikeRateWindowTypeListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SpikeRateWindowTypeListbox


% --- Executes during object creation, after setting all properties.
function SpikeRateWindowTypeListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SpikeRateWindowTypeListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SelectFileButton.
function SelectFileButton_Callback(hObject, eventdata, handles)
% hObject    handle to SelectFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function CellPatternEdit_Callback(hObject, eventdata, handles)
% hObject    handle to CellPatternEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CellPatternEdit as text
%        str2double(get(hObject,'String')) returns contents of CellPatternEdit as a double


% --- Executes during object creation, after setting all properties.
function CellPatternEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CellPatternEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SplineTypeListbox.
function SplineTypeListbox_Callback(hObject, eventdata, handles)
% hObject    handle to SplineTypeListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SplineTypeListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SplineTypeListbox


% --- Executes during object creation, after setting all properties.
function SplineTypeListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SplineTypeListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in VariableOfInterestListbox.
function VariableOfInterestListbox_Callback(hObject, eventdata, handles)
% hObject    handle to VariableOfInterestListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns VariableOfInterestListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from VariableOfInterestListbox


% --- Executes during object creation, after setting all properties.
function VariableOfInterestListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VariableOfInterestListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NumberOfBinsEdit_Callback(hObject, eventdata, handles)
% hObject    handle to NumberOfBinsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumberOfBinsEdit as text
%        str2double(get(hObject,'String')) returns contents of NumberOfBinsEdit as a double


% --- Executes during object creation, after setting all properties.
function NumberOfBinsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumberOfBinsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BinSpacingEdit_Callback(hObject, eventdata, handles)
% hObject    handle to BinSpacingEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BinSpacingEdit as text
%        str2double(get(hObject,'String')) returns contents of BinSpacingEdit as a double


% --- Executes during object creation, after setting all properties.
function BinSpacingEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BinSpacingEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NegativeLagEdit_Callback(hObject, eventdata, handles)
% hObject    handle to NegativeLagEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NegativeLagEdit as text
%        str2double(get(hObject,'String')) returns contents of NegativeLagEdit as a double


% --- Executes during object creation, after setting all properties.
function NegativeLagEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NegativeLagEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PositiveLagEdit_Callback(hObject, eventdata, handles)
% hObject    handle to PositiveLagEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PositiveLagEdit as text
%        str2double(get(hObject,'String')) returns contents of PositiveLagEdit as a double


% --- Executes during object creation, after setting all properties.
function PositiveLagEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PositiveLagEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RunPreprocessingButton.
function RunPreprocessingButton_Callback(hObject, eventdata, handles)
% hObject    handle to RunPreprocessingButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in CellsToAnalyzeListbox.
function CellsToAnalyzeListbox_Callback(hObject, eventdata, handles)
% hObject    handle to CellsToAnalyzeListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CellsToAnalyzeListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CellsToAnalyzeListbox


% --- Executes during object creation, after setting all properties.
function CellsToAnalyzeListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CellsToAnalyzeListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
