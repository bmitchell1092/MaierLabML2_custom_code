%% Sept 2021, Blake Mitchell

%% Initial code
timestamp = datestr(now);

% Event Codes
% bhv_code(8,'Fixation occurs',11,'Start wait fixation',12,'End wait fixation',...
%     23,'TaskObject-1 ON',24,'TaskObject-1 OFF',25,'TaskObject-2 ON',26,'TaskObject-2 OFF',...
%     27,'TaskObject-3 ON',28,'TaskObject-3 OFF',29,'TaskObject-4 ON',30,'TaskObject-4 OFF',...
%     31,'TaskObject-5 ON',32,'TaskObject-5 OFF',33,'TaskObject-6 ON',34,'TaskObject-6 OFF',...
%     35,'Fixation spot ON',36,'Fixation spot OFF',96,'Reward delivered',97,'Broke fixation');  

% Initialize the escape key
hotkey('esc', 'escape_screen(); assignin(''caller'',''continue_'',false);');

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

