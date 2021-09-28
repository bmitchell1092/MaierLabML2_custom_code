%% Jun 2019, Jacob Rogatinsky 
% Sept. 14, 2021. Revised by Blake Mitchell

%% Initial code
% Paradigm selection
% 'phzdisparity'       Sine wave phase angle varies trial to trial, eye to eye
% 'posdisparity'    Grating location varies trial to trial, eye to eye
pdgm = 'posdisparity';

timestamp = datestr(now); % Get the current time on the computer

% Set dominant eye
de = 3; % 1 = binocular, 2 = right eye, 3 = left eye
setDE(de); % Send value to a global variable

% Set receptive field
rf = [0 0]; % [x y] in visual degrees
setRF(rf);

% Set fixation point
fixpt = [0 0]; % [x y] in viual degrees
fixThreshold = 1; % degrees of visual angle

% define intervals for WaitThenHold
wait_for_fix = 3000;
initial_fix = 500;
period1_time = 800;
period2_time = 800;

% Find screen size
scrsize = Screen.SubjectScreenFullSize / Screen.PixelsPerDegree;  % Screen size [x y] in degrees
setCoord(scrsize); % Send value to a global variable
lower_right = [(scrsize(1)*0.5-0.5) (scrsize(2)*(-0.5)+0.5)];

% Initialize the escape key
hotkey('esc', 'escape_screen(); assignin(''caller'',''continue_'',false);');

% Trial number increases by 1 for every iteration of the code
trialnum = tnum(TrialRecord);

% Set the seed number on the first trial by storing it as a global variable
% in an external function. Additionally, initialize the text file that will
% store information on every trial
if trialnum == 1
    setSeed(randi([1 1000])); % Send value to a global variable
        
    genFixCross((fixpt(1)*Screen.PixelsPerDegree), (fixpt(2)*Screen.PixelsPerDegree));
    
    dir = fileparts(which('Test_Disparity.m'));
    fid = fopen(strcat(dir,'BM Disparity'), 'w'); % Write to a text file
    formatSpec =  '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\n';
    fprintf(fid,formatSpec,...
        'Trial Number',...
        'RF X-Coord',...
        'RF Y-Coord',...
        'Grating Tilt',...
        'Spatial Frequency',...
        'Temporal Frequency',...
        'Dominant Contrast',...
        'NonDom Contrast',...
        'Diameter',...
        'Dominant Eye',...
        'NonDom Eye',...
        'Ori Disparity',...
        'Paradigm',...
        'Phase Angle',...
        'Time Stamp',...
        'Pos Disparity',...
        'Fixation X-Coord',...
        'Fixation Y-Coord',...
        'Cone Path');
    fclose(fid);
    
end

% Call the seed number created during the first trial using a separate
% external function -- this way, the seed number only changes when
% Test_Drifting_Grating1 is restarted each iteration within MonkeyLogic
sdnum = getSeed;

%% Struct of pseudo-randomized trial conditions
% If it's the first trial
if trialnum < 2
    rng(sdnum) % Set the randomizer seed
    r = genDGParams(pdgm); % Call the pseudorandomizer function
    
% If it's not the first trial
else
    rng(sdnum) % Set the randomizer seed
    r = genDGParams(pdgm); % Call the pseudorandomizer function
    
    % When 'trialnum' exceeds the length of the struct 'r', use
    % 'placeholder' to go back to the beginning of the struct
    placeholder = mod(trialnum,length(r));
    if placeholder == 0
        placeholder = length(r);
    end
    
    % Cycle through each row within the struct's fields
    r(end+1:end+placeholder-1) = r(1:placeholder-1);
    r(1:placeholder-1)=[];
    
end

%% Assign values to each sine grating condition
% Set the conditions
direction = r(1).ori; % Orientation of grating
sf = r(1).sfsf;  % Spatial frequency: cycles per degree
tf = r(1).tftf;  % Temporal frequency: cycles per second
diameter = r(1).diam; % Diameter of the grating
time = r(1).tme; % Duration of grating presentation in [ms]
contr_left = r(1).lfteyec; % Left eye contrast (0 to 1)
contr_right = r(1).rteyec; % Right eye contrast (0 to 1)
xloc_left = r(1).lftxloc; % Left eye x-coordinate
xloc_right = r(1).rtxloc; % Right eye x-coordinate
phase_angl = r(1).phase_a; % Phase angles
setcontrast(contr_left, contr_right); % Set the contrast global variables to be called in SineGrating
gray = [0.5 0.5 0.5]; 

if de == 3
    phase_angle_left = phase_angl;
    phase_angle_right = 0;
    de_string = 'Left';
    nde_string = 'Right';
    domloc = xloc_left;
    ndomloc = xloc_right;
    domcont = contr_left;
    ndomcont = contr_right;
elseif de == 2
    phase_angle_left = 0;
    phase_angle_right = phase_angl;
    de_string = 'Right';
    nde_string = 'Left';
    domloc = xloc_right;
    ndomloc = xloc_left;
    domcont = contr_right;
    ndomcont = contr_left;
else
    phase_angle_left = 0;
    phase_angle_right = 0;
    de_string = 'Binocular';
    nde_string = 'Binocular';
    domloc = xloc_right;
    ndomloc = xloc_left;
    domcont = contr_right;
    ndomcont = contr_left;
end

switch r(1).clr
    case 1
        color1 = [1 1 1]; % Grating color 1
        color2 = [0 0 0]; % Grating color 2
        pathw = 'Black and White';
    case 2
        color1 = silsbtw_mod(1,:);
        color2 = silsbtw_mod(2,:);
        pathw = 'LM';
    case 3
        color1 = sbtw_mod(1,:);
        color2 = sbtw_mod(2,:);
        pathw = 'S';
    case 4
        color1 = plusMminusL(1,:);
        color2 = plusMminusL(2,:);
        pathw = 'LMo';
end

%% Scene 1. Fixation
% Set fixation to the left eye for tracking
fix1 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix1.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix1.Threshold = fixThreshold; % Set the fixation threshold

% Set the background image
img1 = ImageGraphic(fix1);
img1.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Wait for fixation
wth1 = WaitThenHold(img1); % Initialize the wait and hold adapter
wth1.WaitTime = wait_for_fix; % Set the wait time
wth1.HoldTime = initial_fix; % Set the hold time

% Create the scene
scene1 = create_scene(wth1); % Initialize the scene adapter

%% Scene 2. Sine gratings

% initiate eye tracker
fix2 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix2.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix2.Threshold = fixThreshold; % Set the fixation threshold

% Create the left grating
grat1a = SineGrating(null_);
grat1a.Position = [xloc_left rf(2)];
grat1a.Radius = diameter/2;
grat1a.Direction = direction;
grat1a.SpatialFrequency = sf;
grat1a.TemporalFrequency = tf;
grat1a.Color1 = gray + (contr_left / 2); %color1;
grat1a.Color2 = gray - (contr_left / 2); %color2;
grat1a.Phase = phase_angle_left;
grat1a.WindowType = 'circular';

% Create the right grating
grat1b = SineGrating(grat1a);
grat1b.Position = [xloc_right rf(2)];
grat1b.Radius = diameter/2;
grat1b.Direction = direction;
grat1b.SpatialFrequency = sf;
grat1b.TemporalFrequency = tf;
grat1b.Color1 = gray + (contr_right / 2); %color1;
grat1b.Color2 = gray - (contr_right / 2); %color2;
grat1b.Phase = phase_angle_right;
grat1b.WindowType = 'circular';

% background
img = ImageGraphic(grat1b);
img.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Set the timer
cnt = TimeCounter(img);
cnt.Duration = time;

% Run the scene
scene2 = create_scene(cnt);


%% TASK
error_type = 0;


run_scene(scene1,10); % Run scene
if ~wth1.Success             % If the WithThenHold failed (either fixation is not acquired or broken during hold),
    if wth1.Waiting          %    check whether we were waiting for fixation.
        error_type = 4;      % If so, fixation was never made and therefore this is a "no fixation (4)" error.
    else
        error_type = 3;      % If we were not waiting, it means that fixation was acquired but not held,
        idle(0);                 % Clear screens
    end                      %    so this is a "break fixation (3)" error.
end

if 0==error_type
    run_scene(scene2,20);    % Run the second scene (eventmarker 20)
    if ~fix2.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        idle(0);                 % Clear screens
    end
end

% reward
if 0==error_type
%     idle(0);                 % Clear screens
    goodmonkey(100, 'juiceline',1, 'numreward',2, 'pausetime',500, 'eventmarker',50); % 100 ms of juice x 2
end


trialerror(error_type);      % Add the result to the trial history

%% Write info to file
dir = fileparts(which('Test_Drifting_Grating1.m'));
fid = fopen(strcat(dir,'Drifting Gratings'), 'a');
    
formatSpec =  '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%s\t%s\t%f\t%s\t%f\t%s\t%f\t%f\t%f\t%s\t\n';
fprintf(fid,formatSpec,...
    trialnum,...
    domloc,...
    rf(2),...
    direction,...
    sf,...
    tf,...
    domcont,...
    ndomcont,...
    diameter,...
    de_string,...
    nde_string,...
    0,...
    pdgm,...
    phase_angl,...
    timestamp,...
    domloc+ndomloc,...
    ((-0.25*scrsize(1))+fixpt(1)),...
    fixpt(2),...
    pathw);
    
fclose(fid);
    
%% Give the monkey a break
set_iti(500); % Inter-trial interval in [ms]

%%