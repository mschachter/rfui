%#########################################################################
% SpikeData
%
% A class to represent spiking data from a single neuron
%  
% example : 
% sp = SpikeData([.0001 .003 .004 .005 .02 .023 .024 .05 .055 .057 .09 .1 .12 .13 .15]);
% sp.spikeRateType = 'Gaussian';
% plot(sp.timeStamp, sp.spikeRate)
%
%#########################################################################
classdef SpikeData < handle 
    
    %#########################################################################
    %configureation properties read/write
    %#########################################################################
    properties (Dependent = true, GetAccess = public, SetAccess = public)
        %the resolution of continous variables computed from spike times in Hz
        samplingResolution
        
        %set the spikerate type ('MovingAverage', 'Gaussian', 'Alpha')
        spikeRateType
        
        %width of filter for spike rate in seconds
        spikeRateFilterWidth
    end
    
    %#########################################################################
    %read-only properties
    %#########################################################################
    properties (Dependent = true, GetAccess = public, SetAccess = private)
        %time of spikes in seconds
        spikeTimes
        
        %spike count at desired resolution
        spikeCount
        
        %time stamps for of variables computed from spike times
        timeStamp
        
        %spike rate moving average
        spikeRate
    end
    
    %#########################################################################
    %private properties
    %#########################################################################
    properties (GetAccess = private, SetAccess = private)
        %flag properties
        updateSpikeCount = 1;
        updateSpikeRate = 1;
        
        %private versions of dependent
        itsSamplingResolution = 1000 %in Hz
        itsSpikeRateType = 'Gaussian';
        itsSpikeRateFilterWidth = .015; %in seconds
        itsSpikeTimes = [];
        itsSpikeCount = [];
        itsTimeStamp = [];
        itsSpikeRate = [];
        itsRecordingStartTime = 0;
    end
    
    %#########################################################################
    %'Set' properties methods
    %#########################################################################
    methods
        %called when samplingResolution is set
        function set.samplingResolution(obj, value)
            if (obj.itsSamplingResolution ~= value)
                obj.updateSpikeCount = 1;
                obj.updateSpikeRate = 1;
                obj.itsSamplingResolution = value; 
            end
        end
        
        %called when spikeRateType is set
        function set.spikeRateType(obj, value)
            if (~strcmpi(obj.itsSpikeRateType,value))
                obj.updateSpikeRate = 1;
                obj.itsSpikeRateType = value;
            end
        end
        
        %called when spikeRateFilterWidth is set
        function set.spikeRateFilterWidth(obj, value)
            if (obj.itsSpikeRateFilterWidth ~= value)
                obj.updateSpikeRate = 1;     
                obj.itsSpikeRateFilterWidth = value;
            end
        end
    end
    
    %#########################################################################
    %'Get' properties methods
    %#########################################################################
    methods
        %called when samplingResolution is accessed
        function ret = get.samplingResolution(obj)
            ret = obj.itsSamplingResolution;
        end
        
        %called when spikeRateType is accessed
        function ret = get.spikeRateType(obj)
            ret = obj.itsSpikeRateType;
        end
        
        %called when spikeRateFilterWidth is accessed
        function ret = get.spikeRateFilterWidth(obj) 
            ret = obj.itsSpikeRateFilterWidth;
        end
        
        %called when spikeTimes is accessed
        function ret = get.spikeTimes(obj) 
            ret = obj.itsSpikeTimes;
        end
        
        %called when spikeCount is accessed
        function ret = get.spikeCount(obj)
            if (obj.updateSpikeCount)
                createSpikeCountVector(obj);
                obj.updateSpikeCount = 0;                
            end
            ret = obj.itsSpikeCount;
        end
        
        %called when timeStamp is accessed
        function ret = get.timeStamp(obj)
            if (obj.updateSpikeCount)
                createSpikeCountVector(obj);
                obj.updateSpikeCount = 0;                
            end
            ret = obj.itsTimeStamp;
        end
        
        %called when spikeRate is accessed
        function ret = get.spikeRate(obj)
            if (obj.updateSpikeCount)
                createSpikeCountVector(obj);
                createSpikeRateFunction(obj);
                obj.updateSpikeRate = 0;                
                obj.updateSpikeCount = 0;                
            end
          
            if (obj.updateSpikeRate)
                createSpikeRateFunction(obj);
                obj.updateSpikeRate = 0;                
            end
            ret = obj.itsSpikeRate;
        end
    end
    
    %#########################################################################
    %private methods
    %#########################################################################
    methods (Access = private)
        %get the spike times as a vector of spike counts at samplingResolution
        function createSpikeCountVector(obj)
            times = floor(obj.itsSpikeTimes*obj.itsSamplingResolution);
            obj.itsSpikeCount = zeros(1, times(end)+1);
            utimes = unique(times);
            count = histc(times, utimes);
            obj.itsSpikeCount(utimes+1) = count;
            obj.itsTimeStamp = (0:(length(obj.itsSpikeCount)-1))./obj.itsSamplingResolution;
            obj.itsTimeStamp = obj.itsTimeStamp + obj.itsRecordingStartTime;
        end
        
        %create a spike rate from a vector of spike counts
        function createSpikeRateFunction(obj)
            if (strcmpi('MovingAverage', obj.spikeRateType))
                filter = ones(1, floor(obj.itsSpikeRateFilterWidth*obj.itsSamplingResolution));
                filter = filter ./ length(filter) * obj.itsSamplingResolution;
                
            elseif (strcmpi('Gaussian', obj.itsSpikeRateType))
                filter = sdfGaussian(obj.itsSpikeRateFilterWidth, obj.itsSamplingResolution);
                
            elseif (strcmpi('Alpha', obj.itsSpikeRateType))
                filter = sdfAlpha(obj.itsSpikeRateFilterWidth, obj.itsSamplingResolution);
                
            else
                error('no such ''spikeRateType'', valid parameters are ''MovingAverage'', ''Gaussian'', ''Alpha''');
            end
            obj.itsSpikeRate = conv(obj.itsSpikeCount, filter, 'same');
        end
    end
             
    %#########################################################################
    %constructor/destructor
    %#########################################################################
    methods (Access = public)
        %create a new SpikeData object from spike times, assuming units are in seconds.
        function newSD = SpikeData(newSpikeTimes, recordingStartTime)
            if ((nargin < 1) || (~isa(newSpikeTimes, 'double')))
                error('argument must of an array of doubles representing spike times');    
            end 
            newSpikeTimes(isnan(newSpikeTimes) == 1) = [];
            newSD.itsSpikeTimes = newSpikeTimes;
            
            if (nargin > 1)
                newSD.itsRecordingStartTime = recordingStartTime;
            end
        end
    end
    
end %classdef