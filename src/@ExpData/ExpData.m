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
    %read-only properties
    %#########################################################################
    properties (GetAccess = public, SetAccess = private)
        fileName = '';
        samplingRate = 0;
    end
    
    %#########################################################################
    %read/write properties
    %#########################################################################
    properties (GetAccess = public, SetAccess = public)
        cellSamplingResolution = 1000
        cellSpikeRateType = 'Gaussian';
        cellSpikeRateFilterWidth = .015;
    end
    
    %#########################################################################
    %private properties
    %#########################################################################
    properties (GetAccess = private, SetAccess = private)
        % map with string keys a vector values
        varDataMap = containers.Map();
        
        %a map with string keys and SpikeData values
        cellDataMap = containers.Map();
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
            ret = obj.varDataMap.Count;
        end
        
        %called when cellNames is accessed
        function ret = get.cellCount(obj)
            ret = obj.cellDataMap.Count;
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
            ret = obj.varDataMap(varNameStr);
        end
        
        %get the data for a cell by name
        function ret = getCellByName(obj, cellNameStr)
            ret = obj.cellDataMap(cellNameStr);
        end
        
        %get the data for a variable by number
        function ret = getVarByNum(obj, varNum)
            keys = obj.varDataMap.keys();
            ret = obj.varDataMap(keys{varNum});
        end
        
        %get the data for a cell by number
        function ret = getCellByNum(obj, cellNum)
            keys = obj.cellDataMap.keys();
            ret = obj.cellDataMap(keys{cellNum});
        end
        
        %return a smoothed variable my name
        function ret = smoothVarByName(obj, varNameStr, filterWidth)
            if (nargin < 3)
                error(['function requires the object (if not using . notation),'...
                    'variable name, and filter width in seconds']);
            end
            filter = ones(1, floor(filterWidth*obj.samplingRate));
            filter = filter ./ length(filter);            
            ret = conv(obj.varDataMap(varNameStr), filter, 'same');    
        end
        
        %return a smoothed variable by number
        function ret = smoothVarByNum(obj, varNum, filterWidth)
            if (nargin < 3)
                error(['function requires the object (if not using . notation),'...
                    'variable number, and filter width in seconds']);
            end
            filter = ones(1, floor(filterWidth*obj.samplingRate));
            filter = filter ./ length(filter);            
            keys = obj.varDataMap.keys();
            ret = conv(obj.varDataMap(keys{varNum}), filter, 'same');    
        end
    end
    
    %#########################################################################
    %private methods
    %#########################################################################
    methods (Access = private)
        % read data from a file
        readDataFromFile(obj, filePathStr, cellExprStr)
        
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
            
            newED.fileName = dataFileNameStr;
            %read the data
            readDataFromFile(newED, dataFileNameStr, cellExprStr);
            
            %set the sampling rate
            newED.samplingRate = ceil(1 / mean(diff(getVarByName(newED, 'Recording time'))));
            
            %propogate default in ExpData to all the cell's
            updateSpikeSamplingRes(newED);
            updateSpikeFilterWidth(newED);
            updateSpikeRateType(newED);
        end
    end
end % classdef

