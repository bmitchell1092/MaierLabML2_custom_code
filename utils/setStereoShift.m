function setStereoShift

% units are DVA
% negative shifts towards left, postive towards right
% see "findScreenPos.m"

% April 2016, MAC

global STEREOSHIFT
STEREOSHIFT = [];

switch  datestr(today)
    otherwise
        leftX  = 0;
        leftY  = 0;
        rightX = 0;
        rightY = 0;
end

STEREOSHIFT.rightX = rightX;
STEREOSHIFT.rightY = rightY;
STEREOSHIFT.leftX  = leftX;
STEREOSHIFT.leftY  = leftY;
STEREOSHIFT.t      = today; 

if ~any([leftX leftY rightX rightY])
    disp('<<<  Maier Lab  >>> StereoShift *NOT* in use')
else
    disp('<<<  Maier Lab  >>> ***StereoShift in Use***')
end
