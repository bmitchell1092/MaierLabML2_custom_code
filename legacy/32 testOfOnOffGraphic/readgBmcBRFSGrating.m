function grating = readgBmcBRFSGrating(filename)
 
%% output is structure array describing stimuli on each trial

% MAC, DEC 2014
% Made with help from MATLAB import data
% modified by Kacie for analyzing dot mapping code 
% additional revisions Jan 2016 to add more features / corrections, make backwards compatable

%% Check Input
[~,BRdatafile,ext] = fileparts(filename); 
if ~any(strcmp(ext,'.gbmcBRFSgrating_di'))
    error('wrong filetype for this function')
end



%% Initialize variables.
delimiter = '\t';
startRow = 2;
endRow = inf;


%% Format string for each line of text:
% For more information, see the TEXTSCAN documentation.

    fields = {...
         'trial',...
        'horzdva',...
        'vertdva',...
        'xpos',...
        'ypos',...
        'other_xpos',...
        'other_ypos',...
        'tilt',...
        'sf',...
        'contrast',...
        'fixedc',...
        'diameter',...
        'eye',...
        'varyeye',...
        'oridist',...
        'gaborfilter_on',...
        'gabor_std',...
        'header',...
        'phase',...
        'bmcBRFSparamNum',...
        'path',...
        'timestamp'};
    formatSpec =  '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n';


%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this code.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Allocate imported array to structure column variable names
if length(fields) ~= size(dataArray,2)
    error('bad formatSpec or structure fields for %s',filename)
end

st = 1;
en = length(dataArray{1});



for f = 1:length(fields)
    if any(strcmp(fields{f},{'header','path'}))
        grating.(fields{f}) = dataArray{f}(st:en);
    else
        grating.(fields{f}) = str2double(dataArray{f}(st:en));
    end
end

ntrls          = max(grating.trial); % total trials
npres          = mode(histc(grating.trial,1:max(grating.trial))); % number of "gen" calls written / trial, may be diffrent from RECORD & what was actually shown
grating.pres   = repmat([1:npres]',ntrls,1);

grating.filename = filename;
grating.startRow = st;
grating.endRow = en;


%% CORRECTIONS FOR SPECIFIC FILES / FILE TYPES

grating.contrast   = double(round( grating.contrast   .* 1000) / 1000);
grating.fixedc     = double(round( grating.fixedc .* 1000) / 1000);




