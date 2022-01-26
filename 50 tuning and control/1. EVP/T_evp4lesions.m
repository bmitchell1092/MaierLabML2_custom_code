%% Sept 2021, Blake Mitchell

% User Guide: *Important*
% Companion function: n/a

% % PARADIGMS
%  NAME    | # of trials 
% -----------------------------------
% 'evp4lesions'    | 200        


%% Initial code

% Initialize the escape key
hotkey('esc', 'escape_screen(); assignin(''caller'',''continue_'',false);');

global SAVEPATH datafile
datafile = MLConfig.FormattedName;
USER = getenv('username');

if strcmp(USER,'maierlab')
    SAVEPATH = 'C:\MLData\temp'; % change this from temp to a specific folder if needed
else
    SAVEPATH = strcat(fileparts(which('T_evp4lesions.m')),'\','output files');
end

flashDuration = (1000 / MLConfig.Screen.RefreshRate) * 2; % two screen refreshes
iti = 1500;

%% Scenes 

set_bgcolor([1 1 1]);   % Change the background color to white

cnt1 = TimeCounter(null_);
cnt1.Duration = flashDuration;

scene1 = create_scene(cnt1);
run_scene(scene1,23);

set_bgcolor([0 0 0]);   % Change the background color to black

cnt2 = TimeCounter(null_);
cnt2.Duration = 0;

scene2 = create_scene(cnt2);
run_scene(scene2,24);

%% Give monkey a break
set_iti(iti); % set to 1.5 seconds

