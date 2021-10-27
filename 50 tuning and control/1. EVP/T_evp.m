%% Sept 2021, Blake Mitchell

% User Guide: *Important*
% Companion function: n/a

% % PARADIGMS
%  NAME    | # of trials 
% -----------------------------------
% 'evp'    | 200        


%% Initial code
timestamp = datestr(now);

% Initialize the escape key
hotkey('esc', 'escape_screen(); assignin(''caller'',''continue_'',false);');

global SAVEPATH datafile
datafile = MLConfig.FormattedName;
USER = getenv('username');

if strcmp(USER,'maierlab')
    SAVEPATH = 'C:\MLData\temp'; % change this from temp to a specific folder if needed
else
    SAVEPATH = strcat(fileparts(which('T_evp.m')),'\','output files');
end

time = 50;
iti = 1000;

% Trial number increases by 1 for every iteration of the code
trialnum = tnum(TrialRecord);

if trialnum == 1
    taskdir = fileparts(which('T_evp.m'));
    fid = fopen(strcat(taskdir,'\','evp'), 'w'); % Write to a text file
    formatSpec =  '%s\t%s\t%s\t%s\t\n';
    fprintf(fid,formatSpec,...
        'Trial Number',...
        'Time Stamp',...
        'Inter-trial Interval',...
        'Flash Duration');
    fclose(fid);
end

%% Scenes 

set_bgcolor([1 1 1]);   % Change the background color to white

cnt1 = TimeCounter(null_);
cnt1.Duration = time;

scene1 = create_scene(cnt1);
run_scene(scene1,23);

set_bgcolor([0 0 0]);   % Change the background color to black

cnt2 = TimeCounter(null_);
cnt2.Duration = 0;

scene2 = create_scene(cnt2);
run_scene(scene2,24);

%% Write info to file
taskdir = fileparts(which('T_evp.m'));
fid = fopen(strcat(taskdir,'\','evp'), 'a'); % Write to a text file
formatSpec =  '%f\t%f\t%f\t%f\t\n';
fprintf(fid,formatSpec,...
    trialnum,...
    timestamp,...
    iti,...
    time);
    
fclose(fid);

%% Give monkey a break
set_iti(iti);

