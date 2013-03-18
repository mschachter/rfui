%#########################################################################
%TuningCurve
%
%A class to to compute and display tuning curves for neurons recorded from
%an electrode array in a single experimental session
%
% example:
% tc = TuningCurve('smoothing', .5);
% tc.expData = ExpData('../../data/data1.csv', 'sig[0-9]*[a-b]*');
% tc.useSubplots = 1;
% tc.plotTuningCurve
%#########################################################################
classdef TuningCurve < handle 
    
    %#########################################################################
    %events
    %#########################################################################
    events       
        TuningCurveJustFit;        
    end
    
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
        
        %apply an offset to the data by subtracting this value from the spike
        %times
        timeOffset
    end
    
    %#########################################################################
    %read/write properties
    %#########################################################################
    properties (GetAccess = public, SetAccess = public)
        %a ExpData class
        expData;
        
        %the plot type : normal, semilogx
        plotType;
        
        %plot all in subplots
        useSubplots;
        
        %number of subplots (rows, cols) per figure
        numSubplots;
        
        %cells to compute tuning curves for
        selectedCells;
        
    end
    
    %#########################################################################
    %read-only properties
    %#########################################################################
    properties (GetAccess = public, SetAccess = private)
       %flag variables
        updateData; 
    end
    
    %#########################################################################
    %private properties
    %#########################################################################
    properties (GetAccess = private, SetAccess = private)
        %binned continous variable data
        itsBinnedVariable;
        
        %average spike rate in each bin
        itsAverageSpikeRate;
        
        %the spline fits for each cell
        itsSplineFits;
        
        %the peak firing rate of the tuning curve
        itsPeakRate;
        
        %number of bins for computation
        itsNumBins;
        
        %variable of interest
        itsExpVariable;
        
        %smooth the variable of interest with a filter this wide in seconds
        itsFilterWidth;
        
        %apply an offset to the data by adding this value to the spike
        %times
        itsTimeOffset;
        
        %spline parameters
        itsSplineParams;
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
            if (~strcmpi(obj.itsExpVariable,value))
                obj.updateData = 1;
                obj.itsExpVariable = value;                
            end
        end
        
        %called when filterWidth is set
        function set.filterWidth(obj, value)
            if (obj.itsFilterWidth ~= value)
                obj.updateData = 1;
                obj.itsFilterWidth = value;
            end
        end
        
        %called when timeOffset is set
        function set.timeOffset(obj, value)
            if (obj.itsTimeOffset ~= value)
                obj.updateData = 1;
                obj.itsTimeOffset = value;
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
        
        %called when timeOffset is accessed
        function ret = get.timeOffset(obj)
            if (obj.updateData)
                computeTuningCurve(obj);
                obj.updateData = 0;
            end
            ret = obj.itsTimeOffset;
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
        function plotTuningCurve(obj, cellNum, newFigure)
            
            if (obj.updateData)
                computeTuningCurve(obj);
                obj.updateData = 0;
            end
            
            if nargin < 3
                newFigure = 1;
            end
            
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
                cellsToPlot = find(obj.selectedCells == cellNum);                
                if isempty(cellsToPlot)
                    error('No tuning curve computed for cell number %d', cellNum);
                end
            else
                cellsToPlot = 1:length(obj.selectedCells);
            end
            
            %set up number of figures and plots per figure
            numPlotsPerFig = 1;
            if newFigure
                baseFig = figure();
            end
            if obj.useSubplots && length(cellsToPlot) > 1
                numPlotsPerFig = obj.numSubplots(1)*obj.numSubplots(2);
            end
            
            spNum = 1;
            %plot binned variable vs average spike rate                        
            for cpi = 1:length(cellsToPlot)
                cellIndex = cellsToPlot(cpi);
                %get the current figure and subplot numbers
                if obj.useSubplots && length(cellsToPlot) > 1
                    currentFig = ceil(cellIndex / numPlotsPerFig) - 1 + baseFig;
                    if (spNum > numPlotsPerFig)
                        spNum = 1;
                    end
                    figure(currentFig); hold on;
                    subplot(obj.numSubplots(1), obj.numSubplots(2), spNum); 
                    spNum = spNum + 1;
                elseif newFigure
                    figure(baseFig + cpi - 1);
                end   
                    
                if (strcmpi(obj.plotType, 'normal'))
                    h = plot(obj.binnedVariable, obj.averageSpikeRate(cellIndex,:), 'o');
                elseif (strcmpi(obj.plotType, 'semilogx'))
                    h = semilogx(obj.binnedVariable, obj.averageSpikeRate(cellIndex,:), 'o');
                    %h = plot(log10(obj.binnedVariable+1), obj.averageSpikeRate(cellsToPlot(cellNum),:), 'o');
                    %set(gca, 'xtick', obj.binnedVariable);
                else
                    error('Not a valid plot type. Valid types are ''normal'', and ''semilogx''');
                end
                set(h,'MarkerEdgeColor','none','MarkerFaceColor',[.5 .5 .5])
                
                %plot spline fit
                currSpline = obj.splineFits(cellIndex);
                xx = obj.binnedVariable(1):.01:obj.binnedVariable(end);
                yy = currSpline.eval(xx);
                hold on;
                semilogx(xx, yy,'color',[0 0 0]);
                %plot(log10(xx+1), yy,'color',[0 0 0]);
                hold off;
                
                %set title
                r2 = currSpline.R2;
                title(['$R^2$=', num2str(round(r2*100)/100)],'interpreter','latex','fontsize',10);
            end
        end
    end
    
    %#########################################################################
    %private methods
    %#########################################################################
    methods (Access = public)
        %compute the tunning curve data
        function computeTuningCurve(obj)
            if (isempty(obj.expData))
                error('the ''expData'' property must be set before accessing other properties or plotting');
            end
            
            if isempty(obj.selectedCells)
                obj.selectedCells = 1:obj.expData.cellCount;
            end
            
            %sort the continuous variable
            myVar = smoothVarByName(obj.expData, obj.expVariable, obj.filterWidth);
            [sVar, ord] = sort(myVar, 'descend');
            varLength = length(myVar);
            
            numCells = length(obj.selectedCells);
            
            %sort the spike data the same way
            countMat = zeros(numCells, varLength);
            for cellIndex = 1:numCells
                cellNum = obj.selectedCells(cellIndex);
                cell = getCellByNum(obj.expData, cellNum);
                spikeCount = histc(cell.spikeTimes-obj.itsTimeOffset, obj.expData.recordingTime);
                countMat(cellIndex, :) = spikeCount(ord);
            end
            
            %compute samples per bin given that each bin has the same amount of data - the last bin will have up to
            %(numBins-1)/2 extra samples or fewer samples
            samplesPerBin = floor(varLength / obj.itsNumBins);
            secPerBin = (samplesPerBin / obj.expData.samplingRate);
            
            obj.itsBinnedVariable = zeros(1, obj.itsNumBins);
            obj.itsAverageSpikeRate = zeros(numCells, obj.itsNumBins);
            
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
            obj.itsPeakRate = zeros(1, length(obj.selectedCells));
            obj.itsSplineFits = CSFit.empty(0,length(obj.selectedCells));
            for cellIndex = 1:numCells
                cellNum = obj.selectedCells(cellIndex);
                
                %perform spline fit
                obj.itsSplineFits(cellIndex) = CSFit(obj.itsBinnedVariable, obj.itsAverageSpikeRate(cellIndex, :),...
                                                     obj.itsSplineParams('dof'), obj.itsSplineParams('knots'));
                
                %get the current spline for determine the peak firing rate
                %off the spline fit
                currSpline = obj.itsSplineFits(cellIndex);
                currSpline = currSpline.splineFunc;
                
                %first, compute first derivitive of the spline
                dCs = currSpline;
                dCs.order = currSpline.order-1;
                dCs.coefs = bsxfun(@times, currSpline.coefs(:,1:end-1), dCs.order:-1:1);
                
                %identify all the zero crossings (potentially at each knot,
                %and at the zeros of the spline
                coefs = dCs.coefs;
                
                compZero = 1;
                if (currSpline.order == 4)
                    %-(b + (b^2 - 3*a*c)^(1/2))/(3*a)
                    %-(b - (b^2 - 3*a*c)^(1/2))/(3*a)
                    offset1 = -(coefs(:,2) + (coefs(:,2).^2 - 3.*coefs(:,1).*coefs(:,3)).^.5)./(3.*coefs(:,1));
                    offset2 = -(coefs(:,2) - (coefs(:,2).^2 - 3.*coefs(:,1).*coefs(:,3)).^.5)./(3.*coefs(:,1));
                elseif (currSpline.order == 3)
                    %-b/(2*a)
                    offset1 = -coefs(:,2)./(2.*coefs(:,1));
                    offset2 = offset1;
                elseif (currSpline.order == 2)    
                    compZero = 0;
                else
                    error('only order 4 (cubic), 3 (quadratic), or 2 (linear) splines allowed');
                end
                    
                if (compZero)
                    %pair up the zero solutions by knot
                    z = [offset1, offset2];
                
                    %get all the real-valued positive roots
                    z(imag(z) ~= 0 | z < min(obj.itsBinnedVariable) | z > max(obj.itsBinnedVariable) ) = nan;
                
                    %get the actual values of the roots on the binned variable axis                
                    zeroCrossings = bsxfun(@plus, z, dCs.breaks(1:end-1)');
                    zeroCrossings = zeroCrossings(~isnan(zeroCrossings));
                    zeroCrossings = zeroCrossings(:);

                    %evaluate the derivative at the zero crossings
                    zc = ppval(dCs, zeroCrossings);                
                    zc = zeroCrossings( abs(zc) < 10^-10 );
                
                    %the max firing rate is either a zero crossing or an
                    %endpoint
                    zc = [zc', obj.itsBinnedVariable(1), obj.itsBinnedVariable(end)];
                else
                    zc = [obj.itsBinnedVariable(1), obj.itsBinnedVariable(end)];
                end
                
                mx = ppval(currSpline, zc);
                obj.itsPeakRate(cellIndex) = max(mx);
                
                %broadcast event that tuning curve was fit for cell
                notify(obj,'TuningCurveJustFit', TuningCurveJustFitEventData(obj.expData.cellNames{cellNum}, cellIndex));
                
            end%end loop over cells
        end
    end
    
    %#########################################################################
    %constructor/destructor
    %#########################################################################
    methods (Access = public)
        %create a new TuningCurve object given a spline type and spline
        %parameters if supplied
        function newTC = TuningCurve(splineDoF, splineKnots)
    
            newTC = newTC@handle();
            
            newTC.expData = [];
            newTC.plotType = 'semilogx';
            newTC.useSubplots = 0;
            newTC.numSubplots = [6, 6];
            newTC.selectedCells = [];
            newTC.updateData = 1; 
            newTC.itsBinnedVariable = [];
            newTC.itsAverageSpikeRate = [];
            newTC.itsSplineFits = [];
            newTC.itsPeakRate = [];
            newTC.itsNumBins = 20;
            newTC.itsExpVariable = 'Velocity(Center-point)';
            newTC.itsFilterWidth = 1;
            newTC.itsTimeOffset = 0;
            newTC.itsSplineParams = containers.Map();        
            
            if nargin < 1
                splineDoF = 4;
            end
            
            newTC.itsSplineParams('dof') = splineDoF;
            
            if nargin < 2
                splineKnots = [];
            end
            
            newTC.itsSplineParams('knots') = splineKnots;
        end
    end
        
end % classdef
