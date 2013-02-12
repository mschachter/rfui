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
            
            set(viewHandles.SelectFileText, 'String', preprocModel.inputFile);
            set(viewHandles.CellPatternEdit, 'String', 'sig*');

            set(viewHandles.SpikeRateWindowSizeEdit, 'String', num2str(preprocModel.spikeRateWindowSize));
            set(viewHandles.SpikeRateWindowSizeEdit, 'Value', preprocModel.spikeRateWindowSize);

            set(viewHandles.VariableOfInterestListbox, 'String', preprocModel.variablesOfInterestList);

            set(viewHandles.NumberOfBinsEdit, 'String', num2str(preprocModel.variableNumberOfBins));
            set(viewHandles.NumberOfBinsEdit, 'Value', preprocModel.variableNumberOfBins);

            set(viewHandles.SmoothingParameterEdit, 'String', num2str(preprocModel.splineParameter));
            set(viewHandles.SmoothingParameterEdit, 'Value', preprocModel.splineParameter);

            set(viewHandles.BinSpacingEdit, 'String', num2str(preprocModel.heatmapBinSpacing));
            set(viewHandles.BinSpacingEdit, 'Value', preprocModel.heatmapBinSpacing);

            sr = '';
            if preprocModel.sampleRate > -1
                sr = num2str(preprocModel.sampleRate);
            end            
            set(viewHandles.SampleRateText, 'String', sr);

            set(viewHandles.CellsToAnalyzeListbox, 'String', preprocModel.cellList);
            
        end
                
        function loadExpData(obj, preprocModel)
            
            obj.itsExpData = ExpData(preprocModel.inputFile, preprocModel.cellPattern);
            
            preprocModel.sampleRate = obj.itsExpData.samplingRate;
            preprocModel.variablesOfInterestList = obj.itsExpData.variableNames;
            preprocModel.variableOfInterest = preprocModel.variablesOfInterestList{1};
            preprocModel.cellList = obj.itsExpData.cellNames;
            preprocModel.selectedCells = preprocModel.cellList;
            
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