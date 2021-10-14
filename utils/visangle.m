function [pixperdeg degperpix screen]= visangle(vdist,screen)
% function [pixperdeg degperpix screen]= visangle(vdist,screen)
% Calculates the visual angle subtended by a single pixel
% 
% INPUT:
% vdist - the viewing distance in cm
% screen.res - the resolution of the monitor, w x h
% screen.sz - the size of the monitor in cm, w x h
% if screen.sz or screen.res is not passed or empty, Matlab will querry system settings
%
% written by MAC 1/2014
% inspired by VisAng by IF 7/2000

screen.vdist = vdist;

% input-speficic bahvior
if nargin < 2
    querysystem = 1;
elseif isempty(screen.sz) || isempty(screen.res)
    querysystem = 1;
else
    querysystem = 0;
end

if querysystem
    if ispc
    % query system settings, assume display monitor is second (last) monitor
    set(0,'units','centimeters ')
    MP =  get(0,'MonitorPositions');  MP = abs(MP);
    screen.sz = [sum(MP(end,1:2:3)) sum(MP(end,2:2:4))];
    set(0,'units','pixels')
    MP =  get(0,'MonitorPositions');
    screen.res =  [range(MP(end,1:2:3)) range(MP(end,2:2:4))] + [1 1];
    % check query
    if screen.res(1)/screen.res(2) ~=  screen.sz(1)/screen.sz(2)
        error('check system level reports of screen resolution and screen size')
    end
    else
         error('Have not tested auto-query on Linix or Mac. Must pass screen parameters.')
    end
end

% calculate pixel to degree conversion
pix       = screen.sz ./ screen.res;
degperpix = (2*atan(pix./(2*screen.vdist))).*(180/pi);
pixperdeg = 1./degperpix;
degperpix = mean(degperpix); pixperdeg = mean(pixperdeg);