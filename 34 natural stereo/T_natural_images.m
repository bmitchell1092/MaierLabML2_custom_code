%% Jun 2019, Jacob Rogatinsky

%% Initial code
% Paradigm selection
% 'posdisparity'    Grating location varies trial to trial, eye to eye
pdgm = 'posdisparity';

timestamp = datestr(now); % Get the current time on the computer

% Set dominant eye
de = 3; % 1 = binocular, 2 = right eye, 3 = left eye
setDE(de); % Send value to a global variable

% Set receptive field
rf = [3 -3]; % [x y] in visual degrees
setRF(rf);

% Set fixation point
fixpt = [0 0]; % [x y] in viual degrees
fixThreshold = 1; % degrees of visual angle

% define intervals for WaitThenHold
wait_for_fix = 10000;
initial_fix = 200;
presentation_duration = 250;
blank_interval = 500;

% Find screen size
scrsize = Screen.SubjectScreenFullSize / Screen.PixelsPerDegree;  % Screen size [x y] in degrees
setCoord(scrsize); % Send value to a global variable

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
    
    taskdir = fileparts(which('T_natural_images.m'));
    fid = fopen(strcat(taskdir,'/','natural_images.txt'), 'w'); % Write to a text file
    formatSpec =  '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\n';
    fprintf(fid,formatSpec,...
        'Trial Number',...
        'Paradigm',...
        'Time Stamp',...
        'RF X-Coord',...
        'RF Y-Coord',...
        'Fixation X-Coord',...
        'Fixation Y-Coord',...
        'Dominant Eye',...
        'NonDom Eye',...
        'Image ID',...
        'Image type',...
        'Image orientation',...
        'Pos Disparity');
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
    r = genNiParams(pdgm); % Call the pseudorandomizer function
    
% If it's not the first trial
else
    rng(sdnum) % Set the randomizer seed
    r = genNiParams(pdgm); % Call the pseudorandomizer function
    
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

time = presentation_duration; %r(1).tme; % Duration of grating presentation in [ms]
xloc_left = r(1).lftxloc; % Left eye x-coordinate
xloc_right = r(1).rtxloc; % Right eye x-coordinate
ori = r(1).ori;
gray = [0.5 0.5 0.5]; 

if de == 3
    de_string = 'Left';
    nde_string = 'Right';
    domloc = xloc_left;
    ndomloc = xloc_right;
    
    rfloc = rf(2) - (0.25*scrsize(1));
elseif de == 2

    de_string = 'Right';
    nde_string = 'Left';
    domloc = xloc_right;
    ndomloc = xloc_left;
    
    rfloc = rf(2) - (0.25*scrsize(1));

else
    de_string = 'Binocular';
    nde_string = 'Binocular';
    domloc = xloc_right;
    ndomloc = xloc_left;
    
    rfloc = rf(2) - (0.25*scrsize(1));

end

task_dir = fileparts(which('T_natural_images.m'));

% original or scrambled 
scrambled = r(1).scramble;

switch scrambled
    case 0
        imagedir = strcat(task_dir,'/image/');
    case 1
        imagedir = strcat(task_dir,'/image_scr/');
        
end

% image selection 
img_id = r(1).img_id;
files = dir(imagedir); files(1:2) = [];
image = strcat(imagedir,files(img_id).name);
imSize = [Screen.SubjectScreenFullSize(1)/12 Screen.SubjectScreenFullSize(2)/7];

%% Scene 1. Initial fixation
% Set fixation to the left eye for tracking
fix1 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix1.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix1.Threshold = fixThreshold; % Set the fixation threshold

% Set the background image
bckg1 = ImageGraphic(fix1);
bckg1.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Wait for fixation
wth1 = WaitThenHold(bckg1); % Initialize the wait and hold adapter
wth1.WaitTime = wait_for_fix; % Set the wait time
wth1.HoldTime = initial_fix; % Set the hold time

% Create the scene
scene1 = create_scene(wth1); % Initialize the scene adapter

%% Scene 2. 1st Presentation
bhv_code(0, 'stim onset', 1, 'stim offset');

% initiate eye tracker
fix2 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix2.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix2.Threshold = fixThreshold; % Set the fixation threshold

% present custom image
img2 = ImageGraphic(fix2);
img2.List = { {image}, [xloc_left rf(2)], [0 0 0], imSize ,ori;
              {image}, [xloc_right rf(2)], [0 0 0], imSize, ori};
          
         
% Set the timer
cnt2 = TimeCounter(img2);
cnt2.Duration = presentation_duration;
          
oom2 = OnOffMarker(cnt2);
oom2.OnMarker = 1;
oom2.OffMarker = 0;

% background
bckg2 = ImageGraphic(oom2);
bckg2.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Run the scene
scene2 = create_scene(bckg2);

%% Scene 3: Blank interval 

fix3 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix3.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix3.Threshold = fixThreshold; % Set the fixation threshold

bckg3 = ImageGraphic(fix3);
bckg3.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Set the timer
cnt3 = TimeCounter(bckg3);
cnt3.Duration = blank_interval;

% Run the scene
scene3 = create_scene(cnt3);

%% Scene 4: 2nd Presentation 

% initiate eye tracker
fix4 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix4.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix4.Threshold = fixThreshold; % Set the fixation threshold

img4 = ImageGraphic(fix4);
img4.List = { {image}, [xloc_left rf(2)], [0 0 0], imSize ,ori;
              {image}, [xloc_right rf(2)], [0 0 0], imSize, ori};
          
% Set the timer
cnt4 = TimeCounter(img4);
cnt4.Duration = presentation_duration;
          
oom4 = OnOffMarker(cnt4);
oom4.OnMarker = 1;
oom4.OffMarker = 0;

% background
bckg4 = ImageGraphic(oom4);
bckg4.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Run the scene
scene4 = create_scene(bckg4);

%% TASK
error_type = 0;


run_scene(scene1,10); % Run scene
if ~wth1.Success             % If the WithThenHold failed (either fixation is not acquired or broken during hold),
    if wth1.Waiting          %    check whether we were waiting for fixation.
        error_type = 1;      % If so, fixation was never made and therefore this is a "no fixation (4)" error.
    else
        error_type = 2;      % If we were not waiting, it means that fixation was acquired but not held,
        %idle(0);                 % Clear screens
    end                      %    so this is a "break fixation (3)" error.
end

if error_type == 0
    run_scene(scene2,20);    % Run the second scene (eventmarker 20)
    if ~fix2.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        %idle(0);                 % Clear screens
    end
end

if error_type == 0
    run_scene(scene3,30);    % Run the second scene (eventmarker 20)
    if ~fix3.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 4;      % So it is a "break fixation (3)" error.
        %idle(0);                 % Clear screens
    end
end

if error_type == 0
    run_scene(scene4,40);    % Run the second scene (eventmarker 20)
    if ~fix3.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 5;      % So it is a "break fixation (3)" error.
        %idle(0);                 % Clear screens
    end
end

% reward
if error_type == 0
%     idle(0);                 % Clear screens
    goodmonkey(100, 'juiceline',1, 'numreward',2, 'pausetime',500, 'eventmarker',50); % 100 ms of juice x 2
end


trialerror(error_type);      % Add the result to the trial history

%% Write info to file
taskdir = fileparts(which('T_natural_images.m'));
fid = fopen(strcat(taskdir,'/','natural_images.txt'), 'a'); % Write to a text file
formatSpec =  '%f\t%s\t%f\t%f\t%f\t%f\t%f\t%s\t%s\t%f\t%f\t%f\t%f\t\n';
fprintf(fid,formatSpec,...
    trialnum,...
    pdgm,...
    timestamp,...
    domloc,...
    rf(2),...
    ((-0.25*scrsize(1))+fixpt(1)),...
    fixpt(2),...
    de_string,...
    nde_string,...
    img_id,...
    scrambled,...
    ori,...
    domloc+ndomloc);
fclose(fid);
    
%% Give the monkey a break
set_iti(800); % Inter-trial interval in [ms]

