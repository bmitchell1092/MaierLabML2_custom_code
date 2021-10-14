function h = setTargetPointsXY(new_targetlist,resetTransform)

% MAC
% March 2105

%!! ~ MUST FIRST LAUNCH CALIBRATION FROM ML MENUE ~ !!%
% function resets ML's xycalibrate to have "new_targetlist" (i.e., control points / fix locations)
% new_targetlist must be n x 2;
% "resetTransform" is a logical and determins if an empty SigTransform is passed to xycalibrate

% check inputs
if size(new_targetlist,2)~=2
    if size(new_targetlist,1) == 2
        new_targetlist = new_targetlist';
    else
        error('new_targetlist must be n x 2')
    end
end
if nargin < 2
    resetTransform = false;
else
    resetTransform = logical(resetTransform);
end

fig = findobj('tag', 'xycalibrate');
BasicData = get(fig, 'userdata');
ScreenInfo = BasicData.ScreenInfo;
maxX=  floor((ScreenInfo.Xsize / ScreenInfo.PixelsPerDegree)/2);
maxY=  floor((ScreenInfo.Ysize / ScreenInfo.PixelsPerDegree)/2);
if any(abs( new_targetlist(:,1)) > maxX) || any(abs( new_targetlist(:,2)) > maxY)
    error('pts out of range, maxX = +/-%u. maxY = +/-%u',maxX,maxY)
end
targetlist = new_targetlist;
DaqInfo = BasicData.IO;
if resetTransform
    SigTransform = [];
else
    SigTransform = BasicData.SigTransform;
end
close(fig)
xycalibrate(ScreenInfo, targetlist, DaqInfo, SigTransform);
h = gcf;