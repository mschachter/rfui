function testHeatMap(dataFilePath)

edata = ExpData(dataFilePath, 'sig[0-9]*[a-b]*');
tc = TuningCurve(3,4);
tc.expData = edata;
tc.filterWidth = 1;

%show with order 3 and 4 knots
hm = HeatMap;
hm.tuningCurve = tc;
hm.lagTime = .1;%100ms lags
hm.numLags = 10; %50 lags at .01sec is 5 sec of lag
hm.plotType = 'semilogx';
hm.numYAxisBins = 100;
hm.useSubplots = 1;
hm.numSubplots = [5, 4];
hm.plotHeatMap();

%show with order 4 and as many knots as points for some selected cells
tc = TuningCurve(4);
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

%just show the 5th cell
hm.plotHeatMap(5);

