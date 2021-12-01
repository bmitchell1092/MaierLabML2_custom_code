if ~exist('mouse_','var'), error('This demo requires the mouse input. Please enable it in the main menu or try the simulation mode.'); end
hotkey('esc', 'escape_screen(); assignin(''caller'',''continue_'',false);');

TrialRecord.MarkSkippedFrames = false;  % skip skipped frame markers

dashboard(3,'Move: Left click + Drag, Resize: Right click + Drag',[0 1 0]);
dashboard(4,'Spatial Frequency: [LEFT(-) RIGHT(+)], Temporal Frequency: [DOWN(-) UP(+)]',[0 1 0]);
dashboard(5,'Press ''esc'' to print params or exit.',[1 1 1]);

mouse_.showcursor(false);  % hide the mouse cursor from the subject

% editables
SpatialFrequencyStep = 0.1;
TemporalFrequencyStep = 0.1;
Color1 = [1 1 1];
Color2 = [0 0 0];
editable('SpatialFrequencyStep','TemporalFrequencyStep','-color',{'Color1','Color2'});

% Set screensize
scrsize = Screen.SubjectScreenFullSize / Screen.PixelsPerDegree;  

% Set the fixation point
fixpt = [0 0]; % [x y] in visual degrees
fixThreshold = 1; % degrees of visual angle

hotkey('c', 'forced_eye_drift_correction([((-0.25*scrsize(1))+fixpt(1)) fixpt(2)],1);');  % eye1

set_bgcolor([0.5 0.5 0.5]);

%% Scene: Manual grating

grat = Grating_RF_Mapper(mouse_);
grat.SpatialFrequencyStep = SpatialFrequencyStep;
grat.TemporalFrequencyStep = TemporalFrequencyStep;
grat.Color1 = Color1;
grat.Color2 = Color2;
grat.InfoDisplay = true;

% initiate eye tracker
fix = SingleTarget(eye_); % Initialize the eye tracking adapter
fix.Target = [((-0.25*scrsize(1))+fixpt(1)) fixpt(2)]; % Set the fixation point
fix.Threshold = fixThreshold; % Set the fixation threshold

ood = OnOffDisplay(fix);
ood.Dashboard = 3;
ood.OnMessage = 'ON Target';
ood.OffMessage = 'OFF Target';
ood.OnColor = [0 1 0];
ood.OffColor = [1 0 0];

rwd = RewardScheduler(fix);
rwd.Schedule = [250 2000 2000 100 96;  % Once fixation starts, deliver a 100-ms reward every seconds
    3000 750 750 200 96];  % if fix is maintained longer than 3 s, give a 200-ms reward every 2s

tc = TimeCounter(rwd);
tc.Duration = 999999;

bck = ImageGraphic(tc);
bck.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

and = AndAdapter(grat);
and.add(bck);

scene = create_scene(and);

run_scene(scene);

%% Save BHV and Global variable

horzdva = grat.Position(1)+0.25*scrsize(1);

% save parameters
bhv_variable('position',grat.Position);
bhv_variable('horzdva',horzdva);
bhv_variable('radius',grat.Radius);
bhv_variable('orientation',grat.Direction);
bhv_variable('spatial_frequency',grat.SpatialFrequency);
bhv_variable('temporal_frequency',grat.TemporalFrequency);

fprintf('\nPosition = [%0.2f, %0.2f] \nDiameter = %0.2f \nOrientation = %f \nSpatialFreq = %0.2f \nTemporalFreq = %0.2f \n',...
    horzdva,grat.Position(2),grat.Radius*2, grat.Direction,grat.SpatialFrequency,grat.TemporalFrequency);

global rfmap_params 
rfmap_params.Position = [horzdva,grat.Position(2)];
rfmap_params.Diameter = grat.Radius*2;
rfmap_params.Orientation = grat.Direction;
rfmap_params.SpatialFreq = grat.SpatialFrequency;
rfmap_params.TemporalFreq = grat.TemporalFrequency;