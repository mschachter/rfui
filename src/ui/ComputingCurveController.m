%#########################################################################
%ComputeCurveController
%
%A class that computes tuning curves and heatmaps from data.
%
%#########################################################################
classdef ComputingCurveController < handle 
   
    
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
        
        function compute(obj, viewHandles)            
            
            obj.itsHandles = viewHandles;
            obj.itsCellCount = length(obj.itsPreprocModel.selectedCells);
            
            tc = TuningCurve(obj.itsPreprocModel.splineType, obj.itsPreprocModel.splineParameter);
            tc.selectedCells = obj.itsPreprocModel.selectedCells;
            tc.filterWidth = 1;
            tc.timeOffset = 0;            
            tc.expData = obj.itsExpData;
            
            tclh = addlistener(tc, 'TuningCurveJustFit', @obj.tuningCurveJustFit);                        
            tc.computeTuningCurve();            
            delete(tclh);            
            
            obj.itsTuningCurve = tc;                        
            
            set(viewHandles.StatusText, 'String', 'Computing heatmaps...');            
            
            hm = HeatMap;            
            hm.tuningCurve = tc;
            hm.lagTime = obj.itsPreprocModel.heatmapBinSpacing;
            hm.numLags = obj.itsPreprocModel.heatmapNumberOfLags;
            obj.itsNumLags = hm.numLags*2 + 1;
            
            hmlh = addlistener(hm, 'HeatMapJustFit', @obj.heatmapJustFit);                        
            hm.computeHeatMap();
            delete(hmlh);
            
            obj.itsHeatMap = hm;                        
        end
                
        
        function showTuningCurveView(obj, viewHandles)        
            close(viewHandles.ComputingCurveView);
            tcc = TuningCurveView(obj.itsExpData, obj.itsPreprocModel, obj.itsTuningCurve, obj.itsHeatMap);
        end
        
        
        function tuningCurveJustFit(obj, sourceObj, event)            
            set(obj.itsHandles.CellText, 'String', sprintf('Cell %d of %d (%s)', event.cellNumber, obj.itsCellCount, event.cellName));
            drawnow();
        end
        
        
        function heatmapJustFit(obj, sourceObj, event)                        
            set(obj.itsHandles.CellText, 'String', sprintf('Lag %d of %d', event.lagNumber, obj.itsNumLags));
            drawnow();
        end                
        
    end
    
    
    %#########################################################################
    %constructor/destructor
    %#########################################################################
    methods (Access = public)     
        
        %constructor
        function newCCC = ComputingCurveController(preprocessingModel, expData)
            newCCC.itsPreprocModel = preprocessingModel;
            newCCC.itsExpData = expData;
        end
    end
    
end