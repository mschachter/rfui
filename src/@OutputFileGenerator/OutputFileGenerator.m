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
        
        %a. filename
        %b. cell
        %c. Average firing rate
        %d. Peak firing rate of tuning curve
        %e. Speed at peak firing rate of tuning curve
        %f. R2 for tuning curve fit
        %g. p-value for tuning curve fit
        %h. Peak firing rate of heatmap
        %i. Speed at peak firing rate of heat map
        %j. Time lag at peak firing rate of heat map
        %k. MIC of heat map        
        
        function generate(obj)
            
            ofile = sprintf('%s.csv', datestr(now(),'mm-dd-yyyy_HH.MM'));
            outputFile = fullfile(obj.itsPreprocModel.outputDirectory, ofile);
            
            f = fopen(outputFile, 'w');
            
            tcVarName = sprintf('TC%s', obj.itsPreprocModel.variableOfInterest);
            hmVarName = sprintf('HM%s', obj.itsPreprocModel.variableOfInterest);
            
            fprintf(f, 'OutputFile,CellName,AvgSpikeRate,TCPeakSpikeRate,%s,R2,HMPeakSpikeRate,%s,HMPeakLag,MIC\n', tcVarName, hmVarName);
            
            for k = 1:length(obj.itsPreprocModel.selectedCells)
                
                cellIndex = obj.itsPreprocModel.selectedCells(k);
                cellName = obj.itsPreprocModel.cellList{k};
                avgSpikeRate = mean(obj.itsTuningCurve.averageSpikeRate(cellIndex, :));
                
                tcPeakSpikeRate = obj.itsTuningCurve.peakRate(cellIndex);
                tcPeakVariable = obj.itsTuningCurve.peakVariable(cellIndex);
                
                hmPeakSpikeRate = obj.itsHeatMap.peakRate(cellIndex);
                hmPeakVariable = obj.itsHeatMap.peakVariable(cellIndex);               
                hmPeakLag = obj.itsHeatMap.optimalLag(cellIndex);
                mic = obj.itsHeatMap.MIC(cellIndex);
                
                if obj.itsTuningCurve.logRate
                    avgSpikeRate = exp(avgSpikeRate);
                    tcPeakSpikeRate = exp(tcPeakSpikeRate);                    
                    hmPeakSpikeRate = exp(hmPeakSpikeRate);
                end                
                if obj.itsTuningCurve.logVariable
                    tcPeakVariable = exp(tcPeakVariable);
                    hmPeakVariable = exp(hmPeakVariable);
                end                
                
                r2 = obj.itsTuningCurve.splineFits(cellIndex).R2;
                
                fprintf(f, '%s,%s,%f,%f,%f,%f,%f,%f,%f,%f\n', ...
                        outputFile, cellName, avgSpikeRate, tcPeakSpikeRate, tcPeakVariable, r2, hmPeakSpikeRate, hmPeakVariable, hmPeakLag, mic);
                
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