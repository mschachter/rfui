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
            obj.itsCellCount = obj.itsExpData.cellCount;
            
            tc = TuningCurve(obj.itsPreprocModel.splineType, obj.itsPreprocModel.splineParameter);
            tc.filterWidth = 1;
            tc.timeOffset = 0;            
            tc.expData = obj.itsExpData;
            
            addlistener(tc, 'TuningCurveJustFit', @obj.tuningCurveJustFit);                        
            tc.computeTuningCurve();            
            
            set(viewHandles.StatusText, 'String', 'Computing heatmaps...');            
            
            hm = HeatMap;
            hm.tuningCurve = tc;
            hm.lagTime = obj.itsPreprocModel.heatmapBinSpacing;
            hm.numLags = obj.itsPreprocModel.heatmapNumberOfLags;
            obj.itsNumLags = hm.numLags*2 + 1;
            
            addlistener(hm, 'HeatMapJustFit', @obj.heatmapJustFit);                        
            hm.computeHeatMap();
            
        end
        
        function tuningCurveJustFit(obj, sourceObj, event)
            set(obj.itsHandles.CellText, 'String', sprintf('Cell %d of %d (%s)', event.cellNumber, obj.itsCellCount, event.cellName));
        end
        
        function heatmapJustFit(obj, sourceObj, event)
            display('heatmapJustFit');
            set(obj.itsHandles.CellText, 'String', sprintf('Lag %d of %d', event.lagNumber, obj.itsNumLags));
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