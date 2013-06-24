%#########################################################################
% Reads data from a CSV file. First line is a header with column names.
% Each column is variable length. Columns whose names match cellExpr are
% considered cells, and the values in the column spike times. All other
% columns are considered continuous variables.
%
% Arguments:
% filePathStr : path to CSV file. e.g. '~/downloads/temp/A2A-050811.csv'
% cellExtrStr : regex to determine columns with cell data. e.g.'sig*'
%#########################################################################
function readDataFromFile(obj, filePathStr, cellExprStr)

    %auto parse the file
    allData = importdata(filePathStr);     
    
    %first find the recording time start
    startTime = 0;
    for (colNum = 1:length(allData.colheaders))
        cName = allData.colheaders{colNum};
        if (strcmpi(cName, 'Recording time'))
            obj.recordingTime = allData.data(:, colNum);
            startTime = obj.recordingTime(1);
            
        end
    end
    
    %identify variable and cell columns and store data into maps
    for (colNum = 1:length(allData.colheaders))
        cName = allData.colheaders{colNum};

        %if we have two dilimeters in a row, we get an empty cName and can
        %just skip it
        if (isempty(cName))
            disp(['skipping empty column (#', num2str(colNum), ')']);
            continue;
        end
        
        rexpr = sprintf('(%s)', cellExprStr);
        matchStart = regexp(cName, rexpr, 'once');
        if ~isempty(matchStart)
            %store as a string - SpikeData pair
            obj.cellDataMap(cName) = SpikeData(allData.data(:, colNum), startTime);
        else            
            %store as a string - vector of doubles pair
            obj.varDataMap(cName) = allData.data(:, colNum);
        end        
    end
end
