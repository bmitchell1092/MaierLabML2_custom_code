% Initialize the escape key
hotkey('esc', 'escape_screen(); assignin(''caller'',''continue_'',false);');
% % % % bhv_code(8,'Fixation occurs',11,'Start wait fixation',12,'End wait fixation',...
% % % %     15,'Photo diode blink',...
% % % %     23,'TaskObject-1 ON',24,'TaskObject-1 OFF',25,'TaskObject-2 ON',26,'TaskObject-2 OFF',...
% % % %     27,'TaskObject-3 ON',28,'TaskObject-3 OFF',29,'TaskObject-4 ON',30,'TaskObject-4 OFF',...
% % % %     31,'TaskObject-5 ON',32,'TaskObject-5 OFF',33,'TaskObject-6 ON',34,'TaskObject-6 OFF',...
% % % %     35,'Fixation spot ON',36,'Fixation spot OFF',96,'Reward delivered',97,'Broke fixation');  

scrsize = Screen.SubjectScreenFullSize / Screen.PixelsPerDegree;  % Screen size [x y] in degrees
lower_right = [(scrsize(1)*0.5-0.5) (scrsize(2)*(-0.5)+0.5)];

% Set receptive field
rf = [3 -3]; % [x y] in visual degrees
setRF(rf);

% Set the fixation point
fixpt = [0 0]; % [x y] in visual degrees

% Set the constant conditions
% de = 3;                                 % Dominant eye: 1 = binocular, 2 = right eye, 3 = left eye
fixTreshold = 3;
PrefOri = [0];                              % Preferred orientation of grating
sf = [1];                               % Cycles per degree
tf = [0];                               % Cycles per second (0=static, 4=drifting)
diameter = [3];                         % Diameter of the grating
left_xloc = (-0.25*scrsize(1))+rf(1);   % Left eye x-coordinate
right_xloc = (0.25*scrsize(1))+rf(1);   % Right eye x-coordinate                   % Grating color 2
phase_angle = [0];                      % Phase angle in degrees (0-360)

% define time intervals (in ms):
wait_for_fix = 3000;
initial_fix = 250;

set_bgcolor([0.5 0.5 0.5]);

%% Trial 1 initilization
                          
% Trial number increases by 1 for every iteration of the code
trialnum = tnum(TrialRecord);

if trialnum == 1
    setSeed(randi([1 1000])); % Send seed value to a global variable

    genFixCross((fixpt(1)*Screen.PixelsPerDegree), (fixpt(2)*Screen.PixelsPerDegree));

    dir = fileparts(which('BRFS_BMC_2021_sceneFramework.m'));
    fid = fopen(strcat(dir,filesep,'BRFS_BMC_',date,'.gBRFS'), 'w'); % Write to a text file
    formatSpec =  '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\n';
    fprintf(fid,formatSpec,...
        'Trial Number',...
        'RF X-Coord',...
        'RF Y-Coord',...
        'Grating Tilt',...
        'Spatial Frequency',...
        'Temporal Frequency',...
        'color 1 for contrast',...
        'color 2 for contrast',...
        'Diameter',...
        'Time Stamp',...
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
    r = genBmcBRFSParams(); % Call the pseudorandomizer function
    
% If it's not the first trial
else
    rng(sdnum) % Set the randomizer seed
    r = genBmcBRFSParams(); % Call the pseudorandomizer function
    
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

%% BRFS paradigm and controlls
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% 1. What is consistant on every trial?%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Setting contrast. This applies to both gratings. 
color1 = [0.25, 0.25, 0.25];   % 0.25 deviance below mean
color2 = [0.75, 0.75, 0.75];   % 0.25 deviance above mean
                            % = 0.4 Michelson contrast 
                           



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


%% Scene 2 - First 750ms

    % Set fixation to the left eye for tracking
    fix2 = SingleTarget(eye_); % Initialize the eye tracking adapter
    fix2.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
    fix2.Threshold = fixTreshold; % Set the fixation threshold
    
    pd2 = BoxGraphic(fix2);
    pd2.EdgeColor = [1 1 1];
    pd2.FaceColor = [1 1 1];
    pd2.Size = [3 3];
    pd2.Position = lower_right;
    
    % Create both gratings
    grat2 = SineGrating(pd2);
    grat2.List = preAllocatedGratingList(1:2,:);
    img2 = ImageGraphic(grat2);
    img2.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };    
    wth2 = WaitThenHold(img2);
    wth2.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
    wth2.HoldTime = 750;
    scene2 = create_scene(wth2);


%% Scene 3 - 750-800ms (photo diode offset

    % Set fixation to the left eye for tracking
    fix3 = SingleTarget(eye_); % Initialize the eye tracking adapter
    fix3.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
    fix3.Threshold = fixTreshold; % Set the fixation threshold
    
    pd3 = BoxGraphic(fix3);
    pd3.EdgeColor = [0 0 0];
    pd3.FaceColor = [0 0 0];
    pd3.Size = [3 3];
    pd3.Position = lower_right;
    
    % Create both gratings
    grat3 = SineGrating(pd3);
    grat3.List = preAllocatedGratingList(1:2,:);
    img3 = ImageGraphic(grat3);
    img3.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };    
    wth3 = WaitThenHold(img3);
    wth3.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
    wth3.HoldTime = 50;
    scene3 = create_scene(wth3);

%% Scene 4 - last 800 ms

    % Set fixation to the left eye for tracking
    fix4 = SingleTarget(eye_); % Initialize the eye tracking adapter
    fix4.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
    fix4.Threshold = fixTreshold; % Set the fixation threshold
    
    pd4 = BoxGraphic(fix4);
    pd4.EdgeColor = [1 1 1];
    pd4.FaceColor = [1 1 1];
    pd4.Size = [3 3];
    pd4.Position = lower_right;
    
    % Create both gratings
    grat4 = SineGrating(pd4);
    grat4.List = preAllocatedGratingList(3:4,:);
    img4 = ImageGraphic(grat4);
    img4.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };    
    wth4 = WaitThenHold(img4);
    wth4.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
    wth4.HoldTime = 800;
    scene4 = create_scene(wth4);
 

%% Scene 5: Cleared screen
    bck5 = ImageGraphic(null_);
    bck5.List = { {'graybackground.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

    % Set the timer
    cnt5 = TimeCounter(bck5);
    cnt5.Duration = 250;
    scene5 = create_scene(cnt5);

    
%% TASK
error_type = 0;
run_scene(scene1,[35,11]); % WaitThenHold | 35 = Fix spot on, 11 = Start wait fixation
if ~wth1.Success             % If the WithThenHold failed (either fixation is not acquired or broken during hold),
    if wth1.Waiting          %    check whether we were waiting for fixation.
        error_type = 4;      % If so, fixation was never made and therefore this is a "no fixation (4)" error.
        run_scene(scene5,[12]);  % blank screen | 12 = end wait fixation
    else
        error_type = 3;      % If we were not waiting, it means that fixation was acquired but not held,
        run_scene(scene5,[97,36]);   % blank screen | 97 = fixation broken, 36 = fix cross OFF
    end   %    so this is a "break fixation (3)" error.
else
    eventmarker(8); % 8 = fixation occurs
end

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
    run_scene(scene3,15);    % Run the third scene (eventmarker 15 - photo diode blink) 
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
    run_scene(scene5,[36]); % event code for fix cross OFF 
    goodmonkey(100, 'juiceline',1, 'numreward',1, 'pausetime',500, 'eventmarker',50); % 100 ms of juice x 2. Event marker for reward
end

trialerror(error_type);      % Add the result to the trial history

%% Write info to file

timestamp = datetime('now');

dir = fileparts(which('BRFS_BMC_2021_sceneFramework.m'));
fid = fopen(strcat(dir,filesep,'BRFS_BMC_',date,'.gBRFS'), 'a');
formatSpec =  '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%s\t%s\t%f\t%s\t%f\t%s\t%f\t%f\t%f\t\n';
fprintf(fid,formatSpec,...
    trialnum,...
    rf,...
    rf(2),...
    PrefOri,...
    sf,...
    tf,...
    color1,...
    color2,...
    diameter,...
    timestamp,...
    ((-0.25*scrsize(1))+fixpt(1)),...
    fixpt(2));
    
fclose(fid);
%% Give the monkey a break
set_iti(500); % Inter-trial interval in [ms]
