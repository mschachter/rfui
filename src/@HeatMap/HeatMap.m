%#########################################################################
%HeatMap
%
%A class to to compute and display heat maps of the max firing rate of tuning curves at different time lags 
%for neurons recorded from an electrode array in a single experimental session
%
% example:
% tc = TuningCurve('smoothing', .5);
% tc.expData = ExpData('../../data/data2.csv', 'sig*');
%
% hm = HeatMap;
% hm.tuningCurve = tc;
% hm.lagTime = .01;%100ms lags
% hm.numLags = 50; %50 lags at .01sec is 5 sec of lag
% hm.plotHeatMap;
%#########################################################################
classdef HeatMap < handle 
    
    %#########################################################################
    %read-only dependent properties
    %#########################################################################
    properties (Dependent = true, GetAccess = public, SetAccess = private)
        %the raw heatmap data matrix
        heatMapData
        
        %the lag with the highest peak rate for each cell
        optimalLag
        
        %the peak firing rate at the best lag for each cell
        peakRate
    end
    
    %#########################################################################
    %read/write dependent properties
    %#########################################################################
    properties (Dependent = true, GetAccess = public, SetAccess = public)
        %the tuning curve object
        tuningCurve
        
        %the amount to lag the signal
        lagTime
        
        %the number of positive lags to compute (the total number of lags
        %will be 2*numLags+1
        numLags
        
        %the plot type : normal, semilogx
        plotType
    end
    
    %#########################################################################
    %read/write properties
    %#########################################################################
    properties (GetAccess = public, SetAccess = public)
        %plot all in subplots
        useSubplots = 0;
        
        %number of subplots (rows, cols) per figure
        numSubplots = [4, 4];
        
        %number of y axis bins
        numYAxisBins = 100;
    end
    
    %#########################################################################
    %private properties
    %#########################################################################
    properties (GetAccess = private, SetAccess = private)
        %the raw heatmap data matrix
        itsHeatMapData = [];
        
        %the lag with the highest peak rate for each cell
        itsOptimalLag = [];
        
        %the peak firing rate at the best lag for each cell
        itsPeakRate = [];
        
        %the tuning curve object
        itsTuningCurve = [];
        
        %the amount to lag the signal
        itsLagTime = .1;%default 100ms
        
        %the number of lags to compute
        itsNumLags = 50;%default 50 lags
        
        %the plot type : normal, semilogx
        itsPlotType = 'semilogx'
        
        %update flag variables
        updateData = 1
    end
    
    %#########################################################################
    %'Set' properties methods
    %#########################################################################
    methods
        %called when tuningCurve is set
        function set.tuningCurve(obj, value)
            obj.updateData = 1;
            obj.itsTuningCurve = value;
        end
        
        %called when lagTime is set
        function set.lagTime(obj, value)
            if (obj.itsLagTime ~= value)
                obj.updateData = 1;
                obj.itsLagTime = value;
            end
        end
        
        %called when numLags is set
        function set.numLags(obj, value)
            if (obj.itsNumLags ~= value)
                obj.updateData = 1;
                obj.itsNumLags = value;
            end
        end
        
        %called when plotType is set
        function set.plotType(obj, value)
            if (~strcmpi(obj.itsPlotType,value))
                obj.updateData = 1;
                obj.itsPlotType = value;
            end
        end
    end
    
    %#########################################################################
    %'Get' properties methods
    %#########################################################################
    methods
        %called when heatMapData is accessed
        function ret = get.heatMapData(obj)
            if ((obj.updateData) || (obj.itsTuningCurve.updateData))
                computeHeatMap(obj);
                obj.updateData = 0;
            end
            ret = obj.itsHeatMapData;
        end
        
        %called when optimalLag is accessed
        function ret = get.optimalLag(obj)
            if (obj.updateData)
                computeHeatMap(obj);
                obj.updateData = 0;
            end
            ret = obj.itsOptimalLag;
        end
        
        %called when peakRate is accessed
        function ret = get.peakRate(obj)
            if (obj.updateData)
                computeHeatMap(obj);
                obj.updateData = 0;
            end
            ret = obj.itsPeakRate;
        end
        
        %called when tuningCurve is accessed
        function ret = get.tuningCurve(obj)
            ret = obj.itsTuningCurve;
        end
        
        %called when lagTime is accessed
        function ret = get.lagTime(obj)
            ret = obj.itsLagTime;
        end
        
        %called when numLags is accessed
        function ret = get.numLags(obj)
            ret = obj.itsNumLags;
        end
        
        %called when plotType is accessed
        function ret = get.plotType(obj)
            ret = obj.itsPlotType;
        end
    end
        
    %#########################################################################
    %public methods
    %#########################################################################
    methods (Access = public)
        %plots the heatmap for the specified cell, or if no
        %arguments, for all cells
        function plotHeatMap(obj, cellNum)
            if (isempty(obj.itsTuningCurve))
                error('the ''tuningCurve'' property must be set before accessing other properties or plotting');
            end
            
            if (nargin > 1)
                if (cellNum > obj.tuningCurve.expData.cellCount)
                    error(['The desired cell (', num2str(cellNum), ') is out of range (N = ', ...
                        num2str(obj.tuningCurve.expData.cellCount),' cells)']);
                end
            end
            
            if (nargin > 1)
                cellsToPlot = cellNum;
            else
                cellsToPlot = 1:obj.tuningCurve.expData.cellCount;
            end
            
            %set up number of figures and plots per figure
            numPlotsPerFig = 1;
            baseFig = figure();
            if obj.useSubplots && length(cellsToPlot) > 1
                numPlotsPerFig = obj.numSubplots(1)*obj.numSubplots(2);
            end
            
           spNum = 1;
            %plot binned variable vs average spike rate
            for (cellNum = 1:length(cellsToPlot))
                %get the current figure and subplot numbers
                if obj.useSubplots && length(cellsToPlot) > 1
                    currentFig = ceil(cellNum / numPlotsPerFig) - 1 + baseFig;
                    if (spNum > numPlotsPerFig)
                        spNum = 1;
                    end
                    figure(currentFig); hold on;
                    subplot(obj.numSubplots(1), obj.numSubplots(2), spNum); 
                    spNum = spNum + 1;
                else
                    figure(baseFig + cellNum - 1);
                end              
                
                xx = obj.itsLagTime : obj.itsLagTime : obj.itsNumLags*obj.itsLagTime;
                xx = [fliplr(-xx), 0, xx];
                if (strcmpi(obj.plotType,'semilogx'))
                    yy = logspace(log10(obj.tuningCurve.binnedVariable(1)),log10(obj.tuningCurve.binnedVariable(end)),obj.numYAxisBins);
                else
                    yy = linspace(obj.tuningCurve.binnedVariable(1),obj.tuningCurve.binnedVariable(end),obj.numYAxisBins);
                end
                    
                %plot the data on a normal axis
                h = imagesc(xx,[],obj.heatMapData(:,:,cellsToPlot(cellNum))); colorbar('EastOutside');
                axis xy;
                
                currTck = get(gca,'ytick');
                newTck = linspace(currTck(1), currTck(end), 4);
                tckLabel = linspace(yy(1), yy(end), 4);
                tckLabel = round(tckLabel*100)/100;
                set(gca,'ytick', newTck);
                set(gca,'yticklabel', tckLabel); 
                title(['Max: ',num2str(round(obj.peakRate(cellNum)*100)/100), ...
                    ' Hz at ',num2str(obj.optimalLag(cellNum)),' sec']);
            end
        end
    end
    
    %#########################################################################
    %private methods
    %#########################################################################
    methods (Access = private)
        %compute the heatmap data
        function computeHeatMap(obj)
            if (isempty(obj.itsTuningCurve))
                error('the ''tuningCurve'' property must be set before accessing other properties or plotting');
            end
            
            lags = obj.itsLagTime : obj.itsLagTime : obj.itsNumLags*obj.itsLagTime;
            lags = [fliplr(-lags), 0, lags];
            
            tc = obj.itsTuningCurve;
            obj.itsHeatMapData = zeros(obj.numYAxisBins, length(lags), tc.expData.cellCount);
            if (strcmpi(obj.itsPlotType,'semilogx'))
                xx = logspace(log10(tc.binnedVariable(1)),log10(tc.binnedVariable(end)),obj.numYAxisBins);
            else
                xx = linspace(tc.binnedVariable(1),tc.binnedVariable(end),obj.numYAxisBins);
            end
            
            obj.itsPeakRate = zeros(tc.expData.cellCount, length(lags));
            for (lagNum = 1:length(lags))
                tc.timeOffset = lags(lagNum);
                for (currCell = 1:tc.expData.cellCount)
                    currSpline = tc.splineFits(currCell);
                    obj.itsHeatMapData(:, lagNum, currCell) = currSpline.eval(xx)';
                end
                obj.itsPeakRate(:, lagNum) = tc.peakRate'; % a 1 x cells array of peak firing rates
            end
            
            %compute peakRate for each cell and optimal lag
            [obj.itsPeakRate, obj.itsOptimalLag] = max(obj.itsPeakRate, [], 2);
            obj.itsPeakRate = obj.itsPeakRate';
            obj.itsOptimalLag = obj.itsOptimalLag';
            obj.itsOptimalLag = lags(obj.itsOptimalLag);
        end
    end    
end % classdef