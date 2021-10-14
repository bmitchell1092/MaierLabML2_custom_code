function savestereoeyecal(xdva, ydva, xV, yV, ScreenInfo)

global STEREOSHIFT

% check STEREOSHIFT
if  isempty(STEREOSHIFT)
    setStereoShift;
end

% undo "findScreenPos" to get cord relative to each eye's view
if xdva > 0 
    % RIGHT side of screen
    newcenter  = 0  + (ScreenInfo.Xsize/ScreenInfo.PixelsPerDegree)/4;
    ssX        = STEREOSHIFT.rightX;
    ssY        = STEREOSHIFT.rightY;
else
    % LEFT side of screen
    newcenter  = 0 - (ScreenInfo.Xsize/ScreenInfo.PixelsPerDegree)/4;
    ssX        = STEREOSHIFT.leftX;
    ssY        = STEREOSHIFT.leftY;
end
xeye = newcenter + -1*(xdva - ssX);
yeye =  ydva - ssY;

p = getpref('MonkeyLogic');
fpath = p.Directories.ExperimentDirectory;
fname = [date '-stereoeyecal.txt'];
stereofilename = [fpath fname];

if exist(stereofilename,'file') == 0
    % open new file
    fid = fopen(stereofilename, 'w');
    % header:
    formatSpec =  '%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n';
    fprintf(fid,formatSpec,...
        'Xml',...
        'Yml',...
        'Xeye',...
        'Yeye',...
        'Xvol',...
        'Yvol',...
        'timestamp');
else
    % append
    fid = fopen(stereofilename, 'a');
end
formatSpec =  '%f\t%f\t%f\t%f\t%f\t%f\t%f\r\n';
fprintf(fid,formatSpec,...
    xdva,...
    ydva,...
    xeye,...
    yeye,...
    xV,...
    yV,...
    now);

fclose(fid);