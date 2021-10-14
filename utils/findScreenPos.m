function [X,Y] = findScreenPos(TOcount,ScreenInfo,TH_or_X,E_or_Y,units)

% PUT EVEN TASK OBJECTS ON RIGHT SIDE OF MONITOR
% PUT ODD TASK OBJECTS ON LEFT SIDE OF MONITOR

% input can be ploar or cartesian, TH should be in degrees
% output is always cartesian
% all units are in dva

% Fall 2015, KD
% April 2016, MAC

global STEREOSHIFT
% check STEREOSHIFT
if  isempty(STEREOSHIFT)
    setStereoShift;
end

% check function input
if nargin < 5
    units = 'polar';
end
units = lower(units); 
    
% convert polar units to cartesian if needed
switch units
    case {'polar','p'}
        [hX, hY] = pol2cart(degtorad(TH_or_X),E_or_Y);
    case {'cart','cartesian','c'}
        hX = TH_or_X;
        hY = E_or_Y;
end
   

    
% get transform for left or right sides of screen
if mod(TOcount,2) == 0
    % if TO # is EVEN put this TO on RIGHT side of Screen(right eye)
    newcenter  = 0  + (ScreenInfo.Xsize/ScreenInfo.PixelsPerDegree)/4;
    ssX        = STEREOSHIFT.rightX;
    ssY        = STEREOSHIFT.rightY;
else
    % if TO # is ODD put this TO on LEFT side of Screen (left eye)
    newcenter  = 0 - (ScreenInfo.Xsize/ScreenInfo.PixelsPerDegree)/4;
    ssX        = STEREOSHIFT.leftX;
    ssY        = STEREOSHIFT.leftY;
end
    
    
X = newcenter + (hX + ssX);
Y =  hY + ssY;
    
STEREOSHIFT.ScreenInfo = ScreenInfo; % helpful for later

