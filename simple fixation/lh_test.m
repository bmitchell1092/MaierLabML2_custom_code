if ~exist('eye_','var'), error('This demo requires eye signal input. Please set it up or try the simulation mode.'); end
hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);');
% give names to the TaskObjects defined in the conditions file:
fixation_point = 1;
set_bgcolor([0.5 0.5 0.5]);
% editables
editable('break_time');
break_time = 50;

% scene 1: wait for fixation
fix1 = SingleTarget(eye_);
fix1.Target = fixation_point;
fix1.Threshold = 1;
rescale_object(1, .5);
wth1 = WaitThenHold(fix1);
wth1.WaitTime = 5000;
wth1.HoldTime = 0;
ood1 = OnOffDisplay(wth1);
ood1.Dashboard = 3;
ood1.OnMessage = 'Waiting: true';
ood1.OffMessage = 'Waiting: false';
ood1.OnColor = [1 0 0];
ood1.OffColor = [0 1 0];
ood1.ChildProperty = 'Waiting';
scene1 = create_scene(ood1,fixation_point);
% scene 2: fixation hold
lh2 = LooseHold(fix1);  % The LooseHold adapter allows fixation breaks during the hold period
lh2.HoldTime = 2000;
lh2.BreakTime = break_time;
scene2 = create_scene(lh2,fixation_point);
% task
dashboard(1,'LooseHold adpater',[1 1 0]);
dashboard(2,sprintf('The trial is not aborted, if the eye comes back within %d ms after fixation breaks.',break_time));
dashboard(ood1.Dashboard,'');
dashboard(4,'');
run_scene(scene1);
error_type = 0;
if ~wth1.Success
    error_type = 4;
    dashboard(4,'Fixaion never attempted!',[1 0 0]);
else
    run_scene(scene2);
    if lh2.Success
        dashboard(4,'Holding: Succeeded!',[0 1 0])
    else
        error_type = 5;
        dashboard(4,'Holding: Failed',[1 0 0]);
    end
end
if 0==error_type % success! good monkey
    idle(0);                 % Clear screens
      goodmonkey(100, 'juiceline',1, 'numreward',1, 'pausetime',50, 'eventmarker',50); % 100 ms of juice x 3
elseif 4 == error_type %No fix obtained
    idle(700) % clear screens
elseif 5 == error_type %fixation broken
    idle(5000);               % This is the amount of time added as a penalty for incorrect response. Clear screens
end
trialerror(error_type)
rt = wth1.AcquiredTime;
idle(1500);
set_iti(500);