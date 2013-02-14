classdef TuningCurveJustFitEventData < event.EventData
    
   properties
      cellName;
      cellNumber;
   end

   methods
      function obj = TuningCurveJustFitEventData(cellName, cellNumber)
         obj.cellName = cellName;
         obj.cellNumber = cellNumber;
      end
   end
end