%#########################################################################
%TuningCurveModel
%
%A class that contains UI variables for TuningCurve.
%
%#########################################################################
classdef TuningCurveModel < handle 
   
    
    %#########################################################################
    %read/write properties
    %#########################################################################
    properties (GetAccess = public, SetAccess = public)
        cellIndex = 1;           
    end
    
    %#########################################################################
    %read-only properties
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
        function newTCM = TuningCurveModel()
            
        end
    end
    
end