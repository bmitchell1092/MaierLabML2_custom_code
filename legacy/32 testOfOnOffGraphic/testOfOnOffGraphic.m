% Initialize the escape key
hotkey('esc', 'escape_screen(); assignin(''caller'',''continue_'',false);');

scrsize = Screen.SubjectScreenFullSize / Screen.PixelsPerDegree;  % Screen size [x y] in degrees

% Set receptive field
rf = [3 -3]; % [x y] in visual degrees
setRF(rf);

% Set the fixation point
fixpt = [0 0]; % [x y] in visual degrees

% Set the constant conditions
de = 3;                                 % Dominant eye: 1 = binocular, 2 = right eye, 3 = left eye
ori = [0];                              % Preferred or non-preferred orientation of grating
sf = [1];                               % Cycles per degree
tf = [0];                               % Cycles per second (0=static, 4=drifting)
diameter = [3];                         % Diameter of the grating
time = [1600];                          % Duration of trial in [ms]
left_xloc = (-0.25*scrsize(1))+rf(1);   % Left eye x-coordinate
right_xloc = (0.25*scrsize(1))+rf(1);   % Right eye x-coordinate                   % Grating color 2
phase_angle = [0];                      % Phase angle in degrees (0-360)

%% Set the dominant and non-dominant x-coordinates
if de == 3
    de_xloc = left_xloc;
    nde_xloc = right_xloc;
    de_string = 'Left';
    nde_string = 'Right';
    
    rfloc = rf(2) - (0.25*scrsize(1));
elseif de == 2
    de_xloc = right_xloc;
    nde_xloc = left_xloc;
    de_string = 'Right';
    nde_string = 'Left';
    
    rfloc = rf(2) + (0.25*scrsize(1));
else
    de_xloc = right_xloc;
    nde_xloc = left_xloc;
    de_string = 'Binocular';
    nde_string = 'Binocular';
    
    rfloc = rf(2) + (0.25*scrsize(1));
end

%% Test Condition: Physical alternation

% Setting contrast. This applies to both gratings. 
color1 = [0.4, 0.4, 0.4];   % 0.1 deviance below mean
color2 = [0.6, 0.6, 0.6];   % 0.1 deviance above mean
                            % = 0.2 Michelson contrast 
                            
% Dicoptic DE-PO, NDE-NPO, DE2NDE
grat1a_loc = de_xloc;
grat1b_loc = nde_xloc;
grat1a_ori = ori;
grat1b_ori = ori + 90;

% Old way of modifying Contrast (doesn't currently do anything)
% because the SineGrating Jacob modified is on the wrong path. 
setcontrast(0.4, 0.6);

% Set the trigger delay
trig_delay = 1200;

% Make the second grating's diameter
diameter2 = diameter;

%% Scene 1. Fixation 

% Set fixation to the left eye for tracking
fix1 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix1.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix1.Threshold = 1; % Set the fixation threshold

% Set the background image
img1 = ImageGraphic(fix1);
img1.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Wait for fixation
wth1 = WaitThenHold(img1); % Initialize the wait and hold adapter
wth1.WaitTime = 5000; % Set the wait time
wth1.HoldTime = time; % Set the hold time

% Run the scene
scene = create_scene(wth1); % Initialize the scene adapter
run_scene(scene); % Run scene

%% Scene 2. Sine Gratings

if wth1.Success % If fixation was acquired and held

% Reward the monkey
goodmonkey(200, 'nonblocking', 2);

% Create both gratings
grat = SineGrating(null_);
grat.List = { [grat1a_loc rf(2)], diameter/2, grat1a_ori, sf, tf, phase_angle, color1, color2, 'circular', []; ...
    [grat1b_loc rf(2)], diameter2/2, grat1b_ori, sf, tf, phase_angle, color1, color2, 'circular', []};

% Trigger after fixation is held: Grating 1
on = OnOffGraphic(grat);
on.setOnGraphic(grat,1);
%on.setOffGraphic(grat,2);

% Delay 
trig = TriggerTimer(on);
trig.Delay = trig_delay;

% Trigger after delay: Grating 2 while Grating 1 dissapears
on2 = OnOffGraphic(trig);
on2.setOnGraphic(grat,2);
%on2.setOffGraphic(grat,1);

% Background
img = ImageGraphic(on2);
img.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Set the timer of the background
cnt = TimeCounter(img);
cnt.Duration = time;

% Create and run the scene
scene1 = create_scene(cnt);
run_scene(scene1);

end

%% Give the monkey a break
set_iti(1500); % Inter-trial interval in [ms]
