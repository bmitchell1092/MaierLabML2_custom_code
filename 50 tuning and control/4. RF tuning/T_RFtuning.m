%% Jun 2019, Jacob Rogatinsky
% Sept. 2021, Revised by Blake Mitchell

%% Initial code
% Paradigm selection  
% 'cinteroc'        Grating contrast varies trial to trial, eye to eye
% 'rfori'           Grating orientation varies trial to trial
% 'rfsize'          Grating size varies trial to trial
% 'rfsf'            Grating spatial frequency varies trial to trial
% 'posdisparity'    Grating x-position (DE) varies from trial to trial
% 'phzdisparity'    Grating phase angle (DE) varies from trial to trial
% 'cone'            Grating colors vary trial to trial, eye to eye
pdgm = 'rfori';

timestamp = datestr(now); % Get the current time on the computer

% Event Codes
% bhv_code(8,'Fixation occurs',11,'Start wait fixation',12,'End wait fixation',...
%     23,'TaskObject-1 ON',24,'TaskObject-1 OFF',25,'TaskObject-2 ON',26,'TaskObject-2 OFF',...
%     27,'TaskObject-3 ON',28,'TaskObject-3 OFF',29,'TaskObject-4 ON',30,'TaskObject-4 OFF',...
%     31,'TaskObject-5 ON',32,'TaskObject-5 OFF',33,'TaskObject-6 ON',34,'TaskObject-6 OFF',...
%     35,'Fixation spot ON',36,'Fixation spot OFF',96,'Reward delivered',97,'Broke fixation');  
% 
% Initialize the escape key
hotkey('esc', 'escape_screen(); assignin(''caller'',''continue_'',false);');

% Set dominant eye
de = 3; % 1 = binocular, 2 = right eye, 3 = left eye
setDE(de); % Send value to a global variable

% Set receptive field
rf = [3 -3]; % [x y] in visual degrees
setRF(rf);

% Set fixation point
fixpt = [0 0]; % [x y] in viual degrees
fixThreshold = 3; % degrees of visual angle

% define intervals for WaitThenHold
wait_for_fix = 3000;
initial_fix = 200; % hold fixation for 200ms to initiate trial

% define presentation duration
time = 250;

% Initialize options for grating colors
% sbtw_mod = S (oscillate between S+ and S-)
% silsbtw_mod = LM (oscillate between P+M+ and L_M-)
% plusMminusL = LMo (oscillate between L+M- and L-M+)
[~,~,~,sbtw_mod,~,~,silsbtw_mod,plusMminusL] = getConeIsolatingVals('021MIT');

% Find screen size
scrsize = Screen.SubjectScreenFullSize / Screen.PixelsPerDegree;  % Screen size [x y] in degrees
setCoord(scrsize); % Send value to a global variable
lower_right = [(scrsize(1)*0.5-0.5) (scrsize(2)*(-0.5)+0.5)];

% Trial number increases by 1 for every iteration of the code
trialnum = tnum(TrialRecord);

% Set the seed number on the first trial by storing it as a global variable
% in an external function. Additionally, initialize the text file that will
% store information on every trial
if trialnum == 1
    setSeed(randi([1 1000])); % Send value to a global variable
        
    genFixCross((fixpt(1)*Screen.PixelsPerDegree), (fixpt(2)*Screen.PixelsPerDegree));
    
    taskdir = fileparts(which('T_RFtuning.m'));
    fid = fopen(strcat(taskdir,'/',upper(pdgm),'.g',upper(pdgm),'Grating_di'), 'w');    formatSpec =  '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\n';
    fprintf(fid,formatSpec,...
        'Trial Number',...
        'RF X-Coord',...
        'RF Y-Coord',...
        'tilt',...
        'sf',...
        'tf',...
        'Dominant Contrast',...
        'NonDom Contrast',...
        'Diameter',...
        'Dominant Eye',...
        'NonDom Eye',...
        'Phase Disparity',...
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
    r = genTuningParams(pdgm); % Call the pseudorandomizer function
    
% If it's not the first trial
else
    rng(sdnum) % Set the randomizer seed
    r = genTuningParams(pdgm); % Call the pseudorandomizer function
    
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
ori = r(1).ori; % Orientation of grating
sf = r(1).sf;  % Spatial frequency: cycles per degree
tf = r(1).tf;  % Temporal frequency: cycles per second
diameter = r(1).diam; % Diameter of the grating
cont_left = r(1).cont_left; % Left eye contrast (0 to 1)
cont_right = r(1).cont_right; % Right eye contrast (0 to 1)
xloc_left = r(1).xloc_left; % Left eye x-coordinate
xloc_right = r(1).xloc_right; % Right eye x-coordinate
phase = r(1).phase; % Phase angles
% Phase NEEDS DEV


if de == 3
    de_phase = phase;
    nde_phase = 0;
    de_string = 'Left';
    nde_string = 'Right';
    domloc = xloc_left;
    ndomloc = xloc_right;
    domcont = cont_left;
    ndomcont = cont_right;
elseif de == 2
    de_phase = 0;
    nde_phase = phase;
    de_string = 'Right';
    nde_string = 'Left';
    domloc = xloc_right;
    ndomloc = xloc_left;
    domcont = cont_right;
    ndomcont = cont_left;
else
    phase_angle_left = 0;
    phase_angle_right = 0;
    de_string = 'Binocular';
    nde_string = 'Binocular';
    domloc = xloc_right;
    ndomloc = xloc_left;
    domcont = cont_right;
    ndomcont = cont_left;
end

switch r(1).color
    case 1
        gray = [0.5 0.5 0.5]; 
        dom_color1 = gray + (domcont / 2); 
        dom_color2 = gray - (domcont / 2);
        
        ndom_color1 = gray + (ndomcont / 2);
        ndom_color2 = gray - (ndomcont / 2);
        
        pathw = 'grayscale';
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
bck1 = ImageGraphic(fix1);
bck1.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Wait for fixation
wth1 = WaitThenHold(bck1); % Initialize the wait and hold adapter
wth1.WaitTime = wait_for_fix; % Set the wait time
wth1.HoldTime = initial_fix; % Set the hold time

% Create the scene
scene1 = create_scene(wth1); % Initialize the scene adapter

%% Scene 2. Sine gratings

% initiate eye tracker
fix2 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix2.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix2.Threshold = fixThreshold; % Set the fixation threshold

pd = BoxGraphic(fix2);
pd.EdgeColor = [1 1 1];
pd.FaceColor = [1 1 1];
pd.Size = [3 3];
pd.Position = lower_right;

% Create the dom-eye grating
grat1a = SineGrating(pd);
grat1a.Position = [domloc rf(2)];
grat1a.Radius = diameter/2;
grat1a.Direction = ori;
grat1a.SpatialFrequency = sf;
grat1a.TemporalFrequency = tf;
grat1a.Color1 = dom_color1;
grat1a.Color2 = dom_color2;
grat1a.Phase = de_phase;
grat1a.WindowType = 'circular';

% Create the ndom-eye grating
grat1b = SineGrating(grat1a);
grat1b.Position = [ndomloc rf(2)];
grat1b.Radius = diameter/2;
grat1b.Direction = ori;
grat1b.SpatialFrequency = sf;
grat1b.TemporalFrequency = tf;
grat1b.Color1 = ndom_color1;
grat1b.Color2 = ndom_color2;
grat1b.Phase = nde_phase; % not sure why this was set to be different 
grat1b.WindowType = 'circular';

% background
bck2 = ImageGraphic(grat1b);
bck2.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Set the timer
cnt2 = TimeCounter(bck2);
cnt2.Duration = time;

% Create the scene
scene2 = create_scene(cnt2);

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
    if wth1.Waiting          % check whether we were waiting for fixation.
        error_type = 1;
        run_scene(scene3,12);  % blank screen | 12 = end wait fixation
    else
        error_type = 2;      % If we were not waiting, it means that fixation was acquired but not held,
        run_scene(scene3,[97,36]);   % blank screen | 97 = fixation broken, 36 = fix cross OFF
    end
else
    eventmarker(8); % 8 = fixation occurs
end

if 0==error_type
    run_scene(scene2,23);    % 23 = Task object 1 ON
    if ~fix2.Success         % The failure of WthThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene3,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
        eventmarker(24) % 24 = task object 1 OFF 
    end
end

% reward
if 0==error_type
    run_scene(scene3,36); 
    goodmonkey(100, 'NonBlocking',1,'juiceline',1, 'numreward',1, 'pausetime',500, 'eventmarker',96); % 100 ms of juice x 2
end


trialerror(error_type);      % Add the result to the trial history

%% Write info to file
taskdir = fileparts(which('T_RFtuning.m'));
fid = fopen(strcat(taskdir,'/',upper(pdgm),'.g',upper(pdgm),'Grating_di'), 'a');
formatSpec =  '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%s\t%s\t%f\t%s\t%f\t%s\t%f\t%f\t%f\t%s\t\n';
fprintf(fid,formatSpec,...
    trialnum,...
    domloc,...
    rf(2),...
    ori,...
    sf,...
    tf,...
    domcont,...
    ndomcont,...
    diameter,...
    de_string,...
    nde_string,...
    0,...
    pdgm,...
    phase,...
    timestamp,...
    domloc+ndomloc,...
    ((-0.25*scrsize(1))+fixpt(1)),...
    fixpt(2),...
    pathw);
    
fclose(fid);
    
%% Give the monkey a break
set_iti(800); % Inter-trial interval in [ms]

%%