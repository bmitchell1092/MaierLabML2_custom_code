%% Aug 2019, Jacob Rogatinsky
% Sept 2021, Edited by Blake Mitchell

% Initialize the escape key
hotkey('esc', 'escape_screen(); assignin(''caller'',''continue_'',false);');

global SAVEPATH DOTRECORD prespertr datafile
DOTRECORD = [];

datafile = MLConfig.FormattedName;
USER = getenv('username');

if strcmp(USER,'maierlab')
    SAVEPATH = 'C:\MLData\temp';
else
    SAVEPATH = fileparts(which('T_tuning.m'));
end

%% Initial code
% Get current computer time
timestamp = datestr(now);

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
    
    fid = fopen(filename, 'w');
    % header:
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
end

% Call the seed number created during the first trial using a separate
% external function -- this way, the seed number only changes when
% Test_Drifting_Grating1 is restarted each iteration within MonkeyLogic
sdnum = getSeed;

%% Struct of pseudo-randomized trial conditions
tr    = TrialRecord.CurrentTrialNumber;
dot_contrast          = DOTRECORD(tr).dot_contrast;
dot_x                 = DOTRECORD(tr).dot_xpos;
dot_y                 = DOTRECORD(tr).dot_ypos;
dot_eye               = DOTRECORD(tr).dot_eye;

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
grat2.List = {preAllocatedGratingList.left{1,:};preAllocatedGratingList.right{1,:}};
img2 = ImageGraphic(grat2);
img2.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };
wth2 = WaitThenHold(img2);
wth2.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
wth2.HoldTime = 250;
scene2 = create_scene(wth2);




%% Give the monkey a break
set_iti(800); % Inter-trial interval in [ms]

%% Write info to file

filename = strcat(SAVEPATH,'\',datafile,'.g',upper(paradigm),'Grating_di');

for pres = 1:prespertr
    fid = fopen(filename, 'a');  % append
    
    formatSpec =  '%04u\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\r\n';
    fprintf(fid,formatSpec,...
        tr,...
        X,...
        Y(pres),...
        dot_x(pres),...
        dot_y(pres),...
        dot_eye(pres),...
        dot_diameter(pres),...
        dot_contrast(pres),...
        FIX_X,...
        FIX_Y,...
        now);
    
    fclose(fid);
end
