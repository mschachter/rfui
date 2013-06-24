%#########################################################################
%PreprocessingModel
%
%A class that contains UI variables for preprocessing.
%
%#########################################################################
classdef PreprocessingModel < handle 
   
    
    %#########################################################################
    %read/write properties
    %#########################################################################
    properties (GetAccess = public, SetAccess = public)
        inputFile = 'Click browse to select file.';
        cellPattern = 'sig';
        
        spikeRateWindowSize = 0.010;
        spikeRateWindowType = 'Gaussian';
        
        variableOfInterest = '';
        variableNumberOfBins = 20;
        
        splineNumberOfKnots = 3;
        splineOrder = 3;
        logVariable = 1;
        logSpikeRate = 1;
        
        heatmapBinSpacing = 0.200;
        heatmapNumberOfLags = 25;        
        
        sampleRate = -1;
        
        variablesOfInterestList = {};
                
        cellList = {};        
        selectedCells = {};
        
        generateOutputFile = 1;
        outputDirectory = '';
    end
    
    %#########################################################################
    %immutable properties
    %#########################################################################
    properties (GetAccess = public, SetAccess = private)
        
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
        
        function set.inputFile(obj, value)            
            v = InputValidator();
            obj.inputFile = v.checkFilePath(value);            
        end
        
        function set.spikeRateWindowSize(obj, value)
            v = InputValidator();
            obj.spikeRateWindowSize = v.checkNumberAgainstRange(value, 0.001, 1.0, 0.010);
        end
        
        function set.spikeRateWindowType(obj, value)
            v = InputValidator();
            obj.spikeRateWindowType = v.checkStringAgainstList(value, {'Gaussian', 'MovingAverage', 'Alpha'}, 'Gaussian');
        end
        
        function set.variableNumberOfBins(obj, value)
            v = InputValidator();
            obj.variableNumberOfBins = v.checkNumberAgainstRange(value, 1, 10000, 20);
        end
        
        function set.splineOrder(obj, value)
            v = InputValidator();
            obj.splineOrder = v.checkNumberAgainstRange(value, 1.0, 3.0, 3.0);
        end
        
        function set.splineNumberOfKnots(obj, value)
            v = InputValidator();
            obj.splineNumberOfKnots = v.checkNumberAgainstRange(value, 2.0, 5.0, 3.0);
        end
        
        function set.logVariable(obj, value)
            v = InputValidator();
            obj.logVariable = v.checkNumberAgainstRange(value, 0.0, 1.0, 1.0);
        end
        
        function set.logSpikeRate(obj, value)
            v = InputValidator();
            obj.logSpikeRate = v.checkNumberAgainstRange(value, 0.0, 1.0, 1.0);
        end
        
        function set.heatmapBinSpacing(obj, value)
            v = InputValidator();
            obj.heatmapBinSpacing = v.checkNumberAgainstRange(value, 0.001, 5.0, 0.010);
        end
        
        function set.heatmapNumberOfLags(obj, value)
            v = InputValidator();
            obj.heatmapNumberOfLags = v.checkNumberAgainstRange(value, 0, 10000, 50);
        end
        
        function set.generateOutputFile(obj, value)
            v = InputValidator();
            obj.generateOutputFile = v.checkNumberAgainstRange(value, 0, 1, 1);
        end        
        
    end 
    
    %#########################################################################
    %public methods methods
    %#########################################################################
    methods (Access = public)
        
    end
    
    
    %#########################################################################
    %constructor/destructor
    %#########################################################################
    methods (Access = public)     
        
        %constructor
        function newPM = PreprocessingModel()
            
        end
    end
    
end