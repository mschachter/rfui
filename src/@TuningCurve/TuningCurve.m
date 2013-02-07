%#########################################################################
%TuningCurve
%
%A class to to compute and display tuning curves for neurons recorded from
%an electrode array in a single experimental session
%
% example:
% tc = TuningCurve;
% tc.expData = ExpData('../../data/data2.csv', 'sig*');
% tc.plotTuningCurve
%#########################################################################
classdef TuningCurve < handle 
    
    %#########################################################################
    %read-only dependent properties
    %#########################################################################
    properties (Dependent = true, GetAccess = public, SetAccess = private)
        %binned continous variable data
        binnedVariable
        
        %average spike rate in each bin
        averageSpikeRate
        
        %the spline fits for each cell
        splineFits
        
        %the peak firing rate of the tuning curve
        peakRate
    end
    
    %#########################################################################
    %read/write dependent properties
    %#########################################################################
    properties (Dependent = true, GetAccess = public, SetAccess = public)
        %number of bins for computation
        numBins
        
        %variable of interest
        expVariable
        
        %smooth the variable of interest with a filter this wide in seconds
        filterWidth
    end
    
    %#########################################################################
    %read/write properties
    %#########################################################################
    properties (GetAccess = public, SetAccess = public)
        %a ExpData class
        expData = [];
        
        %the plot type : normal, semilogx
        plotType = 'semilogx'
        
        %plot all in subplots
        useSubplots = 0;
        
        %number of subplots (rows, cols) per figure
        numSubplots = [6, 7];
        
    end
    
    %#########################################################################
    %private properties
    %#########################################################################
    properties (GetAccess = private, SetAccess = private)
        %binned continous variable data
        itsBinnedVariable = []
        
        %average spike rate in each bin
        itsAverageSpikeRate = []
        
        %the spline fits for each cell
        itsSplineFits = []
        
        %the peak firing rate of the tuning curve
        itsPeakRate = []
        
        %number of bins for computation
        itsNumBins = 20
        
        %variable of interest
        itsExpVariable = 'Velocity(Center-point)';
        
        %smooth the variable of interest with a filter this wide in seconds
        itsFilterWidth = 1;
        
        %spline type
        itsSplineType = 'natural';
        
        %spline parameters
        itsSplineParams = containers.Map();
        
        %flag variables
        updateData = 1
    end
    
    %#########################################################################
    %'Set' properties methods
    %#########################################################################
    methods
        %called when numBins is set
        function set.numBins(obj, value)
            if (obj.itsNumBins ~= value)
                obj.updateData = 1;
                obj.itsNumBins = value;
            end
        end
        
        %called when expVariable is set
        function set.expVariable(obj, value)
            if (~strcmpi(obj.expVariable,value))
                obj.updateData = 1;
                obj.expData = value;
            end
        end
        
        %called when filterWidth is set
        function set.filterWidth(obj, value)
            if (obj.filterWidth ~= value)
                obj.updateData = 1;
                obj.itsFilterWidth = value;
            end
        end
    end
    
    %#########################################################################
    %'Get' properties methods
    %#########################################################################
    methods
        %called when binnedVariable is accessed
        function ret = get.binnedVariable(obj)
            if (obj.updateData)
                computeTuningCurve(obj);
                obj.updateData = 0;
            end
            ret = obj.itsBinnedVariable;
        end
        
        %called when averageSpikeRate is accessed
        function ret = get.averageSpikeRate(obj)
            if (obj.updateData)
                computeTuningCurve(obj);
                obj.updateData = 0;
            end
            ret = obj.itsAverageSpikeRate;
        end
        
        %called when splineFits is accessed
        function ret = get.splineFits(obj)
            if (obj.updateData)
                computeTuningCurve(obj);
                obj.updateData = 0;
            end
            ret = obj.itsSplineFits;
        end
        
        %called when peakRate is accessed
        function ret = get.peakRate(obj)
            if (obj.updateData)
                computeTuningCurve(obj);
                obj.updateData = 0;
            end
            ret = obj.itsPeakRate;
        end
        
        %called when numBins is accessed
        function ret = get.numBins(obj) 
           ret = obj.itsNumBins; 
        end
        
        %called when expVariable is accessed
        function ret = get.expVariable(obj)
            ret = obj.itsExpVariable;
        end
        
        %called when filterWidth is accessed
        function ret = get.filterWidth(obj)
            ret = obj.itsFilterWidth;
        end
    end
    
    %#########################################################################
    %public methods
    %#########################################################################
    methods (Access = public)
        %plots the tunning curve for the specified cell, or if no
        %arguments, for all cells
        function plotTuningCurve(obj, cellNum)
            if (isempty(obj.expData))
                error('the ''expData'' property must be set before accessing other properties or plotting');
            end
            
            if (nargin > 1)
                if (cellNum > obj.expData.cellCount)
                    error(['The desired cell (', num2str(cellNum), ') is out of range (N = ', ...
                        num2str(obj.expData.cellCount),' cells)']);
                end
            end
            
            if (nargin > 1)
                cellsToPlot = cellNum;
            else
                cellsToPlot = 1:obj.expData.cellCount;
            end
            
            %set up number of figures and plots per figure
            numFigures = 1;
            numPlotsPerFig = 1;
            baseFig = figure();
            if obj.useSubplots && length(cellsToPlot) > 1
                numPlotsPerFig = obj.numSubplots(1)*obj.numSubplots(2);
                numFigures = ceil(length(cellsToPlot) / numPlotsPerFig);
            end
            
            %plot binned variable vs average spike rate
            for (cellNum = 1:length(cellsToPlot))
                
                %get the current figure and subplot numbers
                if obj.useSubplots && length(cellsToPlot) > 1
                    currentFig = ceil(cellNum / numPlotsPerFig) - 1 + baseFig;
                    spNum = mod(cellNum, numPlotsPerFig);
                    figure(currentFig); hold on;
                    subplot(obj.numSubplots(1), obj.numSubplots(2), spNum); 
                else
                    figure(baseFig + cellNum - 1);
                end                
                    
                if (strcmpi(obj.plotType, 'normal'))
                    h = plot(obj.binnedVariable, obj.averageSpikeRate(cellsToPlot(cellNum),:), 'o');
                elseif (strcmpi(obj.plotType, 'semilogx'))
                    h = semilogx(obj.binnedVariable, obj.averageSpikeRate(cellsToPlot(cellNum),:), 'o');
                else
                    error('Not a valid plot type. Valid types are ''normal'', and ''semilogx''');
                end
                set(h,'MarkerEdgeColor','none','MarkerFaceColor',[.5 .5 .5])
                
                %plot spline fit
                currSpline = obj.splineFits(cellsToPlot(cellNum));
                xx = obj.binnedVariable(1):.01:obj.binnedVariable(end);
                yy = currSpline.eval(xx);
                hold on;
                semilogx(xx, yy,'color',[0 0 0]);
                hold off;
                
                %set title
                r2 = currSpline.R2;
                title(['$R^2$=', num2str(r2)],'interpreter','latex','fontsize',10);
            end
        end
    end
    
    %#########################################################################
    %private methods
    %#########################################################################
    methods (Access = private)
        %compute the tunning curve data
        function computeTuningCurve(obj)
            if (isempty(obj.expData))
                error('the ''expData'' property must be set before accessing other properties or plotting');
            end
            
            %sort the continuous variable
            myVar = smoothVarByName(obj.expData, obj.expVariable, obj.filterWidth);
            [sVar, ord] = sort(myVar, 'descend');
            varLength = length(myVar);
            
            %sort the spike data the same way
            countMat = zeros(obj.expData.cellCount, varLength);
            for (cellNum = 1:obj.expData.cellCount)
                cell = getCellByNum(obj.expData, cellNum);
                spikeCount = histc(cell.spikeTimes, obj.expData.recordingTime);
                countMat(cellNum, :) = spikeCount(ord);
            end
            
            %compute samples per bin given that each bin has the same amount of data - the last bin will have up to
            %(numBins-1)/2 extra samples or fewer samples
            samplesPerBin = floor(varLength / obj.itsNumBins);
            secPerBin = (samplesPerBin / obj.expData.samplingRate);
            
            obj.itsBinnedVariable = zeros(1, obj.itsNumBins);
            obj.itsAverageSpikeRate = zeros(obj.expData.cellCount, obj.itsNumBins);
            
            for (binNum = 1:(obj.itsNumBins) - 1)
                startIdx = ((binNum - 1) * samplesPerBin + 1);
                endIdx = (binNum * samplesPerBin);
                %store the middle value of the bin
                obj.itsBinnedVariable(binNum) = (sVar(startIdx) + sVar(endIdx)) / 2;
                
                %store the average spike rate
                obj.itsAverageSpikeRate(:,binNum) = sum(countMat(:, startIdx : endIdx), 2) / secPerBin; 
            end
            
            %compute for the last bin
            samplesPerBin = varLength - (samplesPerBin * (obj.itsNumBins-1));
            secPerBin = (samplesPerBin / obj.expData.samplingRate);
            obj.itsBinnedVariable(end) = (sVar(endIdx+1) + sVar(end)) / 2;    
            startIdx = endIdx+1;
            obj.itsAverageSpikeRate(:,end) = sum(countMat(:, startIdx : end), 2) / secPerBin; 
            
            obj.itsBinnedVariable = fliplr(obj.itsBinnedVariable);
            obj.itsAverageSpikeRate = fliplr(obj.itsAverageSpikeRate);
            
            
            %for each cell, compute the spline
            obj.itsPeakRate = zeros(1, obj.expData.cellCount);
            obj.itsSplineFits = CSFit.empty(0,obj.expData.cellCount);
            for (cellNum = 1:obj.expData.cellCount)
                %perform spline fit
                obj.itsSplineFits(cellNum) = CSFit(obj.itsBinnedVariable, obj.itsAverageSpikeRate(cellNum, :), obj.itsSplineType, obj.itsSplineParams);
                
                %get the current spline for determine the peak firing rate
                %off the spline fit
                currSpline = obj.itsSplineFits(cellNum);
                currSpline = currSpline.splineFunc;
                
                %first, compute first derivitive of the spline
                dCs = currSpline;
                dCs.order = currSpline.order-1;
                dCs.coefs = bsxfun(@times, currSpline.coefs(:,1:end-1), dCs.order:-1:1);
                
                %identify all the zero crossings (potentially at each knot,
                %and at the zeros of a cubic where 3ax^2 + 2bx + cx = 0)
                coefs = dCs.coefs;
                offset1 = -(coefs(:,2) + (coefs(:,2).^2 - 4.*coefs(:,1).*coefs(:,3)).^.5)./(2.*coefs(:,1));
                offset2 = -(coefs(:,2) - (coefs(:,2).^2 - 4.*coefs(:,1).*coefs(:,3)).^.5)./(2.*coefs(:,1));
                pos = [obj.itsBinnedVariable,obj.itsBinnedVariable(1:end-1)+offset1',obj.itsBinnedVariable(1:end-1)+offset2'];
                pos(imag(pos) ~= 0) = [];
                pos((pos < obj.itsBinnedVariable(1)) | (pos > obj.itsBinnedVariable(end))) = [];       
                zc = fnval(dCs, pos);
                idx = find(abs(zc) < 10^-10);
                zc = pos(idx);
                
                %the max firing rate is either a zero crossing or an
                %endpoint
                zc = [zc, obj.itsBinnedVariable(1), obj.itsBinnedVariable(end)];
                mx = fnval(currSpline, zc);
                [mx,mxpos] = max(mx);
                mxpos = zc(mxpos);
                obj.itsPeakRate(cellNum) = mx;
                
                figure;
                xx = obj.itsBinnedVariable(1):.001:obj.itsBinnedVariable(end);
                semilogx(xx, fnval(currSpline, xx));
                hold on; semilogx(mxpos, mx,'o');hold off;
                pause;
            end%end loop over cells
        end
    end
    
    %#########################################################################
    %constructor/destructor
    %#########################################################################
    methods (Access = public)
        %create a new SpikeData object from spike times, assuming units are in seconds.
        function newTC = TuningCurve(splineType, splineP)            
            if nargin >= 1               
                newTC.itsSplineType = splineType;                
            end
            if nargin >= 2
                sp = containers.Map();
                sp('p') = splineP;
                newTC.itsSplineParams = sp;
            end            
        end
    end
        
end % classdef