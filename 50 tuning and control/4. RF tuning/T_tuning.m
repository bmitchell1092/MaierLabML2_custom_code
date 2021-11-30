%% Sept. 2021, Blake Mitchell

% User Guide: *Important*
% Companion function: genGratingRecordMl2
% Before running any paradigm (see below), always check:
% 1) Position, 2) Orientation, 3) Spatial frequency
% 4) Phase, 5) Diameter (size), 6) Contrast, and 7) Eye! 

% % PARADIGMS
%  NAME      | # of correct trials 
% -----------------------------------
% 'rfori'    | 80           
% 'rfsize'   | 35   
% 'rfsf'     | 20       
% 'rfphase'  | 25

% Extras
% 'rforiWithBlanks' 
   

%% Paradigm selection : 3 presentations per trial
paradigm = 'rforiWithBlanks';

% Note: Open genGratingRecordML2 to change parameters of gratings.

%% BEGIN
% Initialize the escape key
hotkey('esc', 'escape_screen(); assignin(''caller'',''continue_'',false);');

global SAVEPATH GRATINGRECORD prespertr datafile
if TrialRecord.CurrentTrialNumber == 1
    GRATINGRECORD = [];
end

datafile = MLConfig.FormattedName;
USER = getenv('username');
outputFolder = datafile(1:8);
flag_save = 1;

if strcmp(USER,'maierlab') && flag_save == 1
    SAVEPATH = strcat('C:\MLData\',outputFolder); 
else
    SAVEPATH = strcat(fileparts(which('T_tuning.m')),'\','output files');
end

%% Constant variables
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
lower_right = [(scrsize(1)*(0.5)-0.5) (scrsize(2)*(-0.5)+0.5)];
lower_left  = [(scrsize(1)*(-0.5)+1) (scrsize(2)*(-0.5)+1)];


hotkey('c', 'forced_eye_drift_correction([((-0.25*scrsize(1))+fixpt(1)) fixpt(2)],1);');  % eye1
set_bgcolor([0.5 0.5 0.5]);

% Trial number increases by 1 for every iteration of the code
tr = tnum(TrialRecord);

if tr == 1 % on the first trial
    
    % generate grating record
    genGratingRecordML2(paradigm,TrialRecord);
    
    % generate fixation cross location
    genFixCross((fixpt(1)*Screen.PixelsPerDegree), (fixpt(2)*Screen.PixelsPerDegree));
    
    % Create a file to write grating information for each trial

    filename_1 = strcat(SAVEPATH,'/',datafile,'.g',upper(paradigm),'Grating_di');
    
    fid = fopen(filename_1, 'w');
    formatSpec =  '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n';
    fprintf(fid,formatSpec,...
        'trial',...
        'horzdva',...
        'vertdva',...
        'grating_xpos',...
        'grating_ypos',...
        'other_xpos',...
        'other_ypos',...
        'grating_tilt',...
        'grating_sf',...
        'grating_contrast',...
        'grating_fixedc',...
        'grating_diameter',...
        'grating_eye',...
        'grating_tf',...
        'grating_oridist',...
        'trialHasBlank',... % whether trial has an oddball blank presentation
        'PresOn',... % gabor_std
        'header',...
        'grating_phase',...
        'pathw',...
        'timestamp');
    
    fclose(fid);
    
    % 2021 New Grating File
    filename_2 = strcat(SAVEPATH,'/',datafile,'.g',upper(paradigm),'Grating_di_v2');
    
    fid = fopen(filename_2, 'w');
    formatSpec =  '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n';
    fprintf(fid,formatSpec,...
        'trial',...             % Trial number
        'header',...            % 'paradigm'
        'horzdva',...           % dva from fused fixation
        'vertdva',...           % dva from fused fixation
        'xpos_L',...            % actual x-position of grating in the LE
        'ypos_L',...            % actual x-position of grating in the RE
        'contrast_L',...            % actual y-position of grating in the LE
        'tilt_L',...            % actual y-position of grating in the RE
        'phase_L',...       % difference (in visual deg) between LE and RE grating x-positions
        'sf_L',...       % difference (in visual deg) between LE and RE grating y-positions
        'tf_L',...        % Michelson contrast of grating in the LE
        'diameter_R',...        % Michelson contrast of grating in the RE
        'xpos_R',...             % orientation (tilt) of grating in the LE
        'ypos_R',...             % orientation (tilt) of grating in the RE
        'contrast_R',...           % Phase angle of grating in the LE
        'tilt_R',...           % Phase angle of grating in the RE
        'phase_R',...              % Spatial frequency (cyc/deg) of grating in the LE
        'sf_R',...              % Spatial frequency (cyc/deg) of grating in the RE
        'tf_R',...              % Temporal frequency (cyc/deg/sec) of grating in the LE
        'diameter_R',...              % Temporal frequency (cyc/deg/sec) of grating in the RE
        'x_disparity',...        % Diameter (size) of grating in the LE
        'y_disparity',...        % Diameter (size) of grating in the RE
        'trialHasBlank',...     % whether this trial has a blank presentation
        'presOn',...             % whether this presentation was a blank or not
        'gabor',...             % whether the grating was gabor filtered
        'gabor_std',...         % standard deviation of the gabor filter
        'eye',...               % 1 = LE, 2 = RE, 3 = Both eyes
        'duration',...          % stimulus duration
        'isi',...               % interstimulus interval
        'pathw',...             % for cone isolation
        'timestamp');
    
    fclose(fid);
    
elseif size(GRATINGRECORD,2) < tr
    %GENERATE NEW GRATING RECORD IF THIS TRIAL IS LONGER THAN CURRENT GRATINGRECORD
    genGratingRecordML2(paradigm,TrialRecord);
    disp('Number of minimum trials met');
end

%% Assign values to each sine grating condition
% Set the conditions

path = nan;
grating_tilt = GRATINGRECORD(tr).grating_tilt;
grating_eye = GRATINGRECORD(tr).grating_eye; % 1 = binocular, 2 = right eye, 3 = left eye
grating_phase = GRATINGRECORD(tr).grating_phase;
grating_sf = GRATINGRECORD(tr).grating_sf;
grating_tf = GRATINGRECORD(tr).grating_tf;
grating_contrast = GRATINGRECORD(tr).grating_contrast; % contrast is usually held constant in T_tuning.m
grating_diameter = GRATINGRECORD(tr).grating_diameter; % diameter is held constant
grating_xpos = GRATINGRECORD(tr).grating_xpos(1,:); 
grating_ypos = GRATINGRECORD(tr).grating_ypos(1,:);
other_xpos  = GRATINGRECORD(tr).grating_xpos(2,:);
other_ypos  = GRATINGRECORD(tr).grating_ypos(2,:);
stereo_xpos = GRATINGRECORD(tr).stereo_xpos(1,:); % left eye x-position
other_stereo_xpos = GRATINGRECORD(tr).stereo_xpos(2,:); % right eye x-position
grating_header = GRATINGRECORD(tr).header;
grating_varyeye = GRATINGRECORD(tr).grating_varyeye;
grating_fixedc = GRATINGRECORD(tr).grating_fixedc; % always 'nan' in T_tuning.m
grating_oridist = GRATINGRECORD(tr).grating_oridist;
grating_outerdiameter = GRATINGRECORD(tr).grating_outerdiameter;
grating_space = GRATINGRECORD(tr).grating_space;
grating_isi = GRATINGRECORD(tr).grating_isi;
grating_stimdur = GRATINGRECORD(tr).grating_stimdur;

% Variables for new textfile
tilt_L = grating_tilt; phase_L = grating_phase; sf_L = grating_sf; tf_L = grating_tf; diameter_L = grating_diameter;
tilt_R = grating_tilt; phase_R = grating_phase; sf_R = grating_sf; tf_R = grating_tf; diameter_R = grating_diameter;
xpos_L = stereo_xpos; ypos_L = grating_ypos;
xpos_R = other_stereo_xpos; ypos_R = other_ypos;

if strcmp(grating_header,'rforiWithBlanks')
    blankLikelihood = GRATINGRECORD(tr).blankLikelihood;
    r1 = rand(1,1);
    trialHasBlank = r1 <= blankLikelihood;
else
    trialHasBlank = false;
end

gray = [0.5 0.5 0.5];
L_color1 = nan(3,3); L_color2 = nan(3,3); % left grating contrast
R_color1 = nan(3,3); R_color2 = nan(3,3); % right grating contrast
pd_color1 = nan(3,3); pd_color2 = nan(3,3); % bottom lefthand corner grating (for pd)

for p = 1:prespertr
    if grating_eye(p) == 1 % both eyes
        contrast_L(p) = grating_contrast(p);
        contrast_R(p) = grating_contrast(p);
        
        L_color1(p,:) = gray + (grating_contrast(p) / 2);
        L_color2(p,:) = gray - (grating_contrast(p) / 2);
        
        R_color1(p,:) = gray + (grating_contrast(p) / 2);
        R_color2(p,:) = gray - (grating_contrast(p) / 2);
        
    elseif grating_eye(p) == 2 % right eye
        
        contrast_L(p) = NaN;
        contrast_R(p) = grating_contrast(p);
        L_color1(p,:) = gray;
        L_color2(p,:) = gray;
        
        R_color1(p,:) = gray + (grating_contrast(p) / 2);
        R_color2(p,:) = gray - (grating_contrast(p) / 2);
        
    elseif grating_eye(p) == 3 % left eye
        
        contrast_L(p) = grating_contrast(p);
        contrast_R(p) = NaN;
        
        L_color1(p,:) = gray + (grating_contrast(p) / 2);
        L_color2(p,:) = gray - (grating_contrast(p) / 2);
        
        R_color1(p,:) = gray;
        R_color2(p,:) = gray;
    end
    
    if p == 2 && trialHasBlank == true % this is a randomly interspersed blank presentation in the 2nd presentation
        
        fprintf('Blank on trial # %d | rng = %.02f \n',tr,r1)
        L_color1(p,:) = gray; 
        L_color2(p,:) = gray; 
        
        R_color1(p,:) = gray;
        R_color2(p,:) = gray;
        
        grating_contrast(p) = 0;
    end
    
    pd_color1(p,:) = [1 1 1] ; %gray + (grating_contrast(p) / 2);
    pd_color2(p,:) = [0 0 0] ; %gray - (grating_contrast(p) / 2);
        
end


%% Preallocate grating struct

GratingList.left = ...
    {[stereo_xpos(1) grating_ypos(1)], grating_diameter(1)/2, grating_tilt(1), grating_sf(1), grating_tf(1), grating_phase(1), L_color1(1,:), L_color2(1,:), 'circular', []; ...
    [stereo_xpos(2) grating_ypos(2)], grating_diameter(2)/2, grating_tilt(2), grating_sf(2), grating_tf(2), grating_phase(2), L_color1(2,:), L_color2(2,:), 'circular', [];...
    [stereo_xpos(3) grating_ypos(3)], grating_diameter(3)/2, grating_tilt(3), grating_sf(3), grating_tf(3), grating_phase(3), L_color1(3,:), L_color2(3,:), 'circular', []};

GratingList.right = ...
    {[other_stereo_xpos(1) other_ypos(1)], grating_diameter(1)/2, grating_tilt(1), grating_sf(1), grating_tf(1), grating_phase(1), R_color1(1,:), R_color2(1,:), 'circular', []; ...
    [other_stereo_xpos(2) other_ypos(2)], grating_diameter(2)/2, grating_tilt(2), grating_sf(2), grating_tf(2), grating_phase(2), R_color1(2,:), R_color2(2,:), 'circular', [];...
    [other_stereo_xpos(3) other_ypos(3)], grating_diameter(3)/2, grating_tilt(3), grating_sf(3), grating_tf(3), grating_phase(3), R_color1(3,:), R_color2(3,:), 'circular', []};

GratingList.drift_pd = ...
    {[lower_left(1) lower_left(2)], 2, grating_tilt(1), 0, grating_tf(1), grating_phase(1), pd_color1(1,:), pd_color2(1,:), 'circular', []; ...
    [lower_left(1) lower_left(2)], 2, grating_tilt(2), 0, grating_tf(2), grating_phase(2), pd_color1(2,:), pd_color2(2,:), 'circular', [];...
    [lower_left(1) lower_left(2)], 2, grating_tilt(3), 0, grating_tf(3), grating_phase(3), pd_color1(3,:), pd_color2(3,:), 'circular', []};

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
pd2.Position = lower_right;

% Create both gratings
grat2 = SineGrating(pd2);
grat2.List = {GratingList.left{1,:};GratingList.right{1,:}; GratingList.drift_pd{1,:}};
img2 = ImageGraphic(grat2);
img2.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };
wth2 = WaitThenHold(img2);
wth2.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
wth2.HoldTime = grating_stimdur;
scene2 = create_scene(wth2);

%% Scene 3. Inter-stimulus interval

fix3 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix3.Target = [(-0.25*scrsize(1))+fixpt(1) fixpt(2)]; % Set the fixation point
fix3.Threshold = fixThreshold; % Set the fixation threshold

pd3 = BoxGraphic(fix3);
pd3.EdgeColor = [0 0 0];
pd3.FaceColor = [0 0 0];
pd3.Size = [3 3];
pd3.Position = lower_right;

bck3 = ImageGraphic(pd3);
bck3.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

wth3 = WaitThenHold(bck3);
wth3.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
wth3.HoldTime = grating_stimdur;
scene3 = create_scene(wth3);

%% Scene 4. Task Object #2
% Set fixation to the left eye for tracking
fix4 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix4.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix4.Threshold = fixThreshold; % Set the fixation threshold

pd4 = BoxGraphic(fix4);
pd4.EdgeColor = [1 1 1];
pd4.FaceColor = [1 1 1];
pd4.Size = [3 3];
pd4.Position = lower_right;

% Create both gratings
grat4 = SineGrating(pd4);
grat4.List =  {GratingList.left{2,:};GratingList.right{2,:}; GratingList.drift_pd{2,:}};
img4 = ImageGraphic(grat4);
img4.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };
wth4 = WaitThenHold(img4);
wth4.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
wth4.HoldTime = grating_stimdur;
scene4 = create_scene(wth4);


%% Scene 5. Task Object #3
% Set fixation to the left eye for tracking
fix5 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix5.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix5.Threshold = fixThreshold; % Set the fixation threshold

pd5 = BoxGraphic(fix5);
pd5.EdgeColor = [1 1 1];
pd5.FaceColor = [1 1 1];
pd5.Size = [3 3];
pd5.Position = lower_right;

% Create both gratings
grat5 = SineGrating(pd5);
grat5.List =  {GratingList.left{3,:};GratingList.right{3,:}; GratingList.drift_pd{3,:}};
img5 = ImageGraphic(grat5);
img5.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };
wth5 = WaitThenHold(img5);
wth5.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
wth5.HoldTime = grating_stimdur;
scene5 = create_scene(wth5);


% %% Scene 6. Task Object #4
% % Set fixation to the left eye for tracking
% fix6 = SingleTarget(eye_); % Initialize the eye tracking adapter
% fix6.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
% fix6.Threshold = fixThreshold; % Set the fixation threshold
% 
% pd6 = BoxGraphic(fix6);
% pd6.EdgeColor = [1 1 1];
% pd6.FaceColor = [1 1 1];
% pd6.Size = [3 3];
% pd6.Position = lower_right;
% 
% % Create both gratings
% grat6 = SineGrating(pd6);
% grat6.List =  {GratingList.left{4,:};GratingList.right{4,:}};
% img6 = ImageGraphic(grat6);
% img6.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };
% wth6 = WaitThenHold(img6);
% wth6.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
% wth6.HoldTime = 250;
% scene6 = create_scene(wth6);


% %% Scene 7. Task Object #5
% % Set fixation to the left eye for tracking
% fix7 = SingleTarget(eye_); % Initialize the eye tracking adapter
% fix7.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
% fix7.Threshold = fixThreshold; % Set the fixation threshold
% 
% pd7 = BoxGraphic(fix7);
% pd7.EdgeColor = [1 1 1];
% pd7.FaceColor = [1 1 1];
% pd7.Size = [3 3];
% pd7.Position = lower_right;
% 
% % Create both gratings
% grat7 = SineGrating(pd7);
% grat7.List =  {GratingList.left{5,:};GratingList.right{5,:}};
% img7 = ImageGraphic(grat7);
% img7.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };
% wth7 = WaitThenHold(img7);
% wth7.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
% wth7.HoldTime = 250;
% scene7 = create_scene(wth7);


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


% if 0==error_type
%     run_scene(scene3,28);    % Run the third scene - This is the blank offset between flashes
%     if ~fix3.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
%         error_type = 3;      % So it is a "break fixation (3)" error.
%         run_scene(scene8,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
%     else
% % %         eventmarker(24) % 24 = task object 1 OFF 
%     end
% end
% 
% if 0==error_type
%     run_scene(scene6,29);    % Run the sixth scene (eventmarker 29 - TaskObject - 4 ON) 
%     if ~fix6.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
%         error_type = 3;      % So it is a "break fixation (3)" error.
%         run_scene(scene8,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
%     else
% % %         eventmarker(26) % 26 = task object 2 OFF 
%     end
% end

% if 0==error_type
%     run_scene(scene3,30);    % Run the third scene - This is the blank offset between flashes
%     if ~fix3.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
%         error_type = 3;      % So it is a "break fixation (3)" error.
%         run_scene(scene8,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
%     else
% % %         eventmarker(24) % 24 = task object 1 OFF 
%     end
% end
% 
% if 0==error_type
%     run_scene(scene7,31);    % Run the 7th scene (eventmarker 31 - TaskObject - 5 ON) 
%     if ~fix7.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
%         error_type = 3;      % So it is a "break fixation (3)" error.
%         run_scene(scene8,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
%     else
% % %         eventmarker(26) % 26 = task object 2 OFF 
%     end
% end


% reward
if 0==error_type
    run_scene(scene8,[28,36]); % event code for fix cross OFF 
    goodmonkey(100, 'juiceline',1, 'numreward',2, 'pausetime',200, 'eventmarker',96); % 100 ms of juice x 2. Event marker for reward
end

trialerror(error_type);      % Add the result to the trial history

%% Give the monkey a break
set_iti(800); % Inter-trial interval in [ms]

%% Create variables to completely describe what was shown to the monkey

%% Write info to file

filename_1 = strcat(SAVEPATH,'\',datafile,'.g',upper(paradigm),'Grating_di');
filename_2 = strcat(SAVEPATH,'\',datafile,'.g',upper(paradigm),'Grating_di_v2'); % 2021 and beyond

if trialHasBlank == true
    presOn =[1,0,1]; % if trial has a blank, the 2nd presentation is off '0'
else
    presOn = [1,1,1]; % otherwise, all presentations are on '1'
end
    
for pres = 1:prespertr
    
    % Legacy file and variables
    fid = fopen(filename_1, 'a'); % append
    formatSpec =  '%04u\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%u\t%f\t%s\t%f\t%f\t%f\r\n';
    fprintf(fid,formatSpec,...
        TrialRecord.CurrentTrialNumber,...
        grating_xpos(pres),... % in degrees of visual angle
        grating_ypos(pres),... 
        stereo_xpos(pres),...
        grating_ypos(pres),...
        other_xpos(pres),...
        other_ypos(pres),...
        grating_tilt(pres),...
        grating_sf(pres),...
        grating_contrast(pres),...
        grating_fixedc(pres),...
        grating_diameter(pres),...
        grating_eye(pres),...
        grating_tf(pres),...
        grating_oridist(pres),...
        trialHasBlank,...
        presOn(pres),...
        grating_header,...
        grating_phase(pres),...
        0,...
        now);
    
    fclose(fid);
    
     % Textfile # 2 (beta)
     % New file and variables
     
     % establish what was shown on screen. 
     if grating_eye(pres) == 2 % if grating appears in right-eye 
         tilt_L(pres) = NaN; phase_L(pres) = NaN; diameter_L(pres) = NaN;
         sf_L(pres) = NaN; tf_L(pres) = NaN; xpos_L(pres) = NaN; ypos_L(pres) = NaN;
     elseif grating_eye(pres) == 3 % if grating appears in left eye
         tilt_R(pres) = NaN; phase_R(pres) = NaN; diameter_R(pres) = NaN;
         sf_R(pres) = NaN; tf_R(pres) = NaN; xpos_R(pres) = NaN; ypos_R(pres) = NaN;
     end
         
     
     fid = fopen(filename_2, 'a'); % append
     formatSpec =  '%04u\t%s\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\r\n';
     fprintf(fid,formatSpec,...
         TrialRecord.CurrentTrialNumber,...
         grating_header,...             
         grating_xpos(pres),...           
         grating_ypos(pres),...          
         xpos_L(pres)',...           
         ypos_L(pres),...            
         contrast_L(pres),...           
         tilt_L(pres),...            
         phase_L(pres),...                             
         sf_L(pres),...                             
         tf_L(pres),...              
         diameter_L(pres),...             
         xpos_R(pres),...             
         ypos_R(pres),...             
         contrast_R(pres),...         
         tilt_R(pres),...          
         phase_R(pres),...             
         sf_R(pres),...              
         tf_R(pres),...              
         diameter_R(pres),...            
         0,...                          
         0,...        
         trialHasBlank,...                 % whether this trial has a blank presentation
         presOn(pres),...                  % whether this presentation was a blank or not
         0,...                             % whether the grating was gabor filtered
         0,...                             
         grating_eye(pres),...             % 1 = LE, 2 = RE, 3 = Both eyes
         grating_stimdur,...               % stimulus duration
         grating_isi,...                   % interstimulus interval
         nan,...                            % for cone isolation
         now);
     
     fclose(fid);
end

    

