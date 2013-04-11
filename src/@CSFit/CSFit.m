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
        
        %the spline function
        splineFunc        
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
            if isempty(obj.itsSplineFunc)
                obj.fitData();
            end
            ret = obj.itsR2;
        end
        
        %called when splineFunc is accessed
        function ret = get.splineFunc(obj)
            if isempty(obj.itsSplineFunc)
                obj.fitData();
            end
            ret = obj.itsSplineFunc;
        end
    end
    
    %#########################################################################
    %private methods
    %#########################################################################
    methods (Access = private)
        
        %fit the data with a cubic spline
        function fitData(obj)            
            dof = obj.itsSplineParams('dof');
            knots = obj.itsSplineParams('knots');
            obj.itsSplineFunc = splinefit(obj.X, obj.Y, knots); %cubic spline
            obj.computeR2;            
        end

        %compute the R^2 of the data
        function computeR2(obj)
            if isempty(obj.itsSplineFunc)
                error('Cannot compute R^2 because there is no spline function!');
            end
            ymean = mean(obj.Y);
            pred = obj.eval(obj.X);
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
        itsX;
        %y axis data
        itsY;
        %R^2
        itsR2;        
        %cubic spline implementation
        itsSplineParams;
        %actual fit spline function
        itsSplineFunc;        
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
            
            if (nargin > 1)
                Ypred = ppval(obj.itsSplineFunc, x);
            else
                Ypred = ppval(obj.itsSplineFunc, obj.X);
            end
        end
    end
    
    %#########################################################################
    %constructor/destructor
    %#########################################################################
    methods (Access = public)
        %x data, y data, dof and number of knots
        function newCS = CSFit(x, y, dof, knots)
            if ((nargin < 2) || (~isa(x, 'double')) || (~isa(y, 'double')))
                error('argument 1 and 2 must be arrays of doubles representing x and y data to be fit');    
            end
            
            newCS = newCS@handle();
            
            newCS.itsX = x;
            newCS.itsY = y;                 
            newCS.itsR2 = nan;        
            newCS.itsSplineParams = containers.Map();            
            newCS.itsSplineFunc = [];     
            
            if nargin < 4
                knots = length(x);
            end
            
            if (isempty(knots))
                knots = length(x);
            end
            
            if nargin < 3
                dof = 4;
            end
            
            newCS.itsSplineParams('dof') = dof; 
            newCS.itsSplineParams('knots') = knots - 1;                 
        end
    end
    
end %classdef