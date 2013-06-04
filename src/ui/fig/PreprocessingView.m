function varargout = PreprocessingView(varargin)
% PREPROCESSINGVIEW MATLAB code for PreprocessingView.fig
%      PREPROCESSINGVIEW, by itself, creates a new PREPROCESSINGVIEW or raises the existing
%      singleton*.
%
%      H = PREPROCESSINGVIEW returns the handle to a new PREPROCESSINGVIEW or the handle to
%      the existing singleton*.
%
%      PREPROCESSINGVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREPROCESSINGVIEW.M with the given input arguments.
%
%      PREPROCESSINGVIEW('Property','Value',...) creates a new PREPROCESSINGVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PreprocessingView_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PreprocessingView_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PreprocessingView

% Last Modified by GUIDE v2.5 21-May-2013 10:44:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PreprocessingView_OpeningFcn, ...
                   'gui_OutputFcn',  @PreprocessingView_OutputFcn, ...
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

% --- Executes just before PreprocessingView is made visible.
function PreprocessingView_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PreprocessingView (see VARARGIN)

% Choose default command line output for PreprocessingView
handles.output = hObject;

% set RFUI model and controllers
mvcModel = PreprocessingModel();
handles.mvcModel = mvcModel;

mvcController = PreprocessingController();
handles.mvcController = mvcController;
mvcController.updateView(handles, mvcModel);

guidata(hObject, handles);

% UIWAIT makes PreprocessingView wait for user response (see UIRESUME)
% uiwait(handles.PreprocessingView);


% --- Outputs from this function are returned to the command line.
function varargout = PreprocessingView_OutputFcn(hObject, eventdata, handles) 
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
mvcModel = handles.mvcModel;
contents = cellstr(get(hObject,'String'));
mvcModel.spikeRateWindowType = contents{get(hObject,'Value')};

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

mvcModel = handles.mvcModel;
if exist('pathinfo.mat', 'file')
  lastPath = load('pathinfo.mat');
  lastPath = lastPath.lastPath;  
  if isnumeric(lastPath) || ~exist(lastPath, 'dir')
      lastPath = getuserdir();
  end
  [ifile,ipath] = uigetfile('*.*', 'Select an input file',lastPath);
else
  [ifile,ipath] = uigetfile('*.*', 'Select an input file');
end

if ~isnumeric(ifile)
    lastPath = ipath;
    save('pathinfo.mat','lastPath');
    mvcModel.inputFile = fullfile(ipath, ifile);
    [iipath,filename,fileext] = fileparts(ifile);
    set(handles.SelectFileText, 'String', [filename fileext]);
    
    outputDir = fullfile(lastPath, 'output');    
    [status,message,messageid] = mkdir(outputDir);
    set(handles.OutputDirectoryEdit, 'String', outputDir);
    mvcModel.outputDirectory = outputDir;
end


function CellPatternEdit_Callback(hObject, eventdata, handles)
% hObject    handle to CellPatternEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CellPatternEdit as text
%        str2double(get(hObject,'String')) returns contents of CellPatternEdit as a double
mvcModel = handles.mvcModel;
mvcModel.cellPattern = get(hObject, 'String');
set(hObject, 'String', mvcModel.cellPattern);


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


% --- Executes on selection change in VariableOfInterestListbox.
function VariableOfInterestListbox_Callback(hObject, eventdata, handles)
% hObject    handle to VariableOfInterestListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns VariableOfInterestListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from VariableOfInterestListbox
mvcModel = handles.mvcModel;
contents = cellstr(get(hObject,'String'));
mvcModel.variableOfInterest = contents{get(hObject,'Value')};


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
mvcModel = handles.mvcModel;
mvcModel.variableNumberOfBins = str2double(get(hObject,'String'));
set(hObject, 'String', mvcModel.variableNumberOfBins);


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
mvcModel = handles.mvcModel;
mvcModel.heatmapBinSpacing = str2double(get(hObject,'String'));
set(hObject, 'String', mvcModel.heatmapBinSpacing);

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



function NumberOfLagsEdit_Callback(hObject, eventdata, handles)
% hObject    handle to NumberOfLagsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumberOfLagsEdit as text
%        str2double(get(hObject,'String')) returns contents of NumberOfLagsEdit as a double
mvcModel = handles.mvcModel;
mvcModel.heatmapNumberOfLags = str2double(get(hObject,'String'));
set(hObject, 'String', mvcModel.heatmapNumberOfLags);

% --- Executes during object creation, after setting all properties.
function NumberOfLagsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumberOfLagsEdit (see GCBO)
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
mvcModel = handles.mvcModel;
mvcModel.heatmapPositiveLag = str2double(get(hObject,'String'));
set(hObject, 'String', mvcModel.heatmapPositiveLag);

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
mvcModel = handles.mvcModel;
mvcController = handles.mvcController;
mvcController.runPreprocessing(handles, mvcModel);


% --- Executes on selection change in CellsToAnalyzeListbox.
function CellsToAnalyzeListbox_Callback(hObject, eventdata, handles)
% hObject    handle to CellsToAnalyzeListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns CellsToAnalyzeListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from CellsToAnalyzeListbox
mvcModel = handles.mvcModel;
mvcController = handles.mvcController;
mvcModel.selectedCells = get(hObject,'Value');


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



function SpikeRateWindowSizeEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SpikeRateWindowSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SpikeRateWindowSizeEdit as text
%        str2double(get(hObject,'String')) returns contents of SpikeRateWindowSizeEdit as a double
mvcModel = handles.mvcModel;
mvcModel.spikeRateWindowSize = str2double(get(hObject, 'String'));
set(hObject, 'String', mvcModel.spikeRateWindowSize);


% --- Executes during object creation, after setting all properties.
function SpikeRateWindowSizeEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SpikeRateWindowSizeEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SplineOrderEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SplineOrderEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SplineOrderEdit as text
%        str2double(get(hObject,'String')) returns contents of SplineOrderEdit as a double
mvcModel = handles.mvcModel;
mvcModel.splineOrder = str2double(get(hObject,'String'));
set(hObject, 'String', mvcModel.splineOrder);

% --- Executes during object creation, after setting all properties.
function SplineOrderEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SplineOrderEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in InputFileLoadButton.
function InputFileLoadButton_Callback(hObject, eventdata, handles)
% hObject    handle to InputFileLoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mvcController = handles.mvcController;
mvcModel = handles.mvcModel;
mvcController.loadExpData(mvcModel);
mvcController.updateView(handles, mvcModel);



function SplineNumberOfKnotsEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SplineNumberOfKnotsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SplineNumberOfKnotsEdit as text
%        str2double(get(hObject,'String')) returns contents of SplineNumberOfKnotsEdit as a double
mvcModel = handles.mvcModel;
mvcModel.splineNumberOfKnots = str2double(get(hObject,'String'));
set(hObject, 'String', mvcModel.splineNumberOfKnots);

% --- Executes during object creation, after setting all properties.
function SplineNumberOfKnotsEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SplineNumberOfKnotsEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LogVariableCheckbox.
function LogVariableCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to LogVariableCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LogVariableCheckbox
mvcModel = handles.mvcModel;
mvcModel.logVariable = get(hObject,'Value');

% --- Executes on button press in LogSpikeRateCheckbox.
function LogSpikeRateCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to LogSpikeRateCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LogSpikeRateCheckbox
mvcModel = handles.mvcModel;
mvcModel.logSpikeRate = get(hObject,'Value');


% --- Executes on button press in GenerateOutputCheckbox.
function GenerateOutputCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to GenerateOutputCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GenerateOutputCheckbox
mvcModel = handles.mvcModel;
mvcModel.generateOutputFile = get(hObject,'Value');


function OutputDirectoryEdit_Callback(hObject, eventdata, handles)
% hObject    handle to OutputDirectoryEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OutputDirectoryEdit as text
%        str2double(get(hObject,'String')) returns contents of OutputDirectoryEdit as a double


% --- Executes during object creation, after setting all properties.
function OutputDirectoryEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputDirectoryEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
