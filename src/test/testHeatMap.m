function testHeatMap(dataFilePath)

edata = ExpData(dataFilePath, 'sig[0-9]*[a-b]*');
tc = TuningCurve('smoothing', 0.5);
tc.expData = edata;
tc.filterWidth = 1;

hm = HeatMap;
hm.tuningCurve = tc;
hm.lagTime = .1;%100ms lags
hm.numLags = 10; %50 lags at .01sec is 5 sec of lag
hm.plotType = 'semilogx';
hm.numYAxisBins = 100;
hm.useSubplots = 1;
hm.numSubplots = [5, 4];
hm.plotHeatMap();


tc = TuningCurve('smoothing', 0.5);
tc.expData = edata;
tc.selectedCells = [2, 5, 6];
tc.filterWidth = 1;

hm = HeatMap;
hm.tuningCurve = tc;
hm.lagTime = .1;%100ms lags
hm.numLags = 10; %50 lags at .01sec is 5 sec of lag
hm.plotType = 'semilogx';
hm.numYAxisBins = 100;
hm.useSubplots = 1;
hm.numSubplots = [5, 4];
hm.plotHeatMap();

hm.plotHeatMap(5);

