%% Aug 2019, Jacob Rogatinsky
% Sept 2021, Edited by Blake Mitchell

%% Initial code
% Get current computer time
timestamp = datestr(now);

% % Event Codes
% bhv_code(8,'Fixation occurs',11,'Start wait fixation',12,'End wait fixation',...
%     23,'TaskObject-1 ON',24,'TaskObject-1 OFF',25,'TaskObject-2 ON',26,'TaskObject-2 OFF',...
%     27,'TaskObject-3 ON',28,'TaskObject-3 OFF',29,'TaskObject-4 ON',30,'TaskObject-4 OFF',...
%     31,'TaskObject-5 ON',32,'TaskObject-5 OFF',33,'TaskObject-6 ON',34,'TaskObject-6 OFF',...
%     35,'Fixation spot ON',36,'Fixation spot OFF',96,'Reward delivered',97,'Broke fixation');  


% Initialize the escape key
hotkey('esc', 'escape_screen(); assignin(''caller'',''continue_'',false);');

% Set the noise patch properties
diameter = [1];                        % Diameter of the grating
de = 3;                                % 1 = binocular, 2 = left eye, 3 = right eye
th = [-60:5:-5];                       % Theta in degrees
e = [2:0.5:6];                         % Eccentricity in degrees
time = [50];                           % Duration of stimulus in [ms]
isi = [200];                           % Duration of inter-stimulus interval in [ms]

% Set the fixation point
fixpt = [0 0]; % [x y] in visual degrees
fix_thresh = 3;

if de == 1
    de_string = 'Binocular';
    nde_string = 'Binocular';
elseif de == 2
    de_string = 'Left';
    nde_string = 'Right';
else
    de_string = 'Right';
    nde_string = 'Left';
end
    
% Find screen size
scrsize = Screen.SubjectScreenFullSize / Screen.PixelsPerDegree;  % Screen size [x y] in degrees
lower_right = [(scrsize(1)*0.5-0.5) (scrsize(2)*(-0.5)+0.5)];

% Trial number increases by 1 for every iteration of the code
trialnum = tnum(TrialRecord);

% Generate the dots
DOTS = makeDots(diameter, Screen.PixelsPerDegree, [0.5 0.5 0.5]);

if trialnum == 1
    % Send seed value to a global variable
    setSeed(randi([1 1000]));
    
    % Generate the background image
    genFixCross((fixpt(1)*Screen.PixelsPerDegree), (fixpt(2)*Screen.PixelsPerDegree));
    
    taskdir = fileparts(which('T_dotmapping.m'));
    fid = fopen(strcat(taskdir,'/','dotmapping.gDotsXY_di'), 'w');    formatSpec =  '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\n';
    fprintf(fid,formatSpec,...
        'Trial Number',...
        'Dots X-Coord',...
        'Dots Y-Coord',...
        'Contrast',...
        'Diameter',...
        'Dominant Eye',...
        'NonDom Eye',...
        'Presentations Per Trial',...
        'Time Stamp',...
        'Inter-Stimulus Interval',...
        'Stimulus Duration',...
        'Fixation X-Coord',...
        'Fixation Y-Coord');
    fclose(fid);
end

% Call the seed number created during the first trial using a separate
% external function -- this way, the seed number only changes when
% Test_Drifting_Grating1 is restarted each iteration within MonkeyLogic
sdnum = getSeed;

%% Struct of pseudo-randomized trial conditions
rng(sdnum) % Set the randomizer seed
r = genDotsParams(th, e); % Call the pseudorandomizer function

% When 'trialnum' exceeds the length of the struct 'r', use
% 'placeholder' to go back to the beginning of the struct
placeholder = (trialnum - 1) * 5;

%% Set the dot patch coordinates
cur_x = []; % preallocate
cur_y = [];

for kk = 1:5
    ph1 = placeholder + kk;
    ph2 = mod(ph1,length(r));
    
    if ph2 == 0
        ph2 = length(r);
    end
    
    if de == 3
        cur_x(end+1)=r(ph2).x + (0.25*scrsize(1)) + fixpt(1);
        cur_y(end+1)=r(ph2).y + fixpt(2);
    elseif de == 2
        cur_x(end+1)=r(ph2).x - (0.25*scrsize(1)) + fixpt(1);
        cur_y(end+1)=r(ph2).y + fixpt(2);
    end
    
end

%% Scene 0. Blank screen

bck0 = ImageGraphic(null_);
bck0.List = { {'graybackground.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

% Set the timer
cnt0 = TimeCounter(bck0);
cnt0.Duration = 250;
scene0 = create_scene(cnt0);

%% Scene 1. Fixation

% Set fixation to the left eye for tracking
fix1 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix1.Target = [(-0.25*scrsize(1))+fixpt(1) fixpt(2)]; % Set the fixation point
fix1.Threshold = fix_thresh; % Set the fixation threshold

bck1 = ImageGraphic(fix1);
bck1.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

wth1 = WaitThenHold(bck1); % Initialize the wait and hold adapter
wth1.WaitTime = 5000; % Set the wait time
wth1.HoldTime = 250; % Set the hold time

scene1 = create_scene(wth1); % Initialize the scene adapter
run_scene(scene1,[35,11]); % Run scene

error_type = 0;
if ~wth1.Success             % If the WithThenHold failed (either fixation is not acquired or broken during hold),
    if wth1.Waiting          %    check whether we were waiting for fixation.
        error_type = 1; 
        run_scene(scene0,[97,36]); 
    else
        error_type = 2;      % If we were not waiting, it means that fixation was acquired but not held,
        run_scene(scene0,[97,36]);
    end                      %    so this is a "break fixation (3)" error.
else
    eventmarker(8);         % 8 = fixation occurs
end

%% Scene 2. Dot patches
% list of objects
obj = [23,24,25,26,27,28,29,30,31];
if wth1.Success % If fixation was acquired and held
    
    for ii = 1:9
        
        real_ind = (ii+1)/2;
        
        if mod(ii,2) == 1 % this function is basically saying every odd number of ii
            
            fix2 = SingleTarget(eye_); % Initialize the eye tracking adapter
            fix2.Target = [(-0.25*scrsize(1))+fixpt(1) fixpt(2)]; % Set the fixation point
            fix2.Threshold = fix_thresh; % Set the fixation threshold
            
            pd = BoxGraphic(fix2);
            pd.EdgeColor = [1 1 1];
            pd.FaceColor = [1 1 1];
            pd.Size = [3 3];
            pd.Position = lower_right;
            
            % Display patch
            img2 = ImageGraphic(pd);
            img2.List = { {DOTS}, [cur_x(real_ind) cur_y(real_ind)] };
            img2.EventMarker = obj(ii);
            
            % Set the timer
            cnt2 = TimeCounter(img2);
            cnt2.Duration = time;
            
            bck2 = ImageGraphic(cnt2);
            bck2.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };
            
            % Run the scene
            scene2 = create_scene(bck2);
            run_scene(scene2,obj(ii));
            if ~fix2.Success         % The failure of WthThenHold indicates that the subject didn't maintain fixation on the sample image.
                error_type = 3;      % So it is a "break fixation (3)" error.
                run_scene(scene0,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
                break
            end
            
        else % blank scenes interwoven
            fix2 = SingleTarget(eye_); % Initialize the eye tracking adapter
            fix2.Target = [(-0.25*scrsize(1))+fixpt(1) fixpt(2)]; % Set the fixation point
            fix2.Threshold = fix_thresh; % Set the fixation threshold
           
            bck2 = ImageGraphic(fix2);
            bck2.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };
            
            % Set the timer
            cnt2 = TimeCounter(bck2);
            cnt2.Duration = isi;
            
            % Run the scene
            scene2 = create_scene(cnt2);
            run_scene(scene2,obj(ii));
            if ~fix2.Success         % The failure of WthThenHold indicates that the subject didn't maintain fixation on the sample image.
                error_type = 3;      % So it is a "break fixation (3)" error.
                run_scene(scene0,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
                break
            end
        end
        
    end
    
end

if error_type == 0
    run_scene(scene0,36); 
    goodmonkey(100, 'NonBlocking',1,'juiceline',1, 'numreward',2, 'pausetime',500, 'eventmarker',96); % 100 ms of juice x 2
end

trialerror(error_type); 


%% Write info to file

taskdir = fileparts(which('T_dotmapping.m'));
fid = fopen(strcat(taskdir,'/','dotmapping.gDotsXY_di'), 'a'); % Write to a text file
formatSpec =  '%f\t%s\t%s\t%f\t%f\t%s\t%s\t%f\t%s\t%f\t%f\t%f\t%f\t\n';
fprintf(fid,formatSpec,...
    trialnum,...
    num2str(cur_x),...
    num2str(cur_y),...
    1,...
    diameter,...
    de_string,...
    nde_string,...
    5,...
    timestamp,...
    isi,...
    time,...
    ((-0.25*scrsize(1))+fixpt(1)),...
    fixpt(2));
    
fclose(fid);

%% Give the monkey a break
set_iti(800); % Inter-trial interval in [ms]

%%