%#########################################################################
%OutputFileGenerator
%
%A class that generates output files.
%
%#########################################################################
classdef OutputFileGenerator < handle 
   
    
    %#########################################################################
    %read/write properties
    %#########################################################################
    properties (GetAccess = public, SetAccess = public)
        
    end
    
    %#########################################################################
    %private properties
    %#########################################################################
    properties (GetAccess = private, SetAccess = private)
        itsExpData = -1;
        itsPreprocModel = -1;
        itsHandles = -1;
        itsCellCount = 0;
        itsNumLags = 0;
        
        itsTuningCurve = -1;
        itsHeatMap = -1;
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
        
        function generate(obj)
            f = fopen(obj.itsPreprocModel.outputFileName, 'w');
            
            for k = 1:length(obj.itsPreprocModel.selectedCells)
                
                cellIndex = obj.itsPreprocModel.selectedCells(k);
                cellName = obj.itsPreprocModel.cellList{k};
                avgSpikeRate = mean(obj.itsTuningCurve.averageSpikeRate(cellIndex, :));
                peakSpikeRate = obj.itsTuningCurve.peakRate(cellIndex);
                if obj.itsTuningCurve.logRate
                    avgSpikeRate = exp(avgSpikeRate);
                    peakSpikeRate = exp(peakSpikeRate);
                end                
            end
            
            fclose(f);
        end                
        
    end
    
    
    %#########################################################################
    %constructor/destructor
    %#########################################################################
    methods (Access = public)     
        
        %constructor
        function newOFG = OutputFileGenerator(preprocessingModel, expData, tuningCurve, heatMap)
            newOFG.itsPreprocModel = preprocessingModel;
            newOFG.itsExpData = expData;
            newOFG.itsTuningCurve = tuningCurve;
            newOFG.itsHeatMap = heatMap;
        end
    end
    
end