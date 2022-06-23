%%Loic Daumail - 09-09-2021
global SAVEPATH LINESEGRECORD datafile
if TrialRecord.CurrentTrialNumber == 1
    LINESEGRECORD = [];
end

datafile = MLConfig.FormattedName;
USER = getenv('username');
outputFolder = datafile(1:8);
flag_save = 1;

if strcmp(USER,'maierlab') && flag_save == 1
     SAVEPATH = strcat('C:\MLData\',outputFolder);
else
    SAVEPATH = strcat(fileparts(which('T_saliencyVaryBg.m')),'\','output_files');
end

%% Initial code

set_bgcolor([0.5 0.5 0.5]);

% Paradigm selection
pdgm = 'squareLowBG'; %update 11/2/2021

timestamp = datestr(now); % Get the current time on the computer

% Find screen size
scrsize = Screen.SubjectScreenFullSize / Screen.PixelsPerDegree;  % Screen size [x y] in degrees
% Set receptive field
rf = [3 -3]; % [x y] in visual degrees
setRF(rf);
% Set the constant conditions
screenCenter = [0,0];
linedensity = 11; %11 lines per square degree of visual angle
viewdist = 60;
diameter = [asind(150*0.252/(10*viewdist))];  % Diameter of the figure
time = [1700];                          % Duration of trial in [ms]
left_xloc = (-0.25*scrsize(1))+rf(1);         % Left eye x-coordinate
right_xloc = (0.25*scrsize(1))+rf(1);         % Right eye x-coordinate
%phase_angle = [0];                      % Phase angle in degrees (0-360)
% Trial number increases by 1 for every iteration of the code
tr = tnum(TrialRecord);
filename = fullfile(SAVEPATH,sprintf('%s.lineSeg%s_di',datafile,pdgm));

if tr == 1
    setSeed(randi([1 1000])); % Send seed value to a global variable
    sdnum = getSeed;
    genLineSegRecordML2_2(pdgm, TrialRecord);

    fid = fopen(filename, 'w');
    %fid = fopen(strcat('C:\Users\daumail\OneDrive - Vanderbilt\Documents\loic_code_042021\saliency_learning_study\ML_task\simple_task\',sprintf('RANDLINESEG%s',pdgm)), 'w'); % Write to a text file
    formatSpec =  '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\n';
    fprintf(fid,formatSpec,...
        'Trial Number',...
        'Line Density',...
        'Ground Tilt',...
        'Fig Tilt',...
        'Line Length',...
        'Figure Abcissa',...
        'Figure Ordinate',...
        'Figure Contrast',...
        'Ground Contrast',...
        'Figure Diameter',...
        'Paradigm',...
        'Time Stamp',...
        'Flash Delay',...
        'Fixation X-Coord',...
        'Fixation Y-Coord');
    fclose(fid);
    
elseif size(LINESEGRECORD,2) < tr
    %GENERATE NEW GRATING RECORD IF THIS TRIAL IS LONGER THAN CURRENT GRATINGRECORD
    genLineSegRecordML2(pdgm,TrialRecord);
end


%% Set all conditions necessary for each paradigm

% Pull the conditions from genGaussSwirlParams
linelen = LINESEGRECORD(tr).linelen; 
stim_code = LINESEGRECORD(tr).cond_code; % Orientation code(1 to 16)
stim_loc = LINESEGRECORD(tr).location;
stim_ori = LINESEGRECORD(tr).ori;
stim_cont = LINESEGRECORD(tr).cont;

%for loading the images
fig_xloc = stim_loc(1);
fig_yloc = stim_loc(2);
%for saving the figure location in degrees
fig_xloc_d = stim_loc(1)*scrsize(1)/1920;
fig_yloc_d = stim_loc(2)*scrsize(2)/1080;

bg_ori = stim_ori(1);
fig_ori = stim_ori(2);
%possible screen locations 
%centers of left and right sides of stereoscope 
center_right =  [(0.25*scrsize(1)+screenCenter(1)) screenCenter(2)];
center_left =  [((-0.25*scrsize(1))+screenCenter(1)) screenCenter(2)];
lower_right = [(scrsize(1)*0.5-0.5) (scrsize(2)*(-0.5)+0.5)];
upper_left = [(scrsize(1)*(-0.5)-0.5) (scrsize(2)*(0.5)+0.5)];
%{
% Pull the asynchrony duration from genDiopticParams if applicable
% %unnecessary for now but keep as it has no impact on the code
if strcmp(pdgm,'asynch_de2nde') || strcmp(pdgm, 'asynch_nde2de') || strcmp(pdgm, 'custom')
    asynch = r(1).asynch;
end
%}

% Set the location of all the stimuli
switch stim_code % 
    
    case 1 %'squareLowBG'
        bg_cont = stim_cont(1);
        fig_cont = stim_cont(2);
        fix_radius = 4;
        reward = 0; 
        % Set the trigger delay
        trig_delay = 0;
        %fixation point adapter
        crc = CircleGraphic(null_);
        crc.List = { [], [], 0.3,center_left ;  [], [], 0.3, center_right;};
        prestimDir = strcat(fileparts(which('T_saliency.m')),'\','line_stims\backgrounds','\','white_background.png');
        stimDir = strcat(fileparts(which('T_saliency.m')),'\','line_stims\squareFigs_varyBg_cont2000','\',sprintf('gori%d_fori%d_figcont%d_bgcont%d_len%d_xlocation%d_ylocation%d.png',bg_ori, fig_ori, fig_cont,bg_cont, linelen,fig_xloc,fig_yloc));
   
end

%% Monkey Logic 2.2 code
%initialize escape key
hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);');
% detect an available tracker
if exist('eye_','var'), tracker = eye_;
    elseif exist('eye2_','var'), tracker = eye2_;
    else, error('This demo requires eye input. Please set it up or turn on the simulation mode.');
end

%fixation point
fixation_point = [((-0.25*scrsize(1))+screenCenter(1)) screenCenter(2)]; %need to adjust location to figure location    

% define time intervals (in ms):
wait_for_fix = 500;
hold_target_time = 1000;
fig_offset_time = 500; %duration after figure disappears, during which the monkey is rewarded

%% Trial sequence event markers %for correct trial organization in .nev
% send some event markers
eventmarker(116 + TrialRecord.CurrentBlock); %block first
eventmarker(116 + TrialRecord.CurrentCondition); %condition second
eventmarker(116 + mod(TrialRecord.CurrentTrialNumber,10)); %last diget of trial sent third


%% 1) Fixation (scene 1)

% Set fixation to the left eye for tracking
fix1 = SingleTarget(tracker); % Initialize the eye tracking adapter
fix1.Target = fixation_point; % Set the fixation point
fix1.Threshold = fix_radius; % Set the fixation threshold

% Wait for fixation
wth1 = WaitThenHold(fix1); % Initialize the wait and hold adapter
wth1.WaitTime = 5000; % Set the wait time until fixation is acquired
wth1.HoldTime = 0; % Set the hold time

% Set the convergence cue background image
img1 = ImageGraphic(wth1);
img1.List = {prestimDir, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

%fixation spot on
on1 = OnOffGraphic(fix1);
on1.setOnGraphic(crc,[1 2]);

con1 = Concurrent(img1);
con1.add(on1); 

% Create scene 1
scene1 = create_scene(con1); % Initialize the scene adapter

%% 2) Scene 2: display background+ salient stim

fix2 = SingleTarget(tracker);
fix2.Target = fixation_point;
fix2.Threshold = fix_radius;

%fixation spot on
on2 = OnOffGraphic(fix2);
on2.setOnGraphic(crc,[1 2]);

%black photodiode  when target is on %needs to be coded ahead of stimulus so
%it is displayed on overlay of stimulus
blackbox = BoxGraphic(on2);
blackbox.EdgeColor = [0 0 0];
blackbox.FaceColor = [0 0 0];
blackbox.Size = [3 3];
blackbox.Position = lower_right;

target = ImageGraphic(blackbox);
imSize = [Screen.SubjectScreenFullSize(1)/2 Screen.SubjectScreenFullSize(2)];
target.List = {stimDir, center_left,[0 0 0],imSize;stimDir, center_right,  [0 0 0], imSize };   % put only one image in each row
target.Trigger = true;

tc2 = TimeCounter(target);
tc2.Duration = hold_target_time;

scene2 = create_scene(tc2);    
%% 3) Scene 3 (reward) or 4 (no reward) (stimulus goes off with this scene, reward or no reward)
fix3 = SingleTarget(tracker);
fix3.Target = fixation_point;
fix3.Threshold = fix_radius;
img3 = ImageGraphic(fix3);
img3.List = {prestimDir, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

tc3 = TimeCounter(img3);
tc3.Duration = fig_offset_time; %we can consider this as the inter-trial interval

%Scene 3 = if reward
rwd3 = RewardScheduler(tc3);
rwd3.Schedule = [0 1000 1000 100 90];   % Once stimulus disappears, deliver a 100-ms reward every second

rwoom = OnOffMarker(rwd3); %event code for Reward Delivered
rwoom.OnMarker = 96;

con3 = Concurrent(tc3);
con3.add(rwoom);
scene3 = create_scene(con3); % call create_scene when the property setting is done

%% scene 4 = if no reward

fix4 = SingleTarget(tracker);
fix4.Target = fixation_point;
fix4.Threshold = fix_radius;
img4 = ImageGraphic(fix4);
img4.List = {prestimDir, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

tc4 = TimeCounter(img4);
tc4.Duration = 0; %we can consider this as the inter-trial interval

scene4 = create_scene(tc4);

%% TASK 
tic
error_type = 0;
run_scene(scene1,9); % Run scene
rt1 = wth1.AcquiredTime;
if ~wth1.Success             % If the WaitThenHold failed (either fixation is not acquired or broken during hold),
    if wth1.Waiting          %    check whether we were waiting for fixation.
        error_type = 4;      % If so, fixation was never made and therefore this is a "no fixation (4)" error.
    else
        error_type = 3;      % If we were not waiting, it means that fixation was acquired but not held,
    end%    so this is a "break fixation (3)" error.
else
    eventmarker(8); % 8 = fixation occurs
end

%rt2 = wthk.AcquiredTime;
if 0==error_type %if wth1.Success
    % run scene  
    run_scene(scene2,23); %add event code of stim onset
    %if kc.Success
    %    kc.Success, dashboard(1, sprintf('Key press time: %d ms', kc.Time(1)));
   % end
    if ~tc2.Success         % The failure of Concurrent indicates that the subject didn't respond on time or broke fixation.
        error_type = 6;      % So it is a "Incorrect (6)" error.
        eventmarker(97); %97 = broke fixation. Since this is a monkey we don't have to worry about mouse press  only relevant for rewarder paradigm
    end
end

if 0==error_type %if tc2.Success
        if reward == 1
            % run scene    
            run_scene(scene3,24);
        else
            if reward == 0
                run_scene(scene4,24);
                %idle(0);
            end
        end
end

trialerror(error_type);      % Add the result to the trial history
%% Give the monkey a break
set_iti(500); % Inter-trial interval in [ms]
toc
%idle(0); 
%% Write info to file

fid = fopen(filename, 'a');
formatSpec =  '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%s\t%s\t%f\t%f\t%f\t\n';
fprintf(fid,formatSpec,...
    tr,...
    linedensity,...
    bg_ori,...
    fig_ori,...
    linelen,...
    fig_xloc_d,...
    fig_yloc_d,...
    fig_cont,...
    bg_cont,...
    diameter,...
    pdgm,...
    timestamp,...
    trig_delay,...
    ((-0.25*scrsize(1))+0),...
    0);
fclose(fid);
%sf,...
%tf,...
%trig_delay,...
%phase_angle,...
