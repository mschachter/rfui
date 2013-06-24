%#########################################################################
%PreprocessingController
%
%A class that interacts with the model object to do preprocessing stuff.
%
%#########################################################################
classdef PreprocessingController < handle 
   
    
    %#########################################################################
    %read/write properties
    %#########################################################################
    properties (GetAccess = public, SetAccess = public)
        
    end
    
    %#########################################################################
    %immutable properties
    %#########################################################################
    properties (GetAccess = private, SetAccess = private)
        itsExpData = -1;
    end
    
    %#########################################################################
    %'Get' properties methods for dependent variables
    %#########################################################################
    methods
        
    end 
    
    %#########################################################################
    %'Set' properties methods
    %#########################################################################
    methods
        
    end 
    
    %#########################################################################
    %public methods methods
    %#########################################################################
    methods (Access = public)
        
        function updateView(obj, viewHandles, preprocModel)
            
            [iipath,filename,fileext] = fileparts(preprocModel.inputFile);
            set(viewHandles.SelectFileText, 'String', [filename fileext]);            
            set(viewHandles.CellPatternEdit, 'String', preprocModel.cellPattern);

            set(viewHandles.SpikeRateWindowSizeEdit, 'String', num2str(preprocModel.spikeRateWindowSize));
            set(viewHandles.SpikeRateWindowSizeEdit, 'Value', preprocModel.spikeRateWindowSize);

            set(viewHandles.VariableOfInterestListbox, 'String', preprocModel.variablesOfInterestList);

            set(viewHandles.NumberOfBinsEdit, 'String', num2str(preprocModel.variableNumberOfBins));
            set(viewHandles.NumberOfBinsEdit, 'Value', preprocModel.variableNumberOfBins);

            set(viewHandles.SplineOrderEdit, 'String', num2str(preprocModel.splineOrder));
            set(viewHandles.SplineOrderEdit, 'Value', preprocModel.splineOrder);
            
            set(viewHandles.SplineNumberOfKnotsEdit, 'String', num2str(preprocModel.splineNumberOfKnots));
            set(viewHandles.SplineNumberOfKnotsEdit, 'Value', preprocModel.splineNumberOfKnots);

            set(viewHandles.LogSpikeRateCheckbox, 'Value', preprocModel.logSpikeRate);
            
            set(viewHandles.LogVariableCheckbox, 'Value', preprocModel.logVariable);
            
            set(viewHandles.BinSpacingEdit, 'String', num2str(preprocModel.heatmapBinSpacing));
            set(viewHandles.BinSpacingEdit, 'Value', preprocModel.heatmapBinSpacing);

            sr = '';
            if preprocModel.sampleRate > -1
                sr = num2str(preprocModel.sampleRate);
            end            
            set(viewHandles.SampleRateText, 'String', sr);

            set(viewHandles.CellsToAnalyzeListbox, 'String', preprocModel.cellList);
            set(viewHandles.CellsToAnalyzeListbox, 'Value', 1:length(preprocModel.cellList));
            
            set(viewHandles.GenerateOutputCheckbox, 'Value', preprocModel.generateOutputFile);
            
        end
                
        function loadExpData(obj, preprocModel)
            
            obj.itsExpData = ExpData(preprocModel.inputFile, preprocModel.cellPattern);
            
            preprocModel.sampleRate = obj.itsExpData.samplingRate;
            preprocModel.variablesOfInterestList = obj.itsExpData.variableNames;
            preprocModel.variableOfInterest = preprocModel.variablesOfInterestList{1};
            preprocModel.cellList = obj.itsExpData.cellNames;
            preprocModel.selectedCells = 1:length(preprocModel.cellList);
            
        end
        
        function runPreprocessing(obj, viewHandles, preprocModel)                        
            close(viewHandles.PreprocessingView);
            ccView = ComputingCurveView(preprocModel, obj.itsExpData);
        end
        
    end
    
    
    %#########################################################################
    %constructor/destructor
    %#########################################################################
    methods (Access = public)     
        
        %constructor
        function newPC = PreprocessingController()
            
        end
    end
    
end