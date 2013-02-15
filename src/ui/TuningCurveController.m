%#########################################################################
%TuningCurveController
%
%A class that controls the display of tuning curves and heatmaps.
%
%#########################################################################
classdef TuningCurveController < handle 
   
    
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
        itsTuningCurve = -1;
        itsHeatMap = -1;
        itsNumberOfCells = 0;
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
        
        
        function previousCell(obj, tcModel, viewHandles)
            if obj.itsNumberOfCells > 1
                cnext = tcModel.cellIndex + 1;
                if cnext < 1
                    cnext = obj.itsNumberOfCells;
                end
                obj.displayCell(cnext, tcModel, viewHandles);
            end                        
        end
        
        
        function nextCell(obj, tcModel, viewHandles)
        
            if obj.itsNumberOfCells > 1
                cnext = tcModel.cellIndex + 1;
                if cnext > obj.itsNumberOfCells
                    cnext = 1;
                end
                obj.displayCell(cnext, tcModel, viewHandles);
            end
            
        end
        
        
        function displayCell(obj, cellIndex, tcModel, viewHandles)
           
            cellNumber = obj.itsPreprocModel.selectedCells(cellIndex);
            cellName = obj.itsExpData.cellNames{cellNumber};
            set(viewHandles.PlotPanel, 'Title', cellName);
            
            set(viewHandles.CellNumberEdit, 'String', num2str(cellIndex));
            set(viewHandles.CellNumberEdit, 'Value', cellIndex);
            
            axes(viewHandles.TuningCurveAxes);
            obj.itsTuningCurve.plotTuningCurve(cellNumber, 0);            
            
            axes(viewHandles.HeatMapAxes);
            obj.itsHeatMap.plotHeatMap(cellNumber, 0);
            
            tcModel.cellIndex = cellNumber;
            
        end
        
    end
    
    
    %#########################################################################
    %constructor/destructor
    %#########################################################################
    methods (Access = public)     
        
        %constructor
        function newTCC = TuningCurveController(expData, preprocModel, tuningCurve, heatmap)
            
            newTCC.itsNumberOfCells = length(preprocModel.selectedCells);
            newTCC.itsExpData = expData;
            newTCC.itsPreprocModel = preprocModel;
            newTCC.itsTuningCurve = tuningCurve;
            newTCC.itsHeatMap = heatmap;
            
        end
    end
    
end