function varargout = ComputingCurveView(varargin)
% COMPUTINGCURVEVIEW MATLAB code for ComputingCurveView.fig
%      COMPUTINGCURVEVIEW, by itself, creates a new COMPUTINGCURVEVIEW or raises the existing
%      singleton*.
%
%      H = COMPUTINGCURVEVIEW returns the handle to a new COMPUTINGCURVEVIEW or the handle to
%      the existing singleton*.
%
%      COMPUTINGCURVEVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPUTINGCURVEVIEW.M with the given input arguments.
%
%      COMPUTINGCURVEVIEW('Property','Value',...) creates a new COMPUTINGCURVEVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ComputingCurveView_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ComputingCurveView_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ComputingCurveView

% Last Modified by GUIDE v2.5 14-Feb-2013 13:32:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ComputingCurveView_OpeningFcn, ...
                   'gui_OutputFcn',  @ComputingCurveView_OutputFcn, ...
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


% --- Executes just before ComputingCurveView is made visible.
function ComputingCurveView_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ComputingCurveView (see VARARGIN)
if length(varargin) == 2    
    mvcController = ComputingCurveController(varargin{1}, varargin{2});    
    handles.mvcController = mvcController;
else
    error('CompuingCurveView takes two input arguments, a PreprocessingModel object and an ExpData object.');
end

% Choose default command line output for ComputingCurveView
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ComputingCurveView wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = ComputingCurveView_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
mvcController = handles.mvcController;
mvcController.compute(handles);
