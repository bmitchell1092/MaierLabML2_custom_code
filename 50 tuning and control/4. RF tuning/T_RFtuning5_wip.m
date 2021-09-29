%% Jun 2019, Jacob Rogatinsky
% Sept. 2021, Revised by Blake Mitchell

% Initialize the escape key
hotkey('esc', 'escape_screen(); assignin(''caller'',''continue_'',false);');

global SAVEPATH 

SAVEPATH = fileparts(which('T_RFtuning.m'));

%% Initial code
% Paradigm selection  
% 'cinteroc'        Grating contrast varies trial to trial, eye to eye
% 'rfori'           Grating orientation varies trial to trial
% 'rfsize'          Grating size varies trial to trial
% 'rfsf'            Grating spatial frequency varies trial to trial
% 'posdisparity'    Grating x-position (DE) varies from trial to trial
% 'phzdisparity'    Grating phase angle (DE) varies from trial to trial
% 'cone'            Grating colors vary trial to trial, eye to eye

paradigm = 'rfori';

timestamp = datestr(now); % Get the current time on the computer

% Set fixation point
fixpt = [0 0]; % [x y] in viual degrees
fixThreshold = 3; % degrees of visual angle

% define intervals for WaitThenHold
wait_for_fix = 3000;
initial_fix = 200; % hold fixation for 200ms to initiate trial

% Find screen size
scrsize = Screen.SubjectScreenFullSize / Screen.PixelsPerDegree;  % Screen size [x y] in degrees
setCoord(scrsize); % Send value to a global variable
lower_right = [(scrsize(1)*0.5-0.5) (scrsize(2)*(-0.5)+0.5)];

% Trial number increases by 1 for every iteration of the code
tr = tnum(TrialRecord);

% On the first trial, generate grating record
if tr == 1
    genGratingRecordML2(paradigm,TrialRecord);
    genFixCross((fixpt(1)*Screen.PixelsPerDegree), (fixpt(2)*Screen.PixelsPerDegree));   
    taskdir = fileparts(which('T_RFtuning.m'));
    fid = fopen(strcat(taskdir,'/',upper(paradigm),'.g',upper(paradigm),'Grating_di'), 'w');    
    formatSpec =  '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\n';
    fprintf(fid,formatSpec,...
        'Trial Number',...
        'RF X-Coord',...
        'RF Y-Coord',...
        'tilt',...
        'sf',...
        'tf',...
        'Dominant Contrast',...
        'NonDom Contrast',...
        'Diameter',...
        'Dominant Eye',...
        'NonDom Eye',...
        'Phase Disparity',...
        'Paradigm',...
        'Phase Angle',...
        'Time Stamp',...
        'Pos Disparity',...
        'Fixation X-Coord',...
        'Fixation Y-Coord',...
        'Cone Path');
    fclose(fid);
    
end

% Call the seed number created during the first trial using a separate
% external function -- this way, the seed number only changes when
% Test_Drifting_Grating1 is restarted each iteration within MonkeyLogic
% sdnum = getSeed;

%% Struct of pseudo-randomized trial conditions
% If it's the first trial
% if trialnum == size(GRATINGRECORD)
%     rng(sdnum) % Set the randomizer seed
%     r = genTuningParams(paradigm); % Call the pseudorandomizer function
%     
% % If it's not the first trial
% else
%     rng(sdnum) % Set the randomizer seed
%     r = genTuningParams(paradigm); % Call the pseudorandomizer function
%     
%     % When 'trialnum' exceeds the length of the struct 'r', use
%     % 'placeholder' to go back to the beginning of the struct
%     placeholder = mod(trialnum,length(r));
%     if placeholder == 0
%         placeholder = length(r);
%     end
%     
%     % Cycle through each row within the struct's fields
%     r(end+1:end+placeholder-1) = r(1:placeholder-1);
%     r(1:placeholder-1)=[];
%     
% end

%% Assign values to each sine grating condition
% Set the conditions

global GRATINGRECORD

grating_tilt = GRATINGRECORD(tr).grating_tilt;
grating_eye = GRATINGRECORD(tr).grating_eye;
grating_phase = GRATINGRECORD(tr).grating_phase;
grating_sf = GRATINGRECORD(tr).grating_sf;
grating_tf = GRATINGRECORD(tr).grating_tf;
grating_contrast = GRATINGRECORD(tr).grating_contrast;
grating_diameter = GRATINGRECORD(tr).grating_diameter;
grating_xpos = GRATINGRECORD(tr).grating_xpos;
grating_ypos = GRATINGRECORD(tr).grating_ypos;
stereo_xpos = GRATINGRECORD(tr).stereo_xpos;
grating_header = GRATINGRECORD(tr).header;
grating_varyeye = GRATINGRECORD(tr).grating_varyeye;
grating_fixedc = GRATINGRECORD(tr).grating_fixedc;
grating_oridist = GRATINGRECORD(tr).grating_oridist;
grating_outerdiameter = GRATINGRECORD(tr).grating_outerdiameter;
grating_space = GRATINGRECORD(tr).grating_space;
grating_isi = GRATINGRECORD(tr).grating_isi;
grating_stimdur = GRATINGRECORD(tr).grating_stimdur;
prespertr = GRATINGRECORD(tr).prespertr;

xloc_left = (-0.25*scrsize(1)+grating_xpos(2,1));   % Left eye x-coordinate
xloc_right = (0.25*scrsize(1)+grating_xpos(1,1));   % Right eye x-coordinate

gray = [0.5 0.5 0.5];
color1 = gray + (grating_contrast(1) / 2);
color2 = gray - (grating_contrast(1) / 2);

% ndom_color1 = gray + (ndomcont / 2);
% ndom_color2 = gray - (ndomcont / 2);




% 
% for i = 1:5
% ori(i) = r(i).ori; % Orientation of grating
% end
% sf = r(1).sf;  % Spatial frequency: cycles per degree
% tf = r(1).tf;  % Temporal frequency: cycles per second
% diameter = r(1).diam; % Diameter of the grating
% cont_left = r(1).cont_left; % Left eye contrast (0 to 1)
% cont_right = r(1).cont_right; % Right eye contrast (0 to 1)
% xloc_left = r(1).xloc_left; % Left eye x-coordinate
% xloc_right = r(1).xloc_right; % Right eye x-coordinate
% phase = r(1).phase; % Phase angles
% % Phase NEEDS DEV

% 
% if de == 3
%     de_phase = phase;
%     nde_phase = 0;
%     de_string = 'Left';
%     nde_string = 'Right';
%     domloc = xloc_left;
%     ndomloc = xloc_right;
%     domcont = cont_left;
%     ndomcont = cont_right;
% elseif de == 2
%     de_phase = 0;
%     nde_phase = phase;
%     de_string = 'Right';
%     nde_string = 'Left';
%     domloc = xloc_right;
%     ndomloc = xloc_left;
%     domcont = cont_right;
%     ndomcont = cont_left;
% else
%     phase_angle_left = 0;
%     phase_angle_right = 0;
%     de_string = 'Binocular';
%     nde_string = 'Binocular';
%     domloc = xloc_right;
%     ndomloc = xloc_left;
%     domcont = cont_right;
%     ndomcont = cont_left;
% end

% switch r(1).color
%     case 1
%         gray = [0.5 0.5 0.5]; 
%         dom_color1 = gray + (domcont / 2); 
%         dom_color2 = gray - (domcont / 2);
%         
%         ndom_color1 = gray + (ndomcont / 2);
%         ndom_color2 = gray - (ndomcont / 2);
%         
%         pathw = 'grayscale';
%     case 2
%         color1 = silsbtw_mod(1,:);
%         color2 = silsbtw_mod(2,:);
%         pathw = 'LM';
%     case 3
%         color1 = sbtw_mod(1,:);
%         color2 = sbtw_mod(2,:);
%         pathw = 'S';
%     case 4
%         color1 = plusMminusL(1,:);
%         color2 = plusMminusL(2,:);
%         pathw = 'LMo';
% end

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
fix1.Threshold = fixThreshold; % Set the fixation threshold

bck1 = ImageGraphic(fix1);
bck1.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

wth1 = WaitThenHold(bck1); % Initialize the wait and hold adapter
wth1.WaitTime = 5000; % Set the wait time
wth1.HoldTime = 200; % Set the hold time

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
presNum = 0;

if wth1.Success % If fixation was acquired and held
    
    for ii = 1:(prespertr*2) - 1
        
        real_ind = (ii+1)/2;
        
        if mod(ii,2) == 1 % this function is basically saying every odd number of ii
            presNum = presNum + 1;
            fix2 = SingleTarget(eye_); % Initialize the eye tracking adapter
            fix2.Target = [(-0.25*scrsize(1))+fixpt(1) fixpt(2)]; % Set the fixation point
            fix2.Threshold = fixThreshold; % Set the fixation threshold
            
            pd = BoxGraphic(fix2);
            pd.EdgeColor = [1 1 1];
            pd.FaceColor = [1 1 1];
            pd.Size = [3 3];
            pd.Position = lower_right;
            
            % Create the right eye grating
            left_grat = SineGrating(pd);
            left_grat.Position = [stereo_xpos(1,presNum) grating_ypos(1,presNum)]; % 1st element is right eye
            left_grat.Radius = grating_diameter(presNum)/2;
            left_grat.Direction = grating_tilt(presNum);
            left_grat.SpatialFrequency = grating_sf(presNum);
            left_grat.TemporalFrequency = grating_tf(presNum);
            left_grat.Color1 = color1;
            left_grat.Color2 = color2;
            left_grat.Phase = grating_phase(presNum);
            left_grat.WindowType = 'circular';
            
            % Create the left eye grating
            right_grat = SineGrating(left_grat);
            right_grat.Position = [stereo_xpos(2,presNum) grating_ypos(2,presNum)]; % 1st element is right eye
            right_grat.Radius = grating_diameter(presNum)/2;
            right_grat.Direction = grating_tilt(presNum);
            right_grat.SpatialFrequency = grating_sf(presNum);
            right_grat.TemporalFrequency = grating_tf(presNum);
            right_grat.Color1 = color1;
            right_grat.Color2 = color2;
            right_grat.Phase = grating_phase(presNum);
            right_grat.WindowType = 'circular';
            
            % Set the timer
            cnt2 = TimeCounter(right_grat);
            cnt2.Duration = grating_stimdur;
            
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
            fix2.Threshold = fixThreshold; % Set the fixation threshold
           
            bck2 = ImageGraphic(fix2);
            bck2.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };
            
            % Set the timer
            cnt2 = TimeCounter(bck2);
            cnt2.Duration = grating_isi;
            
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
% taskdir = fileparts(which('T_RFtuning.m'));
% fid = fopen(strcat(taskdir,'/',upper(paradigm),'.g',upper(paradigm),'Grating_di'), 'a');
% formatSpec =  '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%s\t%s\t%f\t%s\t%f\t%s\t%f\t%f\t%f\t%s\t\n';
% fprintf(fid,formatSpec,...
%     tr,...
%     domloc,...
%     rf(2),...
%     ori,...
%     sf,...
%     tf,...
%     domcont,...
%     ndomcont,...
%     diameter,...
%     de_string,...
%     nde_string,...
%     0,...
%     paradigm,...
%     phase,...
%     timestamp,...
%     domloc+ndomloc,...
%     ((-0.25*scrsize(1))+fixpt(1)),...
%     fixpt(2),...
%     pathw);
%     
% fclose(fid);
    
%% Give the monkey a break
set_iti(800); % Inter-trial interval in [ms]

%%