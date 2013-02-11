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
        inputFile = '';
        cellPattern = 'sig*';
        
        spikeRateWindowSize = 0.010;
        spikeRateWindowType = 'Gaussian';
        
        variableOfInterest = '';
        variableNumberOfBins = 20;
        
        splineType = 'Smoothing';
        splineParameter = 0.5;
        
        heatmapBinSpacing = 0.025;
        heatmapNegativeLag = -5.0;
        heatmapPositiveLag = 5.0;
        
    end
    
    %#########################################################################
    %private properties
    %#########################################################################
    properties (GetAccess = private, SetAccess = private)
        
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
        
        function set.splineType(obj, value)
            v = InputValidator();
            obj.splineType = v.checkStringAgainstList(value, {'Smoothing', 'Natural'}, 'Smoothing');
        end
        
        function set.splineParameter(obj, value)
            v = InputValidator();
            obj.splineParameter = v.checkNumberAgainstRange(value, 0.0, 1.0, 0.5);
        end
        
        function set.heatmapBinSpacing(obj, value)
            v = InputValidator();
            obj.heatmapBinSpacing = v.checkNumberAgainstRange(value, 0.001, 5.0, 0.010);
        end
        
        function set.heatmapNegativeLag(obj, value)
            v = InputValidator();
            obj.heatmapNegativeLag = v.checkNumberAgainstRange(value, -10.0, 0.0, -5.0);
        end
                        
        function set.heatmapPositiveLag(obj, value)
            v = InputValidator();
            obj.heatmapPositiveLag = v.checkNumberAgainstRange(value, 0.0, 10.0, 5.0);
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