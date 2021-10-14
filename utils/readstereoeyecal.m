function obs = readstereoeyecal(filename, startRow, endRow)

% Initialize variables.
delimiter = '\t';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

% GET HEADER
fileID = fopen(filename,'r');
headers = textscan(fileID,'%s%s%s%s%s%s%s\r\n',1, 'Delimiter', delimiter);
fclose(fileID);

% GET DATA
% Format string for each line of text:
formatSpec =  '%f%f%f%f%f%f%f\r\n';

% Open the text file.
fileID = fopen(filename,'r');

% Read columns of data according to format string.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

% Close the text file.
fclose(fileID);

% Allocate imported array obs structure
for i = 1:length(dataArray{1})
    for j = 1:length(headers)
        obs(i).(char(headers{j})) = dataArray{j}(i);
    end
end

