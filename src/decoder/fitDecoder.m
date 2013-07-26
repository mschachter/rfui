function results = fitDecoder(expData, varName, desiredDt, transform)

    if nargin < 2
        varName = 'Velocity(Center-point)';
    end
    
    if nargin < 3
        desiredDt = 0.100;
    end
    
    if nargin < 4
        transform = '';
    end    
    
    %% get recording time and sample rate
    t = expData.recordingTime;    
    maxt = max(t);
    mint = min(t);
    dt = diff(t);
    udt = unique(dt);
    
    %% get variable, interpolate to produce uniform sampling times
    y = expData.getVarByName(varName);    
    ti = mint:desiredDt:maxt;
    y = interp1(t, y, ti);    
    maxt = max(ti);
    mint = min(ti);
    dt = desiredDt;
    
    %% log transform variable if necessary
    if strcmp(transform, 'log')
        nzy = y > 0;
        y(nzy) = log(y(nzy));
    end
    %% derivative transform if necessary
    if strcmp(transform, 'derivative')
        y(2:end) = diff(y);
        y(1) = 0;
    end
        
    numCells = length(expData.cellNames);    
    nbins = round((maxt - mint) / dt) + 1;
    if nbins ~= length(y)
        error('nbins=%d, length(y)=%d', nbins, length(y));
    end    
    
    %% create a matrix of spike rates for the population
    spikeRates = zeros(nbins, numCells);
    for k = 1:numCells
        %% get spike times
        cellData = expData.getCellByNum(k);
        cellData.samplingResolution = desiredDt;
        spikeT = cellData.timeStamp;
        expIndex = (spikeT >= mint) & (spikeT <= maxt);
        spikeRates(:, k) = cellData.spikeCount(expIndex) / desiredDt;
    end
        
    %% create STRFLAB model
    groupIndex = ones(nbins, 1);
    global globDat;
    strfData(spikeRates, y', groupIndex);

    %% Initialize a linear model that extends back in time
    lagTime = 10; % in seconds
    strfLength = round(lagTime / desiredDt);
    strfDelays = 0:(strfLength-1);
    modelParams = linInit(numCells, strfDelays);

    %% initialize optimizer
    optOptions = trnThreshGradDesc();
    optOptions.display = 1;
    optOptions.threshold = 0.0;
    optOptions.maxIter = 5000;
    optOptions.stepSize = 1e-5;
    optOptions.earlyStop = 1;
    optOptions.gradNorm = 1;

    %% initialize training/early stopping/validation sets
    oneQuarter = round(nbins / 4);    
    threeQuarters = 3*oneQuarter;    
    trainingIndex = 1:(2*oneQuarter); 
    earlyStoppingIndex = (2*oneQuarter+1):threeQuarters;
    validationIndex = (threeQuarters+1):nbins;

    %% run optimization
    [modelParams, optOptions] = strfOpt(modelParams, trainingIndex, optOptions, earlyStoppingIndex);
    
    %% compute predictions and correlation coefficients
    [modelParams,trainingPred] = strfFwd(modelParams, trainingIndex);
    trainingPred(isnan(trainingPred)) = 0;
    ccMat = corrcoef([trainingPred, y(trainingIndex)']);
    trainingCC = ccMat(1, 2);
    
    [modelParams,earlyStoppingPred] = strfFwd(modelParams, earlyStoppingIndex);
    earlyStoppingPred(isnan(earlyStoppingPred)) = 0;
    ccMat = corrcoef([earlyStoppingPred, y(earlyStoppingIndex)']);
    earlyStoppingCC = ccMat(1, 2);
    
    [modelParams,validationPred] = strfFwd(modelParams, validationIndex);
    validationPred(isnan(validationPred)) = 0;
    ccMat = corrcoef([validationPred, y(validationIndex)']);
    validationCC = ccMat(1, 2);
    
    %% return results
    results = struct;
    results.modelParams = modelParams;
    results.varName = varName;
    
    results.t = ti;
    results.desiredDt = desiredDt;    
    
    results.transform = transform;
    results.y = y;
    
    results.spikeRates = spikeRates;
           
    results.trainingIndex = trainingIndex;
    results.trainingPred = trainingPred;
    results.trainingCC = trainingCC;
    
    results.earlyStoppingIndex = earlyStoppingIndex;
    results.earlyStoppingPred = earlyStoppingPred;
    results.earlyStoppingCC = earlyStoppingCC;
    
    results.validationIndex = validationIndex;
    results.validationPred = validationPred;
    results.validationCC = validationCC;
      

    
    