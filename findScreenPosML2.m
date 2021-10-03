function [X,Y] = findScreenPosML2(eye,Screen,TH_or_X,E_or_Y,units)

% PUT EVEN TASK OBJECTS ON RIGHT SIDE OF MONITOR
% PUT ODD TASK OBJECTS ON LEFT SIDE OF MONITOR

% input can be ploar or cartesian, TH should be in degrees
% output is always cartesian
% all units are in dva

% Fall 2015, KD
% April 2016, MAC
% Oct 2021, BM

global STEREOSHIFT
% check STEREOSHIFT
if  isempty(STEREOSHIFT)
    setStereoShiftML2;
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
if eye == 3
    % if eye is 3 put objects on RIGHT side of Screen(right eye)
    newcenter  = 0  + (Screen.Xsize/Screen.PixelsPerDegree)/4;
    ssX        = STEREOSHIFT.rightX;
    ssY        = STEREOSHIFT.rightY;
elseif eye == 2
    % if eye # is ODD put this TO on LEFT side of Screen (left eye)
    newcenter  = 0 - (Screen.Xsize/Screen.PixelsPerDegree)/4;
    ssX        = STEREOSHIFT.leftX;
    ssY        = STEREOSHIFT.leftY;
end
    
    
X = newcenter + (hX + ssX);
Y =  hY + ssY;
    
STEREOSHIFT.ScreenInfo = Screen; % helpful for later

