classdef HeatMapJustFitEventData < event.EventData
    
   properties
      lagNumber;
   end

   methods
      function obj = HeatMapJustFitEventData(lagNumber)         
         obj.lagNumber = lagNumber;
      end
   end
end