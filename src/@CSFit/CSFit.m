%#########################################################################
%CSFit
%
%A class to fit data with a cubic spline and compute goodness-of-fit.
%
% example : see test/testCSFit.m
%#########################################################################
classdef CSFit < handle 
    
    %#########################################################################
    %read-only properties
    %#########################################################################
    properties (Dependent = true, GetAccess = public, SetAccess = private)
        %x-axis data
        X
        
        %y-axis data
        Y
        
        %R^2 of fit
        R2
    end
    
    %#########################################################################
    %'Get' properties methods for dependent variables
    %#########################################################################
    methods
        %called when X is accessed
        function ret = get.X(obj)
            ret = obj.itsX;
        end        
        
        %called when Y is accessed
        function ret = get.Y(obj)
            ret = obj.itsY;
        end
        
        %called when R2 is accessed
        function ret = get.R2(obj)
            ret = obj.itsR2;
        end
    end
    
    %#########################################################################
    %private methods
    %#########################################################################
    methods (Access = private)
        
        %fit the data with a cubic spline
        function fitData(obj)            
            p = 1.0; %the p used for natural cubic spline
            if strcmp('smoothing', obj.itsMethod)                            
                if obj.itsMethodParameters.isKey('p')
                    p = obj.itsMethodParameters('p');
                end
            end
            obj.itsSplineFunc = csaps(obj.X, obj.Y, p);                                    
            obj.computeR2;            
        end

        %compute the R^2 of the data
        function computeR2(obj)
            if isempty(obj.itsSplineFunc)
                error('Cannot compute R^2 because there is no spline function!');
            end
            ymean = mean(obj.Y);
            pred = fnval(obj.itsSplineFunc, obj.X);
            err = pred - obj.Y;
            ssTotal = sum((obj.Y - ymean).^2);
            ssErr = sum(err.^2);
            obj.itsR2 = 1 - ssErr/ssTotal;
        end
        
    end       
    
    %#########################################################################
    %private properties
    %#########################################################################
    properties (GetAccess = private, SetAccess = private)
        %x axis data
        itsX = [];
        %y axis data
        itsY = [];
        %R^2
        itsR2 = nan;        
        %cubic spline implementation
        itsMethod = 'natural';
        %implementation parameters
        itsMethodParameters = containers.Map();
        %actual fit spline function
        itsSplineFunc = [];
    end
    
    %#########################################################################
    %public methods methods
    %#########################################################################
    methods (Access = public)
        
        %evaluate the spline at the given points
        function Ypred = eval(obj, x)
            if isempty(obj.itsSplineFunc)
                obj.fitData();
            end
            Ypred = fnval(obj.itsSplineFunc, x);   
        end
    end
    
    %#########################################################################
    %constructor/destructor
    %#########################################################################
    methods (Access = public)
        %create a new SpikeData object from spike times, assuming units are in seconds.
        function newCS = CSFit(x, y, method, methodParameters)
            if ((nargin < 2) || (~isa(x, 'double')) || (~isa(y, 'double')))
                error('argument must of two array of doubles representing x and y data to be fit');    
            end             
            newCS.itsX = x;
            newCS.itsY = y;            
            if nargin >= 3
                if ~ismember(method, {'natural', 'smoothing'})
                    error('method argument to CSFit must be ''natural'' or ''smoothing''.');
                end
                newCS.itsMethod = method;
            end
            if nargin >= 4
                newCS.itsMethodParameters = methodParameters;
            end 
        end
    end
    
end %classdef