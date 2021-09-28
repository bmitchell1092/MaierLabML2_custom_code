if ~exist('mouse_','var'), error('This demo requires the mouse input. Please enable it in the main menu or try the simulation mode.'); end
hotkey('x', 'escape_screen(); assignin(''caller'',''continue_'',false);');
TrialRecord.MarkSkippedFrames = false;  % skip skipped frame markers

dashboard(4,'Move: Left click + Drag, Resize: Right click + Drag',[0 1 0]);
dashboard(5,'Spatial Frequency: [LEFT(-) RIGHT(+)], Temporal Frequency: [DOWN(-) UP(+)]',[0 1 0]);
dashboard(6,'Press ''x'' to quit.',[1 0 0]);

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
fixThreshold = 1.5; % degrees of visual angle

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

and = AndAdapter(grat);
and.add(fix);

ood = OnOffDisplay(and);
ood.Dashboard = 3;
ood.OnMessage = 'ON Target';
ood.OffMessage = 'OFF Target';
ood.OnColor = [0 1 0];
ood.OffColor = [1 0 0];
tc = TimeCounter(ood);
tc.Duration = 300000;

bck = ImageGraphic(tc);
bck.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };

scene = create_scene(bck);

run_scene(scene);

%% Save BHV

% save parameters
bhv_variable('position',grat.Position);
bhv_variable('radius',grat.Radius);
bhv_variable('orientation',grat.Direction);
bhv_variable('spatial_frequency',grat.SpatialFrequency);
bhv_variable('temporal_frequency',grat.TemporalFrequency);
