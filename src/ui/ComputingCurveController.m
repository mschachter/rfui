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
    %immutable properties
    %#########################################################################
    properties (GetAccess = private, SetAccess = private)
        itsExpData = -1;
        itsPreprocModel = -1;
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
        
        function compute(obj)
            tc = TuningCurve();
            tc.expData = obj.itsExpData;
            tc.filterWidth = 1;
            tc.timeOffset = 0;            
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