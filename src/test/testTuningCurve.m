function testTuningCurve(dataFilePath)

    edata = ExpData(dataFilePath, 'sig[0-9]*[a-b]*');
    
    tc1 = TuningCurve();
    tc1.expData = edata;
    tc1.filterWidth = 1;
    tc1.timeOffset = 0;
    tc1.useSubplots = 1;
    tc1.numSubplots = [5, 4];
    tc1.plotTuningCurve;
    
    tc2 = TuningCurve('smoothing', 0.5);
    tc2.expData = edata;
    tc2.filterWidth = 1;
    tc2.timeOffset = 0;
    tc2.useSubplots = 1;
    tc2.numSubplots = [4, 5];
    tc2.plotTuningCurve;
    