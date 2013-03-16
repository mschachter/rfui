function R = runMINE(pathtomine, M)
%path - path to write input
%M - is a variable x observation matrix 
%header - is a cell array with the same number of elements as M has rows
if (~ismatrix(M))
    error('first argument must be a matrix of at least two columns');
end

if (size(M,1) > 2)
    error('This function currently only processes two variables');
end

%write the text file
path = [pathtomine,'/input.csv'];
header={'x', 'y'};
writeMINEInput(path, M, header);

%run the MINE software
cmd = ['java -jar ',pathtomine,'/MINE.jar ',path,' -allPairs 1>NUL 2>NUL'];
system(cmd);

R = dlmread([path,',allpairs,cv=0.0,B=n^0.6,Results.csv'],',',[1 2 1 2]);

p1 = [pathtomine, '/*.csv'];
p2 = [pathtomine, '/*.txt'];
delete(p1)
delete(p2)

