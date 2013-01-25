%% Reads data from a csv file. First line is a header with column names.
%% Each column is variable length. Columns whose names match cellExpr are
%% considered cells, and the values in the column spike times. All other
%% columns are considered continuous variables.
%%
%% Example usage:
%%    sdata = readData('~/downloads/temp/A2A-050811.csv', 'sig*');
function sdata = readData(filePath, cellExpr)

    [allData, delim] = importdata(filePath);
    ncols = length(allData.colheaders);
        
    %% identify variable and cell rows, get all the data
    allColumnData = containers.Map();
    varColumns = containers.Map();
    cellColumns = containers.Map();
    for k = 1:ncols
        cname = allData.colheaders{k};
        [matchStart, matchEnd, tokenIndices, matchStrings,tokenStrings, tokenName, splitStrings] = regexp(cname, cellExpr);
        if ~isempty(matchStart)
            cellColumns(cname) = k;            
        else
            varColumns(cname) = k;
        end        
        cdata = allData.data(:, k);
        cdata = cdata(~isnan(cdata));
        allColumnData(cname) = cdata;        
    end
    
    sdata = struct;
    sdata.cellNames = cellColumns.keys();
    sdata.varNames = varColumns.keys();    
    sdata.columns = allColumnData;
    
end
