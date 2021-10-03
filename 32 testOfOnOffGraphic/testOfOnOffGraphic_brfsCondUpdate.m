if ~exist('eye_','var'), error('This demo requires eye signal input. Please set it up or try the simulation mode.'); end
hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);');

scrsize = Screen.SubjectScreenFullSize / Screen.PixelsPerDegree;  % Screen size [x y] in degrees

% SineGratingVariables
% Set receptive field
rf = [3 -3]; % [x y] in visual degrees
setRF(rf);
% Set the constant conditions
de = 3;                                 % Dominant eye: 1 = binocular, 2 = right eye, 3 = left eye
ori = [0];                              % Preferred or non-preferred orientation of grating
sf = [1];                               % Cycles per degree
tf = [0];                               % Cycles per second (0=static, 4=drifting)
diameter = [3];                         % Diameter of the grating
time = [1600];                          % Duration of trial in [ms]
left_xloc = (-0.25*scrsize(1))+rf(1);   % Left eye x-coordinate
right_xloc = (0.25*scrsize(1))+rf(1);   % Right eye x-coordinate                   % Grating color 2
phase_angle = [0];                      % Phase angle in degrees (0-360)
% Setting contrast. This applies to both gratings. 
color1 = [0.4, 0.4, 0.4];   % 0.1 deviance below mean
color2 = [0.6, 0.6, 0.6];   % 0.1 deviance above mean
                            % = 0.2 Michelson contrast
grat1a_ori = ori;
grat1b_ori = ori + 90;

fixpt = [0 0]; % [x y] in visual degrees
fixation_point = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)];

coherence = ceil(rand(1)*100);
direction = rand(1)*360;
speed = 1 + rand(1)*19;

% scene 1: fixation
fix1 = SingleTarget(eye_);
fix1.Target = fixation_point;
fix1.Threshold = 3;
img1 = ImageGraphic(fix1);
img1.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };
wth1 = WaitThenHold(img1);
wth1.WaitTime = 5000;
wth1.HoldTime = 0;
scene1 = create_scene(wth1);

% scene 2: sample
fix2 = SingleTarget(eye_);
fix2.Target = fixation_point;
fix2.Threshold = 6;
wth2 = WaitThenHold(fix2);
wth2.WaitTime = 0;
wth2.HoldTime = 5000;
grat = SineGrating(wth2);
grat.List = { [left_xloc rf(2)], diameter/2, grat1a_ori, sf, tf, phase_angle, color1, color2, 'circular', []; ...
    [right_xloc rf(2)], diameter/2, grat1b_ori, sf, tf, phase_angle, color1, color2, 'circular', []};
img2 = ImageGraphic(grat);
img2.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };
scene2 = create_scene(img2);

% task
% % dashboard(1,sprintf('Coherence = %d',coherence));
% % dashboard(2,sprintf('Direction = %.1f deg',direction));
% % dashboard(3,sprintf('Speed = %.1f deg/sec',speed));
% % dashboard(4,sprintf('Dot shape = %s',dot_shape{end}));

error_type = 0;
run_scene(scene1);
if ~wth1.Success
    if wth1.Waiting
        error_type = 4;  % no fixation
    else
        error_type = 3;  % broke fixation
    end
end

if 0==error_type
    run_scene(scene2);
    if ~wth2.Success
        error_type = 3;  % broke fixation
    end
end

rt = wth1.AcquiredTime;
trialerror(error_type);

dashboard(1,'');
dashboard(2,'');
dashboard(3,'');
dashboard(4,'');
idle(50);  % clear screen

set_iti(500);