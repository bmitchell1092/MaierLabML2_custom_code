% Initialize the escape key
hotkey('esc', 'escape_screen(); assignin(''caller'',''continue_'',false);');
bhv_code(8,'Fixation occurs',11,'Start wait fixation',12,'End wait fixation',...
    23,'TaskObject-1 ON',24,'TaskObject-1 OFF',25,'TaskObject-2 ON',26,'TaskObject-2 OFF',...
    27,'TaskObject-3 ON',28,'TaskObject-3 OFF',29,'TaskObject-4 ON',30,'TaskObject-4 OFF',...
    31,'TaskObject-5 ON',32,'TaskObject-5 OFF',33,'TaskObject-6 ON',34,'TaskObject-6 OFF',...
    35,'Fixation spot ON',36,'Fixation spot OFF',96,'Reward delivered',97,'Broke fixation');  

scrsize = Screen.SubjectScreenFullSize / Screen.PixelsPerDegree;  % Screen size [x y] in degrees
lower_right = [(scrsize(1)*0.5-0.5) (scrsize(2)*(-0.5)+0.5)];

% Set receptive field
rf = [3 -3]; % [x y] in visual degrees
setRF(rf);

% Set the fixation point
fixpt = [0 0]; % [x y] in visual degrees

% Set the constant conditions
% de = 3;                                 % Dominant eye: 1 = binocular, 2 = right eye, 3 = left eye
fixTreshold = 1.5;
ori = [0];                              % Preferred or non-preferred orientation of grating
sf = [1];                               % Cycles per degree
tf = [0];                               % Cycles per second (0=static, 4=drifting)
diameter = [3];                         % Diameter of the grating
left_xloc = (-0.25*scrsize(1))+rf(1);   % Left eye x-coordinate
right_xloc = (0.25*scrsize(1))+rf(1);   % Right eye x-coordinate                   % Grating color 2
phase_angle = [0];                      % Phase angle in degrees (0-360)

% define time intervals (in ms):
wait_for_fix = 3000;
initial_fix = 250;
period1_time = 800;
period2_time = 800;


%% Set the dominant and non-dominant x-coordinates
% % if de == 3
% %     de_xloc = left_xloc;
% %     nde_xloc = right_xloc;
% %     de_string = 'Left';
% %     nde_string = 'Right';
% %     
% %     rfloc = rf(2) - (0.25*scrsize(1));
% % elseif de == 2
% %     de_xloc = right_xloc;
% %     nde_xloc = left_xloc;
% %     de_string = 'Right';
% %     nde_string = 'Left';
% %     
% %     rfloc = rf(2) + (0.25*scrsize(1));
% % else
% %     de_xloc = right_xloc;
% %     nde_xloc = left_xloc;
% %     de_string = 'Binocular';
% %     nde_string = 'Binocular';
% %     
% %     rfloc = rf(2) + (0.25*scrsize(1));
% % end

%% BRFS paradigm and controlls
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% 1. What is consistant on every trial?%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Setting contrast. This applies to both gratings. 
color1 = [0.3, 0.3, 0.3];   % 0.2 deviance below mean
color2 = [0.7, 0.7, 0.7];   % 0.2 deviance above mean
                            % = 0.4 Michelson contrast 
                            



% Old way of modifying Contrast (doesn't currently do anything)
% because the SineGrating Jacob modified is on the wrong path. 
% % % % BMC comments - 9/1/2018. Whats the status of this. Do we have the
% path issues resolved at this point? Should we use setContrast or just
% stick to the colo1 or color2? Let's decide and use across all
% experiements. 
% % % % setcontrast(0.4, 0.6);

% Set the trigger delay - must be at least 800 ms.
trig_delay = 800;

% Make the second grating's diameter
diameter2 = diameter;


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%% 2. What changes on every trial?%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grating a and b eye, Random assignemnt 
% 2 = right, 3 = left
maintGrat = randi([2 3],1);
if maintGrat == 3
    grat1a_loc = left_xloc;
    grat1b_loc = right_xloc;
    grat1a_string = 'Left';
    grat1b_string = 'Right';    
elseif maintGrat == 2
    grat1a_loc = right_xloc;
    grat1b_loc = left_xloc;
    grat1a_string = 'Right';
    grat1b_string = 'Left';  
end

bhv_variable('grat1a_string', grat1a_string, 'grat1b_string', grat1b_string);

% Grating a and b orientation, Random assignment of orientation a. C vs IC
% also randomly assigned
isIC = randi([0 1],1); % if 0, it is NOT IC (it is C). if 1, it IS IC.
if isIC == 0
    grat1a_ori = ori + (90*randi([0 1],1)); %Random assignment of 2 possible orientations
    grat1b_ori = grat1a_ori; % This is congruent
elseif isIC == 1
    grat1a_ori = ori + (90*randi([0 1],1));
    grat1b_ori = grat1a_ori + 90; % This is incongruent
end


bhv_variable('grat1a_ori', grat1a_ori, 'grat1b_ori', grat1b_ori);


%% Scene 1 - fixation

% Set fixation to the left eye for tracking
fix1 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix1.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix1.Threshold = fixTreshold; % Set the fixation threshold

% Set the background image
img1 = ImageGraphic(fix1);
img1.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Wait for fixation
wth1 = WaitThenHold(img1); % The WaitThenHold adapter waits for WaitTime until the fixation
wth1.WaitTime = wait_for_fix; % Set the wait time
wth1.HoldTime = initial_fix; % Set the hold time

scene1 = create_scene(wth1);

%% Scene 2 - Timing category {Simultaneous, adapted (BRFS), physical alternation}
% 1 = simultaneous, 2 = adapted (BRFS), 3 = physical alternation
% timingCategory = randi([1 3],1); 
timingCategory = 2; 

bhv_variable('timingCategory', timingCategory);

%% Scene 2 -  Timing category 1, simultaneous
if timingCategory == 1

    % Set fixation to the left eye for tracking
    fix2 = SingleTarget(eye_); % Initialize the eye tracking adapter
    fix2.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
    fix2.Threshold = fixTreshold; % Set the fixation threshold

    
    pd = BoxGraphic(fix2);
    pd.EdgeColor = [1 1 1];
    pd.FaceColor = [1 1 1];
    pd.Size = [2 2];
    pd.Position = lower_right;
    
    % Create both gratings
    grat = SineGrating(pd);
    grat.List = { [grat1a_loc rf(2)], diameter/2, grat1a_ori, sf, tf, phase_angle, color1, color2, 'circular', []; ...
        [grat1b_loc rf(2)], diameter2/2, grat1b_ori, sf, tf, phase_angle, color1, color2, 'circular', []};
    img2 = ImageGraphic(grat);
    img2.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };    
    wth2 = WaitThenHold(img2);
    wth2.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
    wth2.HoldTime = 1600;
    scene2 = create_scene(wth2);

end

%% Scene 2 - timing category 2, adapted (BRFS)
if timingCategory == 2
    
    % Set fixation to the left eye for tracking
    fix2 = SingleTarget(eye_); % Initialize the eye tracking adapter
    fix2.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
    fix2.Threshold = fixTreshold; % Set the fixation threshold
    
    
    pd = BoxGraphic(fix2);
    pd.EdgeColor = [1 1 1];
    pd.FaceColor = [1 1 1];
    pd.Size = [2 2];
    pd.Position = lower_right;
    
    
    % Create both gratings
    grat = SineGrating(pd);
    grat.List = { [grat1a_loc rf(2)], diameter/2, grat1a_ori, sf, tf, phase_angle, color1, color2, 'circular', []; ...
        [grat1b_loc rf(2)], diameter2/2, grat1b_ori, sf, tf, phase_angle, color1, color2, 'circular', []};
    % Trigger after delay: Grating 2 while Grating 1 STAYS ON THE SCREEN
    on = OnOffGraphic(grat);
    on.setOnGraphic(grat,2);
    %on.setOffGraphic(grat,2);

    % Set the timer of the first grating
    cnt1 = TimeCounter(on); % Success: true when Duration has passed
    cnt1.Duration = 100;
    
    pd2 = BoxGraphic(cnt1);
    pd2.EdgeColor = [0 0 0];
    pd2.FaceColor = [0 0 0];
    pd2.Size = [2 2];
    pd2.Position = lower_right;
    
    cnt2 = TimeCounter(pd2); % Success: true when Duration has passed
    cnt2.Duration = 700;

    % Trigger after fixation is held: Grating 1
    oom = OnOffMarker(cnt2);
    oom.OnMarker = 23;%  23,'TaskObject-1 ON' % OnMarker: Eventcode to send when the state of the child adapter changes from false to true - 2nd stimulus onset % 25 for BRFS
    on2 = OnOffGraphic(oom);
    on2.setOnGraphic(grat,1); 
    
    pd3 = BoxGraphic(on2);
    pd3.EdgeColor = [1 1 1];
    pd3.FaceColor = [1 1 1];
    pd3.Size = [2 2];
    pd3.Position = lower_right;
    
    

    % Background
    img2 = ImageGraphic(pd3);
    img2.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

    % Set the timer of the background
    cnt3 = TimeCounter(img2);
    cnt3.Duration = 1600;

    % Create and run the scene
    scene2 = create_scene(cnt3);

       
end


%% Scene 2 - timing category 3, physical alternation
if timingCategory == 3
    
    % Set fixation to the left eye for tracking
    fix2 = SingleTarget(eye_); % Initialize the eye tracking adapter
    fix2.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
    fix2.Threshold = fixTreshold; % Set the fixation threshold
    
    
    pd = BoxGraphic(fix2);
    pd.EdgeColor = [1 1 1];
    pd.FaceColor = [1 1 1];
    pd.Size = [2 2];
    pd.Position = lower_right;
    
    % Create both gratings
    grat = SineGrating(pd);
    grat.List = { [grat1a_loc rf(2)], diameter/2, grat1a_ori, sf, tf, phase_angle, color1, color2, 'circular', []; ...
        [grat1b_loc rf(2)], diameter2/2, grat1b_ori, sf, tf, phase_angle, color1, color2, 'circular', []};

    % Trigger after fixation is held: Grating 1
    on = OnOffGraphic(grat);
    on.setOnGraphic(grat,1);
    
   % Set the timer of the first grating
    cnt1 = TimeCounter(on); % Success: true when Duration has passed
    cnt1.Duration = 750;
    
    pd2 = BoxGraphic(cnt1);
    pd2.EdgeColor = [0 0 0];
    pd2.FaceColor = [0 0 0];
    pd2.Size = [2 2];
    pd2.Position = lower_right;
    
    cnt2 = TimeCounter(pd2); % Success: true when Duration has passed
    cnt2.Duration = 50;


    % Trigger after delay: Grating 2 while Grating 1 dissapears
    oom = OnOffMarker(cnt2);
    oom.OnMarker = 25; % OnMarker: Eventcode to send when the state of the child adapter changes from false to true - 2nd stimulus onset % 30 for monoc alternation onset   
    on2 = OnOffGraphic(oom);
    on2.setOnGraphic(grat,1); 
    on2.setOffGraphic(grat,2);
    
    error('here gratings 2 and 1 are wrong')
    
    pd3 = BoxGraphic(on2);
    pd3.EdgeColor = [1 1 1];
    pd3.FaceColor = [1 1 1];
    pd3.Size = [2 2];
    pd3.Position = lower_right;

    % Background
    img2 = ImageGraphic(pd3);
    img2.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

    % Set the timer of the background
    cnt3 = TimeCounter(img2);
    cnt3.Duration = 1600;

    % Create and run the scene
    scene2 = create_scene(cnt3);

       
end

%% Scene 3: Cleared screen
bck3 = ImageGraphic(null_);
bck3.List = { {'graybackground.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Set the timer
cnt3 = TimeCounter(bck3);
cnt3.Duration = 250;
scene3 = create_scene(cnt3);

    
%% TASK
error_type = 0;

run_scene(scene1,[35,11]); % WaitThenHold | 35 = Fix spot on, 11 = Start wait fixation
if ~wth1.Success             % If the WithThenHold failed (either fixation is not acquired or broken during hold),
    if wth1.Waiting          %    check whether we were waiting for fixation.
        error_type = 4;      % If so, fixation was never made and therefore this is a "no fixation (4)" error.
        run_scene(scene3,12);  % blank screen | 12 = end wait fixation
    else
        error_type = 3;      % If we were not waiting, it means that fixation was acquired but not held,
        run_scene(scene3,[97,36]);   % blank screen | 97 = fixation broken, 36 = fix cross OFF
    end   %    so this is a "break fixation (3)" error.
else
    eventmarker(8); % 8 = fixation occurs
end

if 0==error_type
    run_scene(scene2,23);    % Run the second scene (eventmarker 23)
    if ~fix2.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene3,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
        eventmarker(24) % 24 = task object 1 OFF 
    end
end



% reward
if 0==error_type
    run_scene(scene3,36); 
    goodmonkey(100, 'juiceline',1, 'numreward',2, 'pausetime',500, 'eventmarker',50); % 100 ms of juice x 2. Event marker for reward
end

trialerror(error_type);      % Add the result to the trial history

%% Give the monkey a break
set_iti(1500); % Inter-trial interval in [ms]
