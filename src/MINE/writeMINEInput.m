function writeMINEInput(path, M, header)
%path - path to write input
%M - is a variable x observation matrix 
%header - is a cell array with the same number of elements as M has rows
if (~ismatrix(M))
    error('first argument must be a matrix of at least two columns');
end

if (~iscell(header))
    error('header must be a cell array of vaible names');
end

if (length(header) ~= size(M, 1))
    error('The header cell array must have the same number of elements as the input matrix has rows');
end

ferp = fopen (path, 'w');

for (ii = 1:length(header)-1)
    fprintf(ferp, '%s,', header{ii});
end
fprintf(ferp, '%s\n',header{end});

fprintf(ferp, '%1.6f, %1.6f\n', M);
