%#########################################################################
%ExpData
%
%A class to represent experimental data (spike times, stimulus properties,
%continous variable recorded during the experiment etc...).
%
% example:
% ed = ExpData('../../data/testdata.csv', 'sig*');
% v = getVarByName(ed, 'Velocity(Center-point)'); %or d = ed.getVarByName('Velocity(Center-point)');
%
% vs = ed.smoothVarByName('Velocity(Center-point)',.1); 
% rt = getVarByName(ed, 'Recording time');
%
% ed.cellSpikeRateType = 'Gaussian';
% ed.cellSpikeRateFilterWidth = .1;
% ed.cellSamplingResolution = ed.samplingRate;
% c = getCellByNum(ed, 4);
%
% subplot(2,1,1);
% plot(c.timeStamp(1:500), c.spikeRate(1:500));
% subplot(2,1,2);
% plot(rt(1:500), vs(1:500));
%#########################################################################
classdef ExpData < handle 

    %#########################################################################
    %read-only dependent properties
    %#########################################################################
    properties (Dependent = true, GetAccess = public, SetAccess = private)
        %name of each continous variable
        variableNames
        
        %name of each cell
        cellNames
        
        %numer of variables
        variableCount
        
        %number of cells
        cellCount 
    end
    
    %#########################################################################
    %read/write properties
    %#########################################################################
    properties (Dependent = true, GetAccess = public, SetAccess = public)        
        %samplling resolution in seconds
        cellSamplingResolution;
        
        %spike rate type (exp, gaussian, alpha)
        cellSpikeRateType;
        
        %spike rate filter width in seconds
        cellSpikeRateFilterWidth;
    end
    
    %#########################################################################
    %read-only properties
    %#########################################################################
    properties (GetAccess = public, SetAccess = private)
        %data file name
        fileName;
        
        %average sampling rae
        samplingRate;
        
        %recording time offset
        recordingTime;
    end
    
    %#########################################################################
    %private properties
    %#########################################################################
    properties (GetAccess = private, SetAccess = private)
        % map with string keys a vector values
        varDataMap;
        
        %a map with string keys and SpikeData values
        cellDataMap;
        
        %samplling resolution in seconds
        itsCellSamplingResolution;
        
        %spike rate type (exp, gaussian, alpha)
        itsCellSpikeRateType;
        
        %spike rate filter width in seconds
        itsCellSpikeRateFilterWidth;
    end
    
    %#########################################################################
    %'Get' properties methods for dependent variables
    %#########################################################################
    methods
        %called when variableNames is accessed
        function ret = get.variableNames(obj)
            ret = obj.varDataMap.keys();
        end
        
        %called when cellNames is accessed
        function ret = get.cellNames(obj)
            ret = obj.cellDataMap.keys();
        end
        
        %called when variableCount is accessed
        function ret = get.variableCount(obj)
            ret = int32(obj.varDataMap.Count);
        end
        
        %called when cellNames is accessed
        function ret = get.cellCount(obj)
            ret = int32(obj.cellDataMap.Count);
        end
       
        %called when cellSamplingResolution is accessed
        function ret = get.cellSamplingResolution(obj)
            ret = obj.itsCellSamplingResolution;
        end
        
        %called when cellSpikeRateType is accessed
        function ret = get.cellSpikeRateType(obj)
            ret = obj.itsCellSpikeRateType;
        end
        
        %called when cellSpikeRateFilterWidth is accessed
        function ret = get.cellSpikeRateFilterWidth(obj)
            ret = obj.itsCellSpikeRateFilterWidth;
        end
    end 
    
    %#########################################################################
    %'Set' properties methods
    %#########################################################################
    methods
        %called when cellSamplingResolution is accessed
        function set.cellSamplingResolution(obj, value)
            obj.cellSamplingResolution = value;
            updateSpikeSamplingRes(obj);
        end
        
        %called when cellSpikeRateType is accessed
        function set.cellSpikeRateType(obj, value)    
            obj.cellSpikeRateType = value;
            updateSpikeRateType(obj);
        end
        
        %called when cellSpikeRateFilterWidth is accessed
        function set.cellSpikeRateFilterWidth(obj, value)    
            obj.cellSpikeRateFilterWidth = value;
            updateSpikeFilterWidth(obj);            
        end
    end 
    
    %#########################################################################
    %public methods methods
    %#########################################################################
    methods (Access = public)
        %get the data for a variable by name
        function ret = getVarByName(obj, varNameStr)
            if (~obj.varDataMap.isKey(varNameStr))
                error('No such variable name');
            end
            ret = obj.varDataMap(varNameStr);
        end
        
        %get the data for a cell by name
        function ret = getCellByName(obj, cellNameStr)
            if (~obj.varDataMap.isKey(cellNameStr))
                error('No such cell name');
            end
            ret = obj.cellDataMap(cellNameStr);
        end
        
        %get the data for a variable by number
        function ret = getVarByNum(obj, varNum)
            keys = obj.varDataMap.keys();
            if (varNum > length(keys))
                error ('variable number out of range, check ''variableCount''');
            end
            ret = obj.varDataMap(keys{varNum});
        end
        
        %get the data for a cell by number
        function ret = getCellByNum(obj, cellNum)
            keys = obj.cellDataMap.keys();
            if (cellNum > length(keys))
                error ('cell number out of range, check ''cellCount''');
            end
            ret = obj.cellDataMap(keys{cellNum});
        end
        
        %return a smoothed variable my name
        function ret = smoothVarByName(obj, varNameStr, filterWidth)
            if (nargin < 3)
                error(['function requires the object (if not using . notation),'...
                    'variable name, and filter width in seconds']);
            end
            
            if (~obj.varDataMap.isKey(varNameStr))
                error('No such variable name');
            end
            
            var = obj.varDataMap(varNameStr);
            ret = filterVariable(obj, var, filterWidth);
            
        end
        
        %return a smoothed variable by number
        function ret = smoothVarByNum(obj, varNum, filterWidth)
            if (nargin < 3)
                error(['function requires the object (if not using . notation),'...
                    'variable number, and filter width in seconds']);
            end
            var = getVarByNum(obj, varNum);
            ret = filterVariable(obj, var, filterWidth);
        end
    end
    
    %#########################################################################
    %private methods
    %#########################################################################
    methods (Access = private)
        % read data from a file
        readDataFromFile(obj, filePathStr, cellExprStr);
        
        %update the spike sampling res
        function updateSpikeSamplingRes(obj)
            for (cellNum = 1:obj.cellCount)
                cell = getCellByNum(obj, cellNum);
                cell.samplingResolution = obj.cellSamplingResolution;
            end
        end
        
        %update the spike rate filter width
        function updateSpikeFilterWidth(obj)
            for (cellNum = 1:obj.cellCount)
                cell = getCellByNum(obj, cellNum);
                cell.spikeRateFilterWidth = obj.cellSpikeRateFilterWidth;
            end
        end
        
        %update the spike rate filter type
        function updateSpikeRateType(obj)
            for (cellNum = 1:obj.cellCount)
                cell = getCellByNum(obj, cellNum);
                cell.spikeRateType = obj.cellSpikeRateType;
            end
        end
            
        %filter a variable
        function ret = filterVariable(obj, var, filterWidth)
            filter = ones(1, floor(filterWidth*obj.samplingRate));
            filter = filter ./ length(filter);            
            ret = conv(var, filter, 'same');     
        end
    end
        
    %#########################################################################
    %constructor/destructor
    %#########################################################################
    methods (Access = public)
        
        %constructor
        function newED = ExpData(dataFileNameStr, cellExprStr)
            if ((nargin ~= 2) || ~isa(dataFileNameStr, 'char') || ~isa(cellExprStr, 'char'))
                error (['The constructor must take two string arguments for the filename and a regular expression'...
                    'to match column headers than contain neural data']);
            end
            
            if (~exist(dataFileNameStr,'file'))
                error('Data file cannot be found');
            end
            
            newED = newED@handle();
          
            newED.recordingTime = [];
            newED.itsCellSamplingResolution = 1000;
            newED.itsCellSpikeRateType = 'Gaussian';
            newED.itsCellSpikeRateFilterWidth = .015;
            newED.varDataMap = containers.Map();
            newED.cellDataMap = containers.Map();
            
            newED.fileName = dataFileNameStr;
            
            %read the data
            readDataFromFile(newED, dataFileNameStr, cellExprStr);
            
            %set the sampling rate
            newED.samplingRate = (1 / mean(diff(getVarByName(newED, 'Recording time'))));
            
            %propogate default in ExpData to all the cell's
            updateSpikeSamplingRes(newED);
            updateSpikeFilterWidth(newED);
            updateSpikeRateType(newED);
        end
    end
end % classdef

