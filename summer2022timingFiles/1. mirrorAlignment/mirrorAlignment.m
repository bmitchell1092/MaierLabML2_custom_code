%% BAM and BMC - mirrorAlignment.m
%The goal of this timing script is to create 18 vixation target points. 9
%of these points are to appear in a grid on the left hand side of the
%monitor, and the other 9 are to appear on the right hand side of the
%monitor. 

%We will set a wide fixation windown (~3-5dva) for this task. We are
%trusting the macaque's performance to be quite accurate. Each point should
%be sampled at least 5 times (so minimum of 90 trials). The desired output
%of this behavioral task is the voltage signal out of the EyeTracker to get
%fixation positions in both dva and voltage. These voltage and dva outputs
%are to be plotted on top of each other (see ML1's plot calibration script)
%so that we can compare visual position across the two eyes. 


%% Example task structure from NIMH Monkey Logic's docs for SingleTarget
% 
% Example 1:
% 
% fix = SingleTarget(eye_);   % Or other XY data sources, such as joy_ and touch_
% fix.Target = [0 0];         % This can be TaskObject#
% fix.Threshold = 3;
% scene = create_scene(fix);
% run_scene(scene);           % The scene will end when the fixation is acquired
% Example 2:
% 
% t = linspace(0, 2*pi, 1000)';
% x = 6 * sin(3 * t);
% y = 9 * sin(4 * t) ./ 1.5;
% ct = CurveTracer(eye_);
% ct.Trajectory = [x y];
% fix = SingleTarget(ct);     % moving target with CurveTracer
% fix.Threshold = 3;
% scene = create_scene(fix);
% run_scene(scene);


%% Manual user inputs to change
fixationThreshold = 4; %in units of dva




%% Hotkey setup

hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);');




%% Scene creation

% give names to the TaskObjects defined in the conditions file:
fixation_point = 1;

% scene 1: wait for fixation and hold
fix1 = SingleTarget(eye_);
fix1.Target = fixation_point;
fix1.Threshold = 3;

% FreeThenHold is a secondary processor that receives input from SingleTarget
fth1 = FreeThenHold(fix1);  % The main difference between FreeThenHold and WaitThenHold
fth1.MaxTime = 10000;        % is that FreeThenHold allows fixation breaks, before the hold
fth1.HoldTime = 1000;       % requirement is fulfilled, and WaitThenHold does not.

% PropertyMonitor is added just to show the state of FreeThenHold
pm1 = PropertyMonitor(fth1);
pm1.Dashboard = 3;
pm1.Color = [0.7 0.7 0.7];
pm1.ChildProperty = 'BreakCount';

scene1 = create_scene(pm1,fixation_point);

% task
dashboard(1,'FreeThenHold adapter',[1 1 0]);
dashboard(2,'Unlike WaitThenHold, fixation can be broken multiple times before the hold requirement is fulfilled');
dashboard(pm1.Dashboard,'');
dashboard(4,'');

%% Run Scene
run_scene(scene1);
if fth1.Success
    dashboard(4,'Holding: Succeeded!',[0 1 0]);
else
    if 0==fth1.BreakCount
        dashboard(4,'Fixaion never attempted!',[1 0 0]);
    else
        dashboard(4,'Holding: Failed',[1 0 0]);
    end
end

idle(1500);
set_iti(500);
