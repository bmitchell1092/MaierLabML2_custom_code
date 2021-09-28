%% Sept. 2021, Blake Mitchell 
% Aug 2019, Jacob Rogatinsky


%mouse_.showcursor(false);  % hide the mouse cursor from the subject

% % Event Codes
% bhv_code(8,'Fixation occurs',11,'Start wait fixation',12,'End wait fixation',...
%     23,'TaskObject-1 ON',24,'TaskObject-1 OFF',25,'TaskObject-2 ON',26,'TaskObject-2 OFF',...
%     27,'TaskObject-3 ON',28,'TaskObject-3 OFF',29,'TaskObject-4 ON',30,'TaskObject-4 OFF',...
%     31,'TaskObject-5 ON',32,'TaskObject-5 OFF',33,'TaskObject-6 ON',34,'TaskObject-6 OFF',...
%     35,'Fixation spot ON',36,'Fixation spot OFF',96,'Reward delivered',97,'Broke fixation');  

% Initialize the escape key
hotkey('esc', 'escape_screen(); assignin(''caller'',''continue_'',false);');

%% Initial code
% Paradigm selection
% 'monocular'       Switches through the four monocular stimuli
% 'dioptic'          Switches through the four simultaneus dioptic/dicoptic stimuli
% 'dichoptic'
% 'bminteroc'          Switches between user-defined stimulus combinations
pdgm = 'bminteroc';

timestamp = datestr(now); % Get the current time on the computer

% Find screen size
scrsize = Screen.SubjectScreenFullSize / Screen.PixelsPerDegree;  % Screen size [x y] in degrees
lower_right = [(scrsize(1)*0.5-0.5) (scrsize(2)*(-0.5)+0.5)];

% Set receptive field
rf = [3 -3]; % [x y] in visual degrees
setRF(rf);

% Set the fixation point
fixpt = [0 0]; % [x y] in visual degrees
fixThreshold = 3; % degrees of visual angle

% Timing
wait_for_fix = 5000;
initial_fix = 200;
presentation_dur = 250;  % Duration of trial in [ms]

% Set the constant conditions
de = 3;                                     % Dominant eye: 1 = binocular, 2 = right eye, 3 = left eye
ori = 45;                                   % Preferred or non-preferred orientation of grating
sf = 2;                                     % Cycles per degree
tf = 0;                                     % Cycles per second (0=static, 4=drifting)
diameter = 2;                               % Diameter of the grating
phase_angle = 0;                          % Phase angle in degrees (0-360)               
left_xloc = (-0.25*scrsize(1))+rf(1);       % Left eye x-coordinate
right_xloc = (0.25*scrsize(1))+rf(1);       % Right eye x-coordinate
trig_delay = 0;
                          
% Trial number increases by 1 for every iteration of the code
trialnum = tnum(TrialRecord);

if trialnum == 1
    setSeed(randi([1 1000])); % Send seed value to a global variable

    genFixCross((fixpt(1)*Screen.PixelsPerDegree), (fixpt(2)*Screen.PixelsPerDegree));

    taskdir = fileparts(which('T_bminteroc.m'));
    fid = fopen(strcat(taskdir,'/','bminteroc.g',upper(pdgm),'Grating_di'), 'w'); % Write to a text file
    formatSpec =  '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\n';
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
        'Pos Disparity',...
        'Paradigm',...
        'Phase Angle',...
        'Time Stamp',...
        'Asynchrony',...
        'Fixation X-Coord',...
        'Fixation Y-Coord');
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
    r = genBMinterocParams(pdgm); % Call the pseudorandomizer function
    
% If it's not the first trial
else
    rng(sdnum) % Set the randomizer seed
    r = genBMinterocParams(pdgm); % Call the pseudorandomizer function
    
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

%% Assign changing values to each sine grating
% Set the dominant and non-dominant x-coordinates and contrasts

if de == 3
    de_xloc = left_xloc;
    nde_xloc = right_xloc;
    de_string = 'Left';
    nde_string = 'Right';
    de_contr = r(1).contr_left; 
    nde_contr = r(1).contr_right;
    
    rfloc = rf(2) - (0.25*scrsize(1));
elseif de == 2
    de_xloc = right_xloc;
    nde_xloc = left_xloc;
    de_string = 'Right';
    nde_string = 'Left';
    de_contr = r(1).contr_right;
    nde_contr = r(1).contr_left;
    
    rfloc = rf(2) + (0.25*scrsize(1));
else
    de_xloc = right_xloc;
    nde_xloc = left_xloc;
    de_string = 'Binocular';
    nde_string = 'Binocular';
    de_contr = r(1).contr_right;
    nde_contr = r(1).contr_left;
    
    rfloc = rf(2) + (0.25*scrsize(1));
end

        
%% Set the location and orientation of all the stimuli
% Pull the conditions from genCinterocParams
stim_code = r(1).stim_code; % Stimulus code(1 to 16)

switch stim_code
    
    case 1
        % Monocular, DE, PO
        de_ori = ori;
        nde_ori = ori;
        de_diameter = diameter;
        nde_diameter = 0;
        
    case 2
        % Monocular, DE, NPO
        de_ori = ori + 90;
        nde_ori = ori + 90;
        de_diameter = diameter;
        nde_diameter = 0;
        
    case 3
        % Monocular, NDE, PO
        de_ori = ori;
        nde_ori = ori;
        de_diameter = 0;
        nde_diameter = diameter;

    case 4
        % Monocular, NDE, NPO
        de_ori = ori + 90;
        nde_ori = ori + 90;
        de_diameter = 0;
        nde_diameter = diameter;

    case 5        
        % Dioptic, PO
        de_ori = ori;
        nde_ori = ori;
        de_diameter = diameter;
        nde_diameter = diameter;
        
    case 6
       % Dioptic, NO
        de_ori = ori + 90;
        nde_ori = ori + 90;
        de_diameter = diameter;
        nde_diameter = diameter;
        
    case 7
        % Dioptic+Dichoptic, PO, different contrasts
        de_ori = ori;
        nde_ori = ori;
        de_diameter = diameter;
        nde_diameter = diameter;
        
    case 8
        % Dioptic+Dichoptic, NO, different contrasts
        de_ori = ori + 90;
        nde_ori = ori + 90;
        de_diameter = diameter;
        nde_diameter = diameter;
        
        
    case 9
        % Dichoptic, DE-PO, NDE-NPO
        de_ori = ori;
        nde_ori = ori + 90;
        de_diameter = diameter;
        nde_diameter = diameter;
         
    case 10
        % Dicoptic, DE-NPO, NDE-PO
        de_ori = ori + 90;
        nde_ori = ori;
        de_diameter = diameter;
        nde_diameter = diameter;
        
    case 11
        % Day 1 Task
        de_ori = ori;
        nde_ori = ori;
        
        if de_contr > 0
            de_diameter = diameter;
        else
            de_diameter = 0;
        end
        
        if nde_contr > 0
            nde_diameter = diameter;
        else
            nde_diameter = 0;
        end
        
end

% contrasts
gray = [0.5, 0.5, 0.5];
de_color1 = gray + (de_contr / 2);
de_color2 = gray - (de_contr / 2);

nde_color1 = gray + (nde_contr / 2);
nde_color2 = gray - (nde_contr / 2);


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


pd = BoxGraphic(fix2);
pd.EdgeColor = [1 1 1];
pd.FaceColor = [1 1 1];
pd.Size = [2 2];
pd.Position = lower_right;

% Create the first grating
grat1 = SineGrating(pd); 
grat1.Position = [de_xloc rf(2)];
grat1.Radius = de_diameter/2;
grat1.Direction = de_ori;
grat1.SpatialFrequency = sf;
grat1.TemporalFrequency = tf;
grat1.Color1 = de_color1;
grat1.Color2 = de_color2; 
grat1.Phase = phase_angle;
grat1.WindowType = 'circular';

% Create the second grating
grat2 = SineGrating(grat1); 
grat2.Trigger = true;
grat2.Position = [nde_xloc rf(2)];
grat2.Radius = nde_diameter/2;
grat2.Direction = nde_ori;
grat2.SpatialFrequency = sf;
grat2.TemporalFrequency = tf;
grat2.Color1 = nde_color1;
grat2.Color2 = nde_color2;
grat2.Phase = phase_angle;
grat2.WindowType = 'circular';

% background
bck2 = ImageGraphic(grat2);
bck2.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Set the timer
cnt2 = TimeCounter(bck2);
cnt2.Duration = presentation_dur;

% Create the scene
scene2 = create_scene(cnt2); % cnt

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

taskdir = fileparts(which('T_bminteroc.m'));
fid = fopen(strcat(taskdir,'bminteroc.g',upper(pdgm),'Grating_di'), 'a');
formatSpec =  '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%s\t%s\t%f\t%s\t%f\t%s\t%f\t%f\t%f\t\n';
fprintf(fid,formatSpec,...
    trialnum,...
    rfloc,...
    rf(2),...
    ori,...
    sf,...
    tf,...
    r(1).contr_left,...
    r(1).contr_right,...
    diameter,...
    de_string,...
    nde_string,...
    0,...
    pdgm,...
    phase_angle,...
    timestamp,...
    trig_delay,...
    ((-0.25*scrsize(1))+fixpt(1)),...
    fixpt(2));
    
fclose(fid);

%% Give the monkey a break
set_iti(800); % Inter-trial interval in [ms]

%%