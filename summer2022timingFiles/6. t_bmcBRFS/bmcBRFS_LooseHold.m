%% bmcBRFS September/October 2021
% BRFS with full history and balanced eye conditions

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
    SAVEPATH = strcat(fileparts(which('bmcBRFS.m')),filesep,'output files');
end

scrsize = Screen.SubjectScreenFullSize / Screen.PixelsPerDegree;  % Screen size [x y] in degrees
lower_right = [(scrsize(1)*0.5-0.5) (scrsize(2)*(-0.5)+0.5)];

% Set the fixation point
fixpt = [0 0]; % [x y] in visual degrees

hotkey('c', 'forced_eye_drift_correction([((-0.25*scrsize(1))+fixpt(1)) fixpt(2)],1);');  % eye1


%% Set the constant conditions
% de = 3;                                 % Dominant eye: 1 = binocular, 2 = right eye, 3 = left eye
% Set receptive field
rf = [4 -4];  % [x y] in visual degrees
setRF(rf);
diameter = [1.5];                         % Diameter of the grating
fixThreshold = 1;
PrefOri = [90];                         % Preferred orientation of grating
sf = [1];                               % Cycles per degree
tf = [0];                               % Cycles per second (0=static, 4=drifting)
left_xloc = (-0.25*scrsize(1))+rf(1);   % Left eye x-coordinate
right_xloc = (0.25*scrsize(1))+rf(1);   % Right eye x-coordinate                   % Grating color 2
phase_angle = [0];                      % Phase angle in degrees (0-360)

% define time intervals (in ms):
wait_for_fix = 5000;
initial_fix = 250;
looseBreakTime = 50;
timeOutTime = 5000;

set_bgcolor([0.5 0.5 0.5]);

%% Trial 1 initilization
  
% Trial number increases by 1 for every iteration of the code
tr = tnum(TrialRecord);
paradigm = 'bmcBRFS';



if tr == 1 % on the first trial
     setSeed(randi([1 1000])); % Send seed value to a global variable
    genFixCross((fixpt(1)*Screen.PixelsPerDegree), (fixpt(2)*Screen.PixelsPerDegree));

    
    
    % generate fixation cross location
    genFixCross((fixpt(1)*Screen.PixelsPerDegree), (fixpt(2)*Screen.PixelsPerDegree));
    
    % Create a file to write grating information for each trial

    filename = strcat(SAVEPATH,filesep,datafile,'.g',upper(paradigm),'Grating_di');
    
    fid = fopen(filename, 'w');
    formatSpec =  '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n';
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
        'gaborfilter_on',...
        'gabor_std',...
        'header',...
        'grating_phase',...
        'bmcBRFSparamNum',...
        'path',...
        'timestamp');
    
    fclose(fid);
    
end
% Call the seed number created during the first trial using a separate
% external function -- this way, the seed number only changes when
% Test_Drifting_Grating1 is restarted each iteration within MonkeyLogic
sdnum = getSeed;


%% Struct of pseudo-randomized trial conditions
% If it's the first trial
if tr < 2
    rng(sdnum) % Set the randomizer seed
    r = genBmcBRFSParams(); % Call the pseudorandomizer function
    
% If it's not the first trial
else
    rng(sdnum) % Set the randomizer seed
    r = genBmcBRFSParams(); % Call the pseudorandomizer function
    
    % When 'tr' exceeds the length of the struct 'r', use
    % 'placeholder' to go back to the beginning of the struct
    placeholder = mod(tr,length(r));
    if placeholder == 0
        placeholder = length(r);
    end
    
    % Cycle through each row within the struct's fields
    r(end+1:end+placeholder-1) = r(1:placeholder-1);
    r(1:placeholder-1)=[];
    
end

%% BRFS paradigm and controlls
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% 1. What is consistant on every trial?%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Setting contrast. This applies to both gratings. 
grayColor = [.5 .5 .5];
grating_contrast = .5;

color1 = grayColor + (grating_contrast / 2);   % 0.25 deviance below mean
color2 = grayColor - (grating_contrast/ 2);   % 0.25 deviance above mean
                            % = 0.5 Michelson contrast 
                           



        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%% 2. What changes on every trial?%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grating a and b eye, Random assignemnt. first grating refers to the first monoc adapting(or left eye for simultaneous condition)
% 2 = right, 3 = left
if any(r(1).stim_code == [1 2 3 4 6 8 10 12 14 16 18 20])
    firstGrat = 3;
elseif any(r(1).stim_code == [5 7 9 11 13 15 17 19])
    firstGrat = 2;
end

if firstGrat == 3
    grat1a_loc = left_xloc;
    grat1b_loc = right_xloc;
    grat1a_string = 'Left';
    grat1b_string = 'Right';    
elseif firstGrat == 2
    grat1a_loc = right_xloc;
    grat1b_loc = left_xloc;
    grat1a_string = 'Right';
    grat1b_string = 'Left';  
end

bhv_variable('grat1a_positionString', grat1a_string, 'grat1b_positionString', grat1b_string);

% Orientation
if any(r(1).stim_code == [1 5 8 13 16])     %congruent PrefOri
    grat1a_ori = PrefOri;
    grat1b_ori = PrefOri; 
elseif any(r(1).stim_code == [2 6 7 14 15])            %congruent Non preferred Ori
    grat1a_ori = PrefOri + 90;
    grat1b_ori = PrefOri + 90;
elseif any(r(1).stim_code == [3])            %Incongruent simult PO LeftEye - NPO RightEye
    grat1a_ori = PrefOri;
    grat1b_ori = PrefOri + 90;
elseif any(r(1).stim_code == [4])            %Incongruent simult NPO LeftEye - PO RightEye
    grat1a_ori = PrefOri +90;
    grat1b_ori = PrefOri;
elseif any(r(1).stim_code == [10 11 18 19])            %Incongruent adapted PO adapted
    grat1a_ori = PrefOri;
    grat1b_ori = PrefOri + 90;
elseif any(r(1).stim_code == [9 12 17 20])            %Incongruent adapted NPO adapted
    grat1a_ori = PrefOri + 90; 
    grat1b_ori = PrefOri;
end


bhv_variable('grat1a_ori', grat1a_ori, 'grat1b_ori', grat1b_ori);

%Simultaneous == 1, adapted and then flashed == 2, or monocular alternation == 3?
if any(r(1).stim_code == [1 2 3 4]) 
    timeCode = 1; % Simultaneous
    timeString = 'Simultaneous';
    preAllocatedGratingList = ...
        {[grat1a_loc rf(2)], diameter/2, grat1a_ori, sf, tf, phase_angle, color1, color2, 'circular', []; ...
         [grat1b_loc rf(2)], diameter/2, grat1b_ori, sf, tf, phase_angle, color1, color2, 'circular', [];...
         [grat1a_loc rf(2)], diameter/2, grat1a_ori, sf, tf, phase_angle, color1, color2, 'circular', []; ...
         [grat1b_loc rf(2)], diameter/2, grat1b_ori, sf, tf, phase_angle, color1, color2, 'circular', []};    
elseif any(r(1).stim_code == [5 6 7 8 9 10 11 12]) 
    timeCode = 2; % BRFS-like congruent adapted or BRFS
    timeString = 'BRFS or BRFS-like';
    preAllocatedGratingList = ...
        {[grat1a_loc rf(2)], diameter/2, grat1a_ori, sf, tf, phase_angle, color1, color2, 'circular', []; ...
         [grat1b_loc rf(2)], 0,          grat1b_ori, sf, tf, phase_angle, color1, color2, 'circular', [];...
         [grat1a_loc rf(2)], diameter/2, grat1a_ori, sf, tf, phase_angle, color1, color2, 'circular', []; ...
         [grat1b_loc rf(2)], diameter/2, grat1b_ori, sf, tf, phase_angle, color1, color2, 'circular', []};    
elseif any(r(1).stim_code == [13 14 15 16 17 18 19 20]) 
    timeCode = 3; % Monocular alternation
    timeString = 'Monoc Alt';
    preAllocatedGratingList = ...
        {[grat1a_loc rf(2)], diameter/2, grat1a_ori, sf, tf, phase_angle, color1, color2, 'circular', []; ...
         [grat1b_loc rf(2)], 0,          grat1b_ori, sf, tf, phase_angle, color1, color2, 'circular', [];...
         [grat1a_loc rf(2)], 0,          grat1a_ori, sf, tf, phase_angle, color1, color2, 'circular', []; ...
         [grat1b_loc rf(2)], diameter/2, grat1b_ori, sf, tf, phase_angle, color1, color2, 'circular', []};
end

bhv_variable('timeCode', timeCode, 'timeString', timeString);


%% Set up variables into file format

stereo_xpos = left_xloc; 
grating_ypos =  rf(2);  
grating_xpos =  rf(1);
% grating_ypos =   rf(2);
other_xpos = right_xloc;
other_ypos =  rf(2);
grating_tilt =  PrefOri;
grating_sf =  [1] ;
grating_contrast = grating_contrast ;
grating_fixedc =  grating_contrast;
grating_diameter =  diameter;
grating_eye = NaN ;
grating_varyeye =  NaN;
grating_oridist = PrefOri + 90 ;
% % % 0,...
% % % 0,...
grating_header = 'bmcBRFS';
grating_phase =  phase_angle;
bmcBRFSparamNum = r(1).stim_code;
% % 0,...
% % now);

%% Trial sequence event markers
% send some event markers
eventmarker(116 + TrialRecord.CurrentBlock); %block first
eventmarker(116 + TrialRecord.CurrentCondition); %condition second
eventmarker(116 + mod(TrialRecord.CurrentTrialNumber,10)); %last diget of trial sent third

%% Scene 1 - fixation

    % Set fixation to the left eye for tracking
    fix1 = SingleTarget(eye_); % Initialize the eye tracking adapter
    fix1.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
    fix1.Threshold = fixThreshold; % Set the fixation threshold

    % Set the background image
    bck1 = ImageGraphic(fix1);
    bck1.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };
   
    % Wait for fixation (FreeThenHold) - BM, 5/31/2022
    fth1 = FreeThenHold(bck1); % Initialize the wait and hold adapter
    fth1.MaxTime = wait_for_fix; % Set the wait time
    fth1.HoldTime = initial_fix; % Set the hold time
    scene1 = create_scene(fth1); % Initialize the scene adapter

%% Scene 2 - First 750ms

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
    grat2.List = preAllocatedGratingList(1:2,:);
    
    bck2 = ImageGraphic(grat2);
    bck2.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };    
    
    lh2 = LooseHold(bck2);
    lh2.HoldTime = 750;
    lh2.BreakTime = looseBreakTime;
    
    scene2 = create_scene(lh2);

%% Scene 3 - 750-800ms (photo diode offset

    % Set fixation to the left eye for tracking
    fix3 = SingleTarget(eye_); % Initialize the eye tracking adapter
    fix3.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
    fix3.Threshold = fixThreshold; % Set the fixation threshold
    
    pd3 = BoxGraphic(fix3);
    pd3.EdgeColor = [0 0 0];
    pd3.FaceColor = [0 0 0];
    pd3.Size = [3 3];
    pd3.Position = lower_right;
    
    % Create both gratings
    grat3 = SineGrating(pd3);
    grat3.List = preAllocatedGratingList(1:2,:);
    
    bck3 = ImageGraphic(grat3);
    bck3.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };    
    
    lh3 = LooseHold(bck3);
    lh3.HoldTime = 50;
    lh3.BreakTime = looseBreakTime;
    
    scene3 = create_scene(lh3);

%% Scene 4 - last 800 ms

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
    grat4.List = preAllocatedGratingList(3:4,:);
    
    bck4 = ImageGraphic(grat4);
    bck4.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };    
    
    lh4 = LooseHold(bck4);
    lh4.HoldTime = 800;
    lh4.BreakTime = looseBreakTime;
    
    scene4 = create_scene(lh4);
 
%% Scene 5. Break Fixation - negative punishment 
% Negative punishment suppresses unwanted behavior by removing a
% reward-conditioned stimulus (aka - time-out)

bck5 = ImageGraphic(null_);
bck5.List = { {'graybackground.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Set the timer
cnt5 = TimeCounter(bck5);
cnt5.Duration = timeOutTime;
scene5 = create_scene(cnt5);

%% Scene 6. Clear fixation cross - in case of goodmonkey

bck6 = ImageGraphic(null_);
bck6.List = { {'graybackground.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Set the timer
cnt6 = TimeCounter(bck6);
cnt6.Duration = 50;
scene6 = create_scene(cnt6);
    
%% TASK
error_type = 0;
% from here, freeThenHold, - BM, 5/31/2022
run_scene(scene1,[35,11]); % FreeThenHold | 35 = Fix spot on, 11 = Start wait fixation
if ~fth1.Success             % If the FreeThenHold failed (either fixation is not acquired or broken during hold),
    if 0==fth1.BreakCount          %    check whether we were waiting for fixation.
        error_type = 4;      % If so, fixation was never made and therefore this is a "no fixation (4)" error.
        run_scene(scene5,[12]);  % blank screen | 12 = end wait fixation
    else
        error_type = 3;      % If we were not waiting, it means that fixation was acquired but not held,
        run_scene(scene5,[97,36]);   % blank screen | 97 = fixation broken, 36 = fix cross OFF
    end   
else
    eventmarker(8); % 8 = fixation occurs
end
% to here, - BM, 5/31/2022

if 0==error_type
    run_scene(scene2,23);    % Run the second scene (eventmarker 23 'taskObject-1 ON')
    if ~fix2.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene5,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
        eventmarker(24) % 24 = task object 1 OFF 
    end
end

if 0==error_type
    run_scene(scene3,13);    % Run the third scene (eventmarker 13 - photo diode blink) 
    if ~fix3.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene5,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
        eventmarker(24) % 24 = task object 1 OFF 
    end
end

if 0==error_type
    run_scene(scene4,25);    % Run the fourth scene (eventmarker 25 - TaskObject - 2 ON) 
    if ~fix4.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene5,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
        eventmarker(26) % 26 = task object 2 OFF 
    end
end

% reward
if 0==error_type
    run_scene(scene6,[36]); % event code for fix cross OFF 
    goodmonkey(100, 'juiceline',1, 'numreward',1, 'pausetime',500, 'eventmarker',96); % 100 ms of juice x 2. 96 - Event marker for reward
end

trialerror(error_type);      % Add the result to the trial history

%% Write info to file

filename = strcat(SAVEPATH,'\',datafile,'.g',upper(paradigm),'Grating_di');
    
fid = fopen(filename, 'a'); % append
formatSpec =  '%04u\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%s\t%f\t%f\t%f\t%f\r\n';
fprintf(fid,formatSpec,...
    TrialRecord.CurrentTrialNumber,...
    stereo_xpos,... % needs verification
    grating_ypos,...  % needs verification 
    grating_xpos,...
    grating_ypos,...
    other_xpos,...
    other_ypos,...
    grating_tilt,...
    grating_sf,...
    grating_contrast,...
    grating_fixedc,...
    grating_diameter,...
    grating_eye,...
    grating_varyeye,...
    grating_oridist,...
    0,...
    0,...
    grating_header,...
    grating_phase,...
    bmcBRFSparamNum,...
    0,...
    now);

fclose(fid);

%% Give the monkey a break
set_iti(500); % Inter-trial interval in [ms]
