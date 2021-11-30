%% Nov 2021 Blake Mitchell

% User Guide: *Important*
% Companion function: genImageRecordMl2
% Before running any paradigm (see below), always check:
% 1) Position (RF), 2) Orientation, 3) Spatial frequency
% 4) Phase, 5) Diameter (size), and 6) Contrast! 

% % PARADIGMS
%  NAME      | # of correct trials 
% -----------------------------------
% 'natstereo'    | 280

%% Paradigm selection 
paradigm = 'natstereo';
stimulus_set = 'A';

%% BEGIN
% Initialize the escape key
hotkey('esc', 'escape_screen(); assignin(''caller'',''continue_'',false);');

global SAVEPATH IMAGERECORD datafile IMAGEPATH
if TrialRecord.CurrentTrialNumber == 1
    IMAGERECORD = [];
end

datafile = MLConfig.FormattedName;
USER = getenv('username');
outputFolder = datafile(1:8);
flag_save = 1;

if strcmp(USER,'maierlab') && flag_save == 1
    SAVEPATH = strcat('C:\MLData\',outputFolder);
else
    SAVEPATH = strcat(fileparts(which('T_natural_images.m')),'\','output files');
end

set_bgcolor([0.5 0.5 0.5]); % This is to force eye calibration to have gray background

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
tr = tnum(TrialRecord);

%% On the 1st trial

if tr == 1
    
     % Set the image path
    IMAGEPATH = char(strcat(fileparts(which('T_natural_images.m')),filesep,'stereo stimuli',{' '},stimulus_set));
    
    % Generate IMAGERECORD
    genImageRecordML2(paradigm, TrialRecord);
    
    % Generate the background image
    cd(fileparts(which('genImageRecordML2.m')))
    genFixCross((fixpt(1)*Screen.PixelsPerDegree), (fixpt(2)*Screen.PixelsPerDegree));
 
    filename = fullfile(SAVEPATH,sprintf('%s.gImageXY_di',datafile));
    fid = fopen(filename, 'w');
    formatSpec =  '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n';
    fprintf(fid,formatSpec,...
        'trial',...
        'header',...
        'stimulus set',...
        'image_number',...
        'ID_L',...
        'xpos_L',...
        'ypos_L',...
        'horzdva_L',...
        'vertdva_L',...
        'ID_R',...
        'xpos_R',...
        'ypos_R',...
        'horzdva_R',...
        'vertdva_R',...
        'image_scalar',...
        'image_width',...
        'image_height',...
        'mean_luminance',...
        'condition',...
        'x_disparity',...
        'y_disparity',...
        'scramble',...
        'ori',...
        'eye',...
        'stim_dur',...
        'isi',...
        'fix_x',...
        'fix_y',...
        'rf_x',...
        'rf_y',...
        'timestamp');
    fclose(fid);
    
elseif size(IMAGERECORD,2) < tr
    %GENERATE NEW GRATING RECORD IF THIS TRIAL IS LONGER THAN CURRENT GRATINGRECORD
    genImageRecordML2(paradigm, TrialRecord);
    disp('Number of minimum trials met');
end

%% Image selection / features 

% Image info / placement
img_num = IMAGERECORD(tr).num;
xpos_L = IMAGERECORD(tr).xpos_L; % Left eye x-coordinate
xpos_R = IMAGERECORD(tr).xpos_R; % Right eye x-coordinate
ypos_L = IMAGERECORD(tr).ypos_L; % Right eye x-coordinate
ypos_R = IMAGERECORD(tr).ypos_R; % Right eye x-coordinate

% condition information
eye = IMAGERECORD(tr).eye;
condition = IMAGERECORD(tr).condition; 
shifted_eye = IMAGERECORD(tr).shifted_eye; 
x_disparity = IMAGERECORD(tr).x_disparity;
y_disparity = IMAGERECORD(tr).y_disparity;
ori = IMAGERECORD(tr).ori;
scramble = IMAGERECORD(tr).scramble;
scale = IMAGERECORD(tr).scale;

% general information
header = IMAGERECORD(tr).header;
isi = IMAGERECORD(tr).isi;
stimdur = IMAGERECORD(tr).stimdur;
rf_x = IMAGERECORD(tr).rf_x;
rf_y = IMAGERECORD(tr).rf_x;
gray = [0.5 0.5 0.5]; 

% if shift values = zero, it's zero or relative disparity 
if shifted_eye == 3 % left eye 
    xpos_L = xpos_L + x_disparity;
    ypos_L = ypos_L + y_disparity;
elseif shifted_eye == 2 % right eye
    xpos_R = xpos_R + x_disparity;
    ypos_R = ypos_R + y_disparity;
end

% Grab images
switch header
%     case 'natdisparity_abs' % taking just one image and moving it horizontally in one eye across trials
%         
%         for i = 1:length(img_num)
%             if scramble(i) == 0
%                 L_imagedir = strcat(IMAGEPATH,'/image_L/');
%             else
%                 L_imagedir = strcat(IMAGEPATH,'/image_L_scr/');
%             end
%             
%             files = dir(L_imagedir); files(1:2) = [];
%             
%             image(i).L = strcat(L_imagedir,files(img_num(i)).name);
%             image(i).R = strcat(L_imagedir,files(img_num(i)).name);
%             
%         end
        
%     case 'natdisparity_rel' % taking just one image and moving it horizontally in one eye across trials
%         
%         for i = 1:length(img_num)
%             if scramble(i) == 0
%                 L_imagedir = strcat(IMAGEPATH,'/image_L/');
%                 R_imagedir = strcat(IMAGEPATH,'/image_R/');
%             else
%                 L_imagedir = strcat(IMAGEPATH,'/image_L_scr/');
%                 R_imagedir = strcat(IMAGEPATH,'/image_R_scr/');
%             end
%             
%             files_L = dir(L_imagedir); files_L(1:2) = [];
%             files_R = dir(R_imagedir); files_R(1:2) = [];
%             
%             image(i).L = strcat(L_imagedir,files_L(img_num(i)).name);
%             image(i).R = strcat(R_imagedir,files_R(img_num(i)).name);
%             
%         end
        
    case 'natstereo' % taking just one image and moving it horizontally in one eye across trials
        
        for i = 1:length(img_num)
            if scramble(i) == 0 % if image is not scrambled
                if condition(i) == 1 % cyclopean view
                    L_imagedir = strcat(IMAGEPATH,'\L_image\');
                    R_imagedir = strcat(IMAGEPATH,'\L_image\');
                elseif condition(i) == 2 % relative disparity
                    L_imagedir = strcat(IMAGEPATH,'\L_image\');
                    R_imagedir = strcat(IMAGEPATH,'\R_image\');
                end
            elseif scramble(i) == 1
                if condition(i) == 1 % cyclopean view
                    L_imagedir = strcat(IMAGEPATH,'\L_image_scr\');
                    R_imagedir = strcat(IMAGEPATH,'\L_image_scr\');
                elseif condition(i) == 2 
                    L_imagedir = strcat(IMAGEPATH,'\L_image_scr\');
                    R_imagedir = strcat(IMAGEPATH,'\R_image_scr\');
                end
            end
            
            files_L = dir(L_imagedir); files_L(1:2) = [];
            files_R = dir(R_imagedir); files_R(1:2) = [];
            
            image(i).L = strcat(L_imagedir,files_L(img_num(i)).name);
            image(i).R = strcat(R_imagedir,files_R(img_num(i)).name);
            
        end
        
end

% Image size (length, width)
pixelsPerDegree = Screen.PixelsPerDegree;
imSize = [pixelsPerDegree*scale, pixelsPerDegree*scale];


%% Pre-load images into structs

ImageList.left = ...
    {{image(1).L},[xpos_L(1) ypos_L(1)], [0 0 0], imSize, ori(1); ...
    {image(2).L},[xpos_L(2) ypos_L(2)], [0 0 0], imSize, ori(2);...
    {image(3).L},[xpos_L(3) ypos_L(3)], [0 0 0], imSize, ori(3)};
    
ImageList.right = ...
    {{image(1).R}, [xpos_R(1) ypos_L(1)], [0 0 0], imSize, ori(1); ...
    {image(2).R}, [xpos_R(2) ypos_L(2)], [0 0 0], imSize, ori(2);...
    {image(3).R}, [xpos_R(3) ypos_R(3)], [0 0 0], imSize, ori(3)};

%% Trial sequence event markers
% send some event markers
eventmarker(116 + TrialRecord.CurrentBlock); %block first
eventmarker(116 + TrialRecord.CurrentCondition); %condition second
eventmarker(116 + mod(TrialRecord.CurrentTrialNumber,10)); %last diget of trial sent third


% Trialwise command Line announcements (helps with testing)
global prespertr
for p = 1:prespertr
    if condition(p) == 1
        stereo_string = 'None';
    else
        stereo_string = 'Relative Disparity';
    end
    fprintf('Trial #%d | Pres %d = %s \n',tr,p,stereo_string);
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
pd2.Position = pd_position;

% Create both images
img2 = ImageGraphic(pd2);
img2.List = {ImageList.left{1,:};
              ImageList.right{1,:}};
          
bck2 = ImageGraphic(img2);
bck2.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

wth2 = WaitThenHold(bck2);
wth2.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
wth2.HoldTime = stimdur;

scene2 = create_scene(wth2);

%% Scene 3. Task Object #2
% Set fixation to the left eye for tracking
fix3 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix3.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix3.Threshold = fixThreshold; % Set the fixation threshold

pd3 = BoxGraphic(fix3);
pd3.EdgeColor = [1 1 1];
pd3.FaceColor = [1 1 1];
pd3.Size = [3 3];
pd3.Position = pd_position;

% Create both images
img3 = ImageGraphic(pd3);
img3.List = {ImageList.left{2,:};
              ImageList.right{2,:}};
          
bck3 = ImageGraphic(img3);
bck3.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

wth3 = WaitThenHold(bck3);
wth3.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
wth3.HoldTime = stimdur;

scene3 = create_scene(wth3);

%% Scene 4. Task Object #3
% Set fixation to the left eye for tracking
fix4 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix4.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix4.Threshold = fixThreshold; % Set the fixation threshold

pd4 = BoxGraphic(fix4);
pd4.EdgeColor = [1 1 1];
pd4.FaceColor = [1 1 1];
pd4.Size = [3 3];
pd4.Position = pd_position;

% Create both images
img4 = ImageGraphic(pd4);
img4.List = {ImageList.left{3,:};
              ImageList.right{3,:}};
          
bck4 = ImageGraphic(img4);
bck4.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

wth4 = WaitThenHold(bck4);
wth4.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
wth4.HoldTime = stimdur;

scene4 = create_scene(wth4);

%% Scene 5. Inter-stimulus interval

fix5 = SingleTarget(eye_); % Initialize the eye tracking adapter
fix5.Target = [(-0.25*scrsize(1))+fixpt(1) fixpt(2)]; % Set the fixation point
fix5.Threshold = fixThreshold; % Set the fixation threshold

pd5 = BoxGraphic(fix5);
pd5.EdgeColor = [0 0 0];
pd5.FaceColor = [0 0 0];
pd5.Size = [3 3];
pd5.Position = pd_position;

bck5 = ImageGraphic(pd5);
bck5.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

wth5 = WaitThenHold(bck5);
wth5.WaitTime = 0;             % We already knows the fixation is acquired, so we don't wait.
wth5.HoldTime = isi;
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
run_scene(scene1,[35,11]); % WaitThenHold | 35 = Fix spot on, 11 = Start wait fixation
if ~wth1.Success             % If the WithThenHold failed (either fixation is not acquired or broken during hold),
    if wth1.Waiting          %    check whether we were waiting for fixation.
        error_type = 4;      % If so, fixation was never made and therefore this is a "no fixation (4)" error.
        run_scene(scene6,[12]);  % blank screen | 12 = end wait fixation
    else
        error_type = 3;      % If we were not waiting, it means that fixation was acquired but not held,
        run_scene(scene6,[97,36]);   % blank screen | 97 = fixation broken, 36 = fix cross OFF
    end   %    so this is a "break fixation (3)" error.
else
    eventmarker(8); % 8 = fixation occurs
end

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
    run_scene(scene5,24);    % Run the fifth scene - This is the blank offset between flashes
    if ~fix3.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene6,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
% %         eventmarker(24) % 24 = task object 1 OFF 
    end
end

if 0==error_type
    run_scene(scene3,25);    % Run the third scene (eventmarker 25 - TaskObject - 2 ON) 
    if ~fix4.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene6,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
% %         eventmarker(26) % 26 = task object 2 OFF 
    end
end

if 0==error_type
    run_scene(scene5,26);    % Run the fifth scene - This is the blank offset between flashes
    if ~fix3.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene6,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
% %         eventmarker(24) % 24 = task object 1 OFF 
    end
end

if 0==error_type
    run_scene(scene4,27);    % Run the fourth scene (eventmarker 27 - TaskObject - 3 ON) 
    if ~fix5.Success         % The failure of WithThenHold indicates that the subject didn't maintain fixation on the sample image.
        error_type = 3;      % So it is a "break fixation (3)" error.
        run_scene(scene6,[97,36]); % blank screen | 97 = fixation broken, 36 = fix cross OFF
    else
% %         eventmarker(26) % 26 = task object 2 OFF 
    end
end

% reward
if 0==error_type
    run_scene(scene6,[28,36]); % event code for fix cross OFF 
    goodmonkey(100, 'juiceline',1, 'numreward',2, 'pausetime',500, 'eventmarker',96); % 100 ms of juice x 2. Event marker for reward
end


trialerror(error_type);      % Add the result to the trial history

%% Give the monkey a break
set_iti(1000); % Inter-trial interval in [ms]

%% Write info to file

filename = fullfile(SAVEPATH,sprintf('%s.gImageXY_di',datafile));


for pres = 1:prespertr
    [~,ID(pres).L,~] = fileparts(image(pres).L);
    [~,ID(pres).R,~] = fileparts(image(pres).R);
    
    fid = fopen(filename, 'a');  % append
    formatSpec =  '%04u\t%s\t%s\t%f\t%s\t%f\t%f\t%f\t%f\t%s\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\r\n';
    fprintf(fid,formatSpec,...
        TrialRecord.CurrentTrialNumber,...
        header,...
        stimulus_set,...
        img_num(pres),...
        string(ID(pres).L),...
        xpos_L(pres),...
        ypos_L(pres),...  
        (xpos_L(pres)+0.25*scrsize(1)),...
        ypos_L(pres),...
        string(ID(pres).R),...
        xpos_R(pres),...
        ypos_R(pres),...
        (xpos_R(pres)-0.25*scrsize(1)),...
        ypos_R(pres),...
        scale,...
        imSize(1),...
        imSize(2),...
        gray(1),...
        condition(pres),...
        x_disparity(pres),...
        y_disparity(pres),...
        scramble(pres),...
        ori(pres),...
        eye(pres),...
        stimdur,...
        isi,...
        fixpt(1),...
        fixpt(2),...
        rf_x,...
        rf_y,...
        now);
    
    fclose(fid);
end


