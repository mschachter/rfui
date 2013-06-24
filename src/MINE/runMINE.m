function R = runMINE(M)
%path - path to write input
%M - is a variable x observation matrix 
%header - is a cell array with the same number of elements as M has rows
if (~ismatrix(M))
    error('first argument must be a matrix of at least two columns');
end

if (size(M,1) > 2)
    error('This function currently only processes two variables');
end

fullPath = mfilename('fullpath');
[minePath, mfile, ext] = fileparts(fullPath);

outputPath = tempdir();

%write the text file
inputPath = fullfile(outputPath, 'input.csv');
header={'x', 'y'};
writeMINEInput(inputPath, M, header);

outputPath = fullfile(outputPath, 'output.txt');

%run the MINE software
jarPath = fullfile(minePath, 'MINE.jar');
cmd = sprintf('java -jar "%s" "%s" -allPairs', jarPath, inputPath);
system(cmd);

R = dlmread([inputPath,',allpairs,cv=0.0,B=n^0.6,Results.csv'],',',[1 2 1 2]);

p1 = fullfile(outputPath, '*.csv');
p2 = fullfile(outputPath, '*.txt');
delete(p1);
delete(p2);

