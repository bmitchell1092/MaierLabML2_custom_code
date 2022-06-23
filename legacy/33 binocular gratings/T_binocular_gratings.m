%% Sept. 2021, Blake Mitchell

% User Guide: *Important*
% Companion function: genGratingRecordMl2
% Before running any paradigm (see below), always check:
% 1) Position, 2) Orientation, 3) Spatial frequency
% 4) Phase, 5) Diameter (size), and 6) Contrast! 

% % PARADIGMS
%  NAME            | # of correct trials 
% -----------------------------------
% 'bminteroc'      | 360            
% 'cinteroc'       |      
% 'bcosinteroc'    |        
% 'phzdisparity'   | 80
% 'posdisparity'   |        

% 10/26/2021: Note to Brock / Loic - if not instructed,
% always run 'bminteroc'

%% Paradigm selection
paradigm = 'bminteroc';

% Note: Open genGratingRecordML2 to change general parameters (params
% struct). 

%% BEGIN
% Initialize the escape key
hotkey('esc', 'escape_screen(); assignin(''caller'',''continue_'',false);');

global SAVEPATH GRATINGRECORD prespertr datafile 
if TrialRecord.CurrentTrialNumber == 1
    GRATINGRECORD = [];
end
prespertr = 3;
datafile = MLConfig.FormattedName;
USER = getenv('username'); 
outputFolder = datafile(1:8);
flag_save = 1;

if strcmp(USER,'maierlab') && flag_save == 1
    SAVEPATH = strcat('C:\MLData\',outputFolder);
else
    SAVEPATH = strcat(fileparts(which('T_binocular_gratings.m')),'\','output files');
end

set_bgcolor([0.5 0.5 0.5]);

%% Initial code

timestamp = datestr(now); % Get the current time on the computer

% Set fixation point
fixpt = [0 0]; % [x y] in viual degrees
fixThreshold = 1.75; % degrees of visual angle

% define intervals for WaitThenHold
wait_for_fix = 5000;
initial_fix = 250; % hold fixation for 200ms to initiate trial

% Find screen size
scrsize = Screen.SubjectScreenFullSize / Screen.PixelsPerDegree;  % Screen size [x y] in degrees
setCoord(scrsize); % Send value to a global variable
lower_right = [(scrsize(1)*0.5-0.5) (scrsize(2)*(-0.5)+0.5)];

hotkey('c', 'forced_eye_drift_correction([((-0.25*scrsize(1))+fixpt(1)) fixpt(2)],1);');  % eye1

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
        'grating_varyeye',...
        'grating_oridist',...
        'grating_phzdist',...
        'grating_posdist',...
        'header',...
        'grating_phase',...
        'path',...
        'timestamp');
    
    fclose(fid);
    
    % Textfile # 2 (beta)
    
    filename_2 = strcat(SAVEPATH,'\',datafile,'.g',upper(paradigm),'Grating_di_v2');

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
        'diameter_L',...        % Michelson contrast of grating in the RE
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
end
    

%% Assign values to each sine grating condition
% Set the conditions

path = nan;
grating_tilt = GRATINGRECORD(tr).grating_tilt;
grating_eye = GRATINGRECORD(tr).grating_eye; % 1 = both eyes, 2 = right eye, 3 = left eye
grating_phase = GRATINGRECORD(tr).grating_phase;
grating_sf = GRATINGRECORD(tr).grating_sf;
grating_tf = GRATINGRECORD(tr).grating_tf;
grating_contrast = GRATINGRECORD(tr).grating_contrast; % contrast shown to right eye
grating_diameter = GRATINGRECORD(tr).grating_diameter;
grating_xpos = GRATINGRECORD(tr).grating_xpos(1,:); %
grating_ypos = GRATINGRECORD(tr).grating_ypos(1,:);
other_xpos  = GRATINGRECORD(tr).grating_xpos(2,:);
other_ypos  = GRATINGRECORD(tr).grating_ypos(2,:);
stereo_xpos = GRATINGRECORD(tr).stereo_xpos(1,:); % LEFT eye position
other_stereo_xpos = GRATINGRECORD(tr).stereo_xpos(2,:); % RIGHT eye position
grating_header = GRATINGRECORD(tr).header;
grating_varyeye = GRATINGRECORD(tr).grating_varyeye;
grating_fixedc = GRATINGRECORD(tr).grating_fixedc; % contrast shown to left eye
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
contrast_L = grating_fixedc; contrast_R = grating_contrast;
presOn = [1,1,1]; trialHasBlank = 0; flag_blank = 0;

if strcmp(grating_header,'phzdisparity')
    phase_L = GRATINGRECORD(tr).grating_phase_L;
    phase_R = GRATINGRECORD(tr).grating_phase_R;
    phzdist = phase_L - phase_R;
else
    phzdist = zeros(prespertr,1);
end

if strcmp(grating_header,'posdisparity')
    posdist = GRATINGRECORD(tr).grating_posdist;
else
    posdist = zeros(prespertr,1);
end


%% Conversion from old framework to new framework (save in both frameworks). 
gray = [0.5 0.5 0.5];
gratL_color1 = nan(3,3); gratL_color2 = nan(3,3); % left grating contrast
gratR_color1 = nan(3,3); gratR_color2 = nan(3,3); % right grating contrast

switch grating_header
    case 'phzdisparity' % needs DEV to check
        
        % contrast
        for p = 1:prespertr
            gratL_color1(p,:) = gray + (grating_contrast(p) ./ 2);
            gratL_color2(p,:) = gray - (grating_contrast(p) ./ 2);
            
            gratR_color1(p,:) = gray + (grating_contrast(p) ./ 2);
            gratR_color2(p,:) = gray - (grating_contrast(p) ./ 2);
        end
   
        % orientation
        tilt_L = grating_tilt;
        tilt_R = grating_tilt;
        
    case 'contrastresp' % monocular and dioptic gratings

        % contrast
        for p = 1:prespertr
            if grating_eye(p) == 1 % show to both eyes
                gratL_color1(p,:) = gray + (grating_contrast(p) / 2);
                gratL_color2(p,:) = gray - (grating_contrast(p) / 2);
                
                gratR_color1(p,:) = gray + (grating_contrast(p) / 2);
                gratR_color2(p,:) = gray - (grating_contrast(p) / 2);
                
            elseif grating_eye(p) == 2 % only show to right eye
                
                gratL_color1(p,:) = gray;
                gratL_color2(p,:) = gray;
                
                gratR_color1(p,:) = gray + (grating_contrast(p) / 2);
                gratR_color2(p,:) = gray - (grating_contrast(p) / 2);
                
            elseif grating_eye(p) == 3 % only show to left eye
                
                gratL_color1(p,:) = gray + (grating_contrast(p) / 2);
                gratL_color2(p,:) = gray - (grating_contrast(p) / 2);
                
                gratR_color1(p,:) = gray;
                gratR_color2(p,:) = gray;
                
            end
        end
        
        % orientation
        tilt_L = grating_tilt;
        tilt_R = grating_tilt;
        
        % phase
        phase_L = grating_phase;
        phase_R = grating_phase;
        
    case {'mcosinteroc','bcosinteroc'} % dichoptic (contrast and ori) and monocular gratings
        
        % contrast
        for p = 1:prespertr
            gratL_color1(p,:) = gray + (grating_contrast(p) ./ 2);
            gratL_color2(p,:) = gray - (grating_contrast(p) ./ 2);
            
            gratR_color1(p,:) = gray + (grating_fixedc(p) ./ 2);
            gratR_color2(p,:) = gray - (grating_fixedc(p) ./ 2);
        end
        
        % orientation
        tilt_L = grating_tilt;
        tilt_R = grating_oridist;
        
        % phase
        phase_L = grating_phase;
        phase_R = grating_phase;
        
    case {'bminteroc','cinteroc'}
        
        % contrast
        for p = 1:prespertr
            gratR_color1(p,:) = gray + (grating_contrast(p) ./ 2); % grating_contrast corresponds to RIGHT eye
            gratR_color2(p,:) = gray - (grating_contrast(p) ./ 2);
            
            gratL_color1(p,:) = gray + (grating_fixedc(p) ./ 2); % grating_fixedc corresponds to LEFT eye
            gratL_color2(p,:) = gray - (grating_fixedc(p) ./ 2);
            
            if grating_contrast(p) == 0 && grating_fixedc(p) > 0 % if right eye contrast was 0
                grating_eye(p) = 3; % then the eye was 3 (left)
            elseif grating_fixedc(p) == 0 && grating_contrast(p) > 0 % if the left eye contrast was 0
                grating_eye(p) = 2; % then the eye was 2 (right)
            else
                grating_eye(p) = 1; % otherwise, both eyes received same stimulation (could be blank)
                if grating_contrast(p) == 0 && grating_fixedc(p) == 0
                    flag_blank = true;
                end
            end
        end
        
        % orientation
        tilt_L = grating_tilt;
        tilt_R = grating_tilt;
        
        % phase
        phase_L = grating_phase;
        phase_R = grating_phase;
        
        
    case {'posdisparity'}
        
        % contrast
        for p = 1:prespertr
            gratL_color1(p,:) = gray + (grating_contrast(p) ./ 2);
            gratL_color2(p,:) = gray - (grating_contrast(p) ./ 2);
            
            gratR_color1(p,:) = gray + (grating_contrast(p) ./ 2);
            gratR_color2(p,:) = gray - (grating_contrast(p) ./ 2);
            
            % x-position shift
            if grating_eye(p) == 2
                grating_xpos(p) = grating_xpos(p) + posdist(p);
                stereo_xpos(p) = stereo_xpos(p) + posdist(p);
            elseif grating_eye(p) == 3
                other_xpos(p) = other_xpos(p) + posdist(p);
                other_stereo_xpos(p) = other_stereo_xpos(p) + posdist(p);
            end
            
        end
        
        % orientation
        tilt_L = grating_tilt;
        tilt_R = grating_tilt;
        
        % phase
        phase_L = grating_phase;
        phase_R = grating_phase;
        
end


%% Preallocate grating struct
% GratingList.left = ...
%     {[other_stereo_xpos(1) other_ypos(1)], grating_diameter(1)/2, gratL_tilt(1), grating_sf(1), grating_tf(1), gratL_phase(1), gratL_color1(1), gratL_color2(1), 'circular', []; ...
%     [other_stereo_xpos(2) other_ypos(2)], grating_diameter(2)/2, gratL_tilt(2), grating_sf(2), grating_tf(2), gratL_phase(2), gratL_color1(2), gratL_color2(2), 'circular', [];...
%     [other_stereo_xpos(3) other_ypos(3)], grating_diameter(3)/2, gratL_tilt(3), grating_sf(3), grating_tf(3), gratL_phase(3), gratL_color1(3), gratL_color2(3), 'circular', []};
%     


% GratingList.right = ...
%     {[stereo_xpos(1) grating_ypos(1)], grating_diameter(1)/2, gratR_tilt(1), grating_sf(1), grating_tf(1), gratR_phase(1), gratR_color1(1), gratR_color2(1), 'circular', []; ...
%     [stereo_xpos(2) grating_ypos(2)], grating_diameter(2)/2, gratR_tilt(2), grating_sf(2), grating_tf(2), gratR_phase(2), gratR_color1(2), gratR_color2(2), 'circular', [];...
%     [stereo_xpos(3) grating_ypos(3)], grating_diameter(3)/2, gratR_tilt(3), grating_sf(3), grating_tf(3), gratR_phase(3), gratR_color1(3), gratR_color2(3), 'circular', []};

GratingList.left = ...
    {[stereo_xpos(1) grating_ypos(1)], grating_diameter(1)/2, tilt_L(1), grating_sf(1), grating_tf(1), phase_L(1), gratL_color1(1), gratL_color2(1), 'circular', []; ...
    [stereo_xpos(2) grating_ypos(2)], grating_diameter(2)/2, tilt_L(2), grating_sf(2), grating_tf(2), phase_L(2), gratL_color1(2), gratL_color2(2), 'circular', [];...
    [stereo_xpos(3) grating_ypos(3)], grating_diameter(3)/2, tilt_L(3), grating_sf(3), grating_tf(3), phase_L(3), gratL_color1(3), gratL_color2(3), 'circular', []};
    

GratingList.right = ...
    {[other_stereo_xpos(1) other_ypos(1)], grating_diameter(1)/2, tilt_R(1), grating_sf(1), grating_tf(1), phase_R(1), gratR_color1(1), gratR_color2(1), 'circular', []; ...
    [other_stereo_xpos(2) other_ypos(2)], grating_diameter(2)/2, tilt_R(2), grating_sf(2), grating_tf(2), phase_R(2), gratR_color1(2), gratR_color2(2), 'circular', [];...
    [other_stereo_xpos(3) other_ypos(3)], grating_diameter(3)/2, tilt_R(3), grating_sf(3), grating_tf(3), phase_R(3), gratR_color1(3), gratR_color2(3), 'circular', []};


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

% edit, 5/26/2022 - trying out freeThenHold
% wth1 = WaitThenHold(bck1); % Initialize the wait and hold adapter
% wth1.WaitTime = wait_for_fix; % Set the wait time
% wth1.HoldTime = initial_fix; % Set the hold time
% scene1 = create_scene(wth1); % Initialize the scene adapter

fth1 = FreeThenHold(bck1); % Initialize the wait and hold adapter
fth1.MaxTime = wait_for_fix; % Set the wait time
fth1.HoldTime = initial_fix; % Set the hold time
scene1 = create_scene(fth1); % Initialize the scene adapter


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
grat2.List = {GratingList.left{1,:};GratingList.right{1,:}};
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
wth3.HoldTime = grating_isi;
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
grat4.List =  {GratingList.left{2,:};GratingList.right{2,:}};
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
grat5.List =  {GratingList.left{3,:};GratingList.right{3,:}};
img5 = ImageGraphic(grat5);
img5.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };
wth5 = WaitThenHold(img5);
wth5.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
wth5.HoldTime = grating_stimdur;
scene5 = create_scene(wth5);

%% Scene 6. Clear fixation cross

bck6 = ImageGraphic(null_);
bck6.List = { {'graybackground.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Set the timer
cnt6 = TimeCounter(bck6);
cnt6.Duration = 50;
scene6 = create_scene(cnt6);

%% TASK
error_type = 0;
% run_scene(scene1,[35,11]); % WaitThenHold | 35 = Fix spot on, 11 = Start wait fixation
% if ~wth1.Success             % If the WithThenHold failed (either fixation is not acquired or broken during hold),
%     if wth1.Waiting          %    check whether we were waiting for fixation.
%         error_type = 4;      % If so, fixation was never made and therefore this is a "no fixation (4)" error.
%         run_scene(scene6,[12]);  % blank screen | 12 = end wait fixation
%     else
%         error_type = 3;      % If we were not waiting, it means that fixation was acquired but not held,
%         run_scene(scene6,[97,36]);   % blank screen | 97 = fixation broken, 36 = fix cross OFF
%     end   %    so this is a "break fixation (3)" error.
% else
%     eventmarker(8); % 8 = fixation occurs
% end

% from here, freeThenHold
run_scene(scene1,[35,11]); % FreeThenHold | 35 = Fix spot on, 11 = Start wait fixation
if ~fth1.Success             % If the FreeThenHold failed (either fixation is not acquired or broken during hold),
    if 0==fth1.BreakCount          %    check whether we were waiting for fixation.
        error_type = 4;      % If so, fixation was never made and therefore this is a "no fixation (4)" error.
        run_scene(scene6,[12]);  % blank screen | 12 = end wait fixation
    else
        error_type = 3;      % If we were not waiting, it means that fixation was acquired but not held,
        run_scene(scene6,[97,36]);   % blank screen | 97 = fixation broken, 36 = fix cross OFF
    end   
else
    eventmarker(8); % 8 = fixation occurs
end
% to here

if 0==error_type
    run_scene(scene2,23);    % Run the second scene (eventmarker 23 'taskObject-1 ON')
    if ~fix2.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene6,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
        %eventmarker(24) % 24 = task object 1 OFF 
    end
end

if 0==error_type
    run_scene(scene3,24);    % Run the third scene - This is the blank offset between flashes
    if ~fix3.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene6,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
% %         eventmarker(24) % 24 = task object 1 OFF 
    end
end

if 0==error_type
    run_scene(scene4,25);    % Run the fourth scene (eventmarker 25 - TaskObject - 2 ON) 
    if ~fix4.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene6,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
% %         eventmarker(26) % 26 = task object 2 OFF 
    end
end

if 0==error_type
    run_scene(scene3,26);    % Run the third scene - This is the blank offset between flashes
    if ~fix3.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene6,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
% %         eventmarker(24) % 24 = task object 1 OFF 
    end
end

if 0==error_type
    run_scene(scene5,27);    % Run the fifth scene (eventmarker 27 - TaskObject - 3 ON) 
    if ~fix5.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene6,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
% %         eventmarker(26) % 26 = task object 2 OFF 
    end
end

% reward
if 0==error_type
    run_scene(scene6,[32,36]); % event code for fix cross OFF 
    goodmonkey(100, 'juiceline',1, 'numreward',1, 'pausetime',300, 'eventmarker',96); % 100 ms of juice x 2. Event marker for reward
end


trialerror(error_type);      % Add the result to the trial history

%% Give the monkey a break
set_iti(800); % Inter-trial interval in [ms]

%% Write info to file

filename_1 = strcat(SAVEPATH,'\',datafile,'.g',upper(paradigm),'Grating_di'); % legacy
filename_2 = strcat(SAVEPATH,'\',datafile,'.g',upper(paradigm),'Grating_di_v2'); % 2021 and beyond

if flag_blank == true
    trialHasBlank = 1;
end

for pres = 1:prespertr
    fid = fopen(filename_1, 'a'); % append
    formatSpec =  '%04u\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%u\t%f\t%s\t%f\t%f\t%f\r\n';
    fprintf(fid,formatSpec,...
        TrialRecord.CurrentTrialNumber,...
        grating_xpos(pres),... % horizontal 
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
        grating_varyeye(pres),...
        grating_oridist(pres),...
        phzdist(pres),...
        posdist(pres),...
        grating_header,...
        grating_phase(pres),...
        0,...
        now);
    
    fclose(fid);
    
    
    % Textfile # 2 (beta)
    
    % establish what was shown on screen.
    if contrast_L(pres) == 0 % if grating contrast in LE is zero
        tilt_L(pres) = NaN; phase_L(pres) = NaN; diameter_L(pres) = NaN; 
        sf_L(pres) = NaN; tf_L(pres) = NaN; xpos_L(pres) = NaN; ypos_L(pres) = NaN;
    end
    if contrast_R(pres) == 0 % if grating appears in left eye
        tilt_R(pres) = NaN; phase_R(pres) = NaN; diameter_R(pres) = NaN; 
        sf_R(pres) = NaN; tf_R(pres) = NaN; xpos_R(pres) = NaN; ypos_R(pres) = NaN;
    end
    
    if contrast_L(pres) == 0 && contrast_R(pres) == 0
        presOn(pres) = 0;
    end
    
    
    fid = fopen(filename_2, 'a'); % append
    formatSpec =  '%04u\t%s\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\r\n';
    fprintf(fid,formatSpec,...
        TrialRecord.CurrentTrialNumber,...
        paradigm,...
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

    