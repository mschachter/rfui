function testTuningCurve(dataFilePath)

    edata = ExpData(dataFilePath, 'sig[0-9]*[a-b]*');
    
    tc1 = TuningCurve();
    tc1.expData = edata;
    tc1.filterWidth = 1;
    tc1.timeOffset = 0;
    tc1.useSubplots = 1;
    tc1.numSubplots = [5, 4];
    tc1.plotTuningCurve();
    
    tc3 = TuningCurve(4);
    tc3.expData = edata;
    tc3.selectedCells = [2, 5, 6];
    tc3.filterWidth = 1;
    tc3.timeOffset = 0;
    tc3.useSubplots = 1;
    tc3.numSubplots = [4, 5];
    tc3.plotTuningCurve();
    
    tc3.plotTuningCurve(5);