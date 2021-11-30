%% Sept. 2021, Blake Mitchell

% User Guide: *Important*
% Companion function: genDotRecordMl2
% Before running dotmapping (see below), open genDotRecordMl2:
% 1) Theta, 2) Eccentricity, 3) Contrast

% % PARADIGM
%  NAME         | # of correct trials 
% -----------------------------------
% 'dotmapping'  | 100-200           


%% BEGIN
% Initialize the escape key
hotkey('esc', 'escape_screen(); assignin(''caller'',''continue_'',false);');

global SAVEPATH DOTRECORD datafile npres
if TrialRecord.CurrentTrialNumber == 1
    DOTRECORD = [];
end

datafile = MLConfig.FormattedName;
USER = getenv('username');
outputFolder = datafile(1:8);
flag_save = 1;

if strcmp(USER,'maierlab') && flag_save == 1
    SAVEPATH = strcat('C:\MLData\',outputFolder);
else
    SAVEPATH = strcat(fileparts(which('T_dotmapping.m')),'\','output files');
end

set_bgcolor([0.5 0.5 0.5]);

%% Initial code

timestamp = datestr(now); % Get the current time on the computer

% Set fixation point
fixpt = [0 0]; % [x y] in viual degrees
fixThreshold = 1; % degrees of visual angle

% define intervals for WaitThenHold
wait_for_fix = 5000;
initial_fix = 200; % hold fixation for 200ms to initiate trial

% Find screen size
scrsize = Screen.SubjectScreenFullSize / Screen.PixelsPerDegree;  % Screen size [x y] in degrees
setCoord(scrsize); % Send value to a global variable
pd_position = [(scrsize(1)*0.5-0.5) (scrsize(2)*(-0.5)+0.5)];

hotkey('c', 'forced_eye_drift_correction([((-0.25*scrsize(1))+fixpt(1)) fixpt(2)],1);');  % eye1


% Trial number increases by 1 for every iteration of the code
trialNum = tnum(TrialRecord);

stimdur = 200;
isi = 200;

%% On the 1st trial

if trialNum == 1
    % Generate dOTRECORD
    genDotRecordML2(TrialRecord);
    
    % Generate the background image
    genFixCross((fixpt(1)*Screen.PixelsPerDegree), (fixpt(2)*Screen.PixelsPerDegree));
    
    filename = fullfile(SAVEPATH,sprintf('%s.gDotsXY_di',datafile));
    fid = fopen(filename, 'w');
    formatSpec =  '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n';
    fprintf(fid,formatSpec,...
        'trial',...
        'horzdva',...
        'vertdva',...
        'dot_x',...
        'dot_y',...
        'dot_eye',...
        'diameter',...
        'contrast',...
        'fix_x',...
        'fix_y',...
        'timestamp');
    fclose(fid);
    
elseif size(DOTRECORD,2) < trialNum
    %GENERATE NEW GRATING RECORD IF THIS TRIAL IS LONGER THAN CURRENT GRATINGRECORD
    genDotRecordML2(TrialRecord);
    disp('Number of minimum trials met');
end

%% Create Dots for the current trial

for presN = 1:npres
    [DOTS{presN}, dot_diameter(presN)] = makeDots(TrialRecord,Screen,presN);
end

%% Set the dot patch coordinates/parameters

dot_contrast          = DOTRECORD(trialNum).dot_contrast;
dot_x                 = DOTRECORD(trialNum).dot_xpos;
dot_y                 = DOTRECORD(trialNum).dot_ypos;
dot_eye               = DOTRECORD(trialNum).dot_eye;

corrected_x = nan(1,5); % preallocate
corrected_y = nan(1,5);

for p = 1:npres
    if dot_eye(p) == 2
        corrected_x(p) = dot_x(p) + (0.25*scrsize(1)) + fixpt(1);
        corrected_y(p) = dot_y(p) + fixpt(2);
    elseif dot_eye(p) == 3
        corrected_x(p) = dot_x(p) - (0.25*scrsize(1)) + fixpt(1);
        corrected_y(p) = dot_y(p) + fixpt(2);
    end
     sprintf('Trial # %d | x = %d | y = %d \n',trialNum,dot_x(p),dot_y(p))
end



%% Trial sequence event markers
% send some event markers
eventmarker(116 + TrialRecord.CurrentBlock); %block first
eventmarker(116 + TrialRecord.CurrentCondition); %condition second
eventmarker(116 + mod(TrialRecord.CurrentTrialNumber,10)); %last diget of trial sent third

%% Scene 1. Fixation
% Set fixation to the left eye for tracking
fix1 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix1.Target = [(-0.25*scrsize(1))+fixpt(1) fixpt(2)]; % Set the fixation point
fix1.Threshold = fixThreshold; % Set the fixation threshold

bck1 = ImageGraphic(fix1);
bck1.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

wth1 = WaitThenHold(bck1); % Initialize the wait and hold adapter
wth1.WaitTime = wait_for_fix; % Set the wait time
wth1.HoldTime = initial_fix; % Set the hold time

scene1 = create_scene(wth1); % Initialize the scene adapter

%% Scene 2. Task Object #1
% Set fixation to the left eye for tracking
fix2 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix2.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix2.Threshold = fixThreshold; % Set the fixation threshold

pd2 = BoxGraphic(fix2);
pd2.EdgeColor = [1 1 1];
pd2.FaceColor = [1 1 1];
pd2.Size = [3 3];
pd2.Position = pd_position;

% Display patch
img2 = ImageGraphic(pd2);
img2.List = { {DOTS{1}}, [corrected_x(1) corrected_y(1)] };

bck2 = ImageGraphic(img2);
bck2.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

wth2 = WaitThenHold(bck2);
wth2.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
wth2.HoldTime = stimdur;

scene2 = create_scene(wth2);

%% Scene 3. Inter-stimulus interval
fix3 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix3.Target = [(-0.25*scrsize(1))+fixpt(1) fixpt(2)]; % Set the fixation point
fix3.Threshold = fixThreshold; % Set the fixation threshold

pd3 = BoxGraphic(fix3);
pd3.EdgeColor = [0 0 0];
pd3.FaceColor = [0 0 0];
pd3.Size = [3 3];
pd3.Position = pd_position;

bck3 = ImageGraphic(pd3);
bck3.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

wth3 = WaitThenHold(bck3);
wth3.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
wth3.HoldTime = isi;
scene3 = create_scene(wth3);

%% Scene 4. Task Object #2
% Set fixation to the left eye for tracking
fix4 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix4.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix4.Threshold = fixThreshold; % Set the fixation threshold

% Photodiode
pd4 = BoxGraphic(fix4);
pd4.EdgeColor = [1 1 1];
pd4.FaceColor = [1 1 1];
pd4.Size = [3 3];
pd4.Position = pd_position;

% Display patch
img4 = ImageGraphic(pd4);
img4.List = { {DOTS{2}}, [corrected_x(2) corrected_y(2)] };

% stereo background
bck4 = ImageGraphic(img4);
bck4.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Hold timer
wth4 = WaitThenHold(bck4);
wth4.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
wth4.HoldTime = stimdur;

% Create Scene
scene4 = create_scene(wth4);

%% Scene 5. Task Object #3
% Set fixation to the left eye for tracking
fix5 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix5.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix5.Threshold = fixThreshold; % Set the fixation threshold

% Photodiode
pd5 = BoxGraphic(fix5);
pd5.EdgeColor = [1 1 1];
pd5.FaceColor = [1 1 1];
pd5.Size = [3 3];
pd5.Position = pd_position;

% Display patch
img5 = ImageGraphic(pd5);
img5.List = { {DOTS{3}}, [corrected_x(3) corrected_y(3)] };

% stereo background
bck5 = ImageGraphic(img5);
bck5.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Hold timer
wth5 = WaitThenHold(bck5);
wth5.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
wth5.HoldTime = stimdur;

% Create Scene
scene5 = create_scene(wth5);

%% Scene 6. Task Object #4
% Set fixation to the left eye for tracking
fix6 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix6.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix6.Threshold = fixThreshold; % Set the fixation threshold

% Photodiode
pd6 = BoxGraphic(fix6);
pd6.EdgeColor = [1 1 1];
pd6.FaceColor = [1 1 1];
pd6.Size = [3 3];
pd6.Position = pd_position;

% Display patch
img6 = ImageGraphic(pd6);
img6.List = { {DOTS{4}}, [corrected_x(4) corrected_y(4)] };

% stereo background
bck6 = ImageGraphic(img6);
bck6.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Hold timer
wth6 = WaitThenHold(bck6);
wth6.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
wth6.HoldTime = stimdur;

% Create Scene
scene6 = create_scene(wth6);

%% Scene 7. Task Object #5
% Set fixation to the left eye for tracking
fix7 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix7.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix7.Threshold = fixThreshold; % Set the fixation threshold

% Photodiode
pd7 = BoxGraphic(fix7);
pd7.EdgeColor = [1 1 1];
pd7.FaceColor = [1 1 1];
pd7.Size = [3 3];
pd7.Position = pd_position;

% Display patch
img7 = ImageGraphic(pd7);
img7.List = { {DOTS{5}}, [corrected_x(5) corrected_y(5)] };

% stereo background
bck7 = ImageGraphic(img7);
bck7.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Hold timer
wth7 = WaitThenHold(bck7);
wth7.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
wth7.HoldTime = stimdur;

% Create Scene
scene7 = create_scene(wth7);

%% Scene 8. Clear fixation cross

bck8 = ImageGraphic(null_);
bck8.List = { {'graybackground.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Set the timer
cnt8 = TimeCounter(bck8);
cnt8.Duration = 50;
scene8 = create_scene(cnt8);

%% TASK
error_type = 0;
run_scene(scene1,[35,11]); % WaitThenHold | 35 = Fix spot on, 11 = Start wait fixation
if ~wth1.Success             % If the WithThenHold failed (either fixation is not acquired or broken during hold),
    if wth1.Waiting          %    check whether we were waiting for fixation.
        error_type = 4;      % If so, fixation was never made and therefore this is a "no fixation (4)" error.
        run_scene(scene8,[12]);  % blank screen | 12 = end wait fixation
    else
        error_type = 3;      % If we were not waiting, it means that fixation was acquired but not held,
        run_scene(scene8,[97,36]);   % blank screen | 97 = fixation broken, 36 = fix cross OFF
    end   %    so this is a "break fixation (3)" error.
else
    eventmarker(8); % 8 = fixation occurs
end

if 0==error_type
    run_scene(scene2,23);    % Run the second scene (eventmarker 23 'taskObject-1 ON')
    if ~fix2.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene8,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
        %eventmarker(24) % 24 = task object 1 OFF 
    end
end

if 0==error_type
    run_scene(scene3,24);    % Run the third scene - This is the blank offset between flashes
    if ~fix3.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene8,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
% %         eventmarker(24) % 24 = task object 1 OFF 
    end
end

if 0==error_type
    run_scene(scene4,25);    % Run the fourth scene (eventmarker 25 - TaskObject - 2 ON) 
    if ~fix4.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene8,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
% %         eventmarker(26) % 26 = task object 2 OFF 
    end
end

if 0==error_type
    run_scene(scene3,26);    % Run the third scene - This is the blank offset between flashes
    if ~fix3.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene8,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
% %         eventmarker(24) % 24 = task object 1 OFF 
    end
end

if 0==error_type
    run_scene(scene5,27);    % Run the fifth scene (eventmarker 27 - TaskObject - 3 ON) 
    if ~fix5.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene8,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
% %         eventmarker(26) % 26 = task object 2 OFF 
    end
end


if 0==error_type
    run_scene(scene3,28);    % Run the third scene - This is the blank offset between flashes
    if ~fix3.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene8,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
% %         eventmarker(24) % 24 = task object 1 OFF 
    end
end

if 0==error_type
    run_scene(scene6,29);    % Run the sixth scene (eventmarker 29 - TaskObject - 4 ON) 
    if ~fix6.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene8,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
% %         eventmarker(26) % 26 = task object 2 OFF 
    end
end

if 0==error_type
    run_scene(scene3,30);    % Run the third scene - This is the blank offset between flashes
    if ~fix3.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene8,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
% %         eventmarker(24) % 24 = task object 1 OFF 
    end
end

if 0==error_type
    run_scene(scene7,31);    % Run the 7th scene (eventmarker 31 - TaskObject - 5 ON) 
    if ~fix7.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene8,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
% %         eventmarker(26) % 26 = task object 2 OFF 
    end
end


% reward
if 0==error_type
    run_scene(scene8,[32,36]); % event code for fix cross OFF 
    goodmonkey(100, 'juiceline',1, 'numreward',2, 'pausetime',200, 'eventmarker',96); % 100 ms of juice x 2. Event marker for reward
end

trialerror(error_type);      % Add the result to the trial history


%% Give the monkey a break
set_iti(500); % Inter-trial interval in [ms]

%% Write info to file

filename = fullfile(SAVEPATH,sprintf('%s.gDotsXY_di',datafile));


for pres = 1:npres
    [X(pres),Y(pres)] = findScreenPosML2(dot_eye(pres),Screen,dot_x(pres),dot_y(pres),'cart');
    fid = fopen(filename, 'a');  % append
    formatSpec =  '%04u\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\r\n';
    fprintf(fid,formatSpec,...
        TrialRecord.CurrentTrialNumber,...
        X(pres),... % needs DEV (maybe fixed?) does the horizontal DVA match up with older files?
        Y(pres),... % needs DEV
        dot_x(pres),...
        dot_y(pres),...
        dot_eye(pres),...
        dot_diameter(pres),...
        dot_contrast(pres),...
        fixpt(1),...
        fixpt(2),...
        now);
    
    fclose(fid);
end
