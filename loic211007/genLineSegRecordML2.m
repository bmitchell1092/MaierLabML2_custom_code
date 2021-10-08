function genLineSegRecordML2(paradigm, TrialRecord)
%generate variable that pre-sets grating parameters for n number of trials

global LINESEGRECORD SAVEPATH datafile
params.linelen = [1,2, 3, 4, 5, 6,7, 8,16];
params.asynch = [500];                 % Asynchrony in [ms] (200 and/or 800)
params.location = [-248,247,-248,247;-270,-270,270,270]; %stimulus location
params.ori = [45,135; 135, 45];
params.contrast       =  0.8; % must be scaler! edit g
oldLINESEGRECORD = LINESEGRECORD;
LINESEGRECORD = [];
struct(LINESEGRECORD);

switch paradigm
    
    case 'notsalientNrw'
        params.cond_code = [1];
        fprintf('n conditions %u\n',length(params.linelen)*size(params.location,2)*size(params.ori,2)*length(params.cond_code)); 

        all_con = combvec(params.cond_code,params.linelen, params.location,params.ori); % All possible combos
        [row, col] = size(all_con); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            LINESEGRECORD(tr).cond_code = all_con(1,shuffle(tr));
            LINESEGRECORD(tr).linelen = all_con(2,shuffle(tr));
            LINESEGRECORD(tr).location = all_con(3:4,shuffle(tr));
            LINESEGRECORD(tr).ori = all_con(5:6,shuffle(tr));
            
        end
        
    case 'fixSpotOn'
        params.cond_code = [2];
        fprintf('n conditions %u\n',length(params.linelen)*size(params.location,2)*size(params.ori,2)*length(params.cond_code)); 

        all_con = combvec(params.cond_code,params.linelen, params.location,params.ori); % All possible combos
        [row, col] = size(all_con); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            LINESEGRECORD(tr).cond_code = all_con(1,shuffle(tr));
            LINESEGRECORD(tr).linelen = all_con(2,shuffle(tr));
            LINESEGRECORD(tr).location = all_con(3:4,shuffle(tr));
            LINESEGRECORD(tr).ori = all_con(5:6,shuffle(tr));
            
        end
        
    case  'flashedNrw' %'simult'
        params.cond_code = [3];
        
        all_con = combvec(params.cond_code,params.linelen, params.location,params.ori); % All possible combos
        [row, col] = size(all_con); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            LINESEGRECORD(tr).cond_code = all_con(1,shuffle(tr));
            LINESEGRECORD(tr).linelen = all_con(2,shuffle(tr));
            LINESEGRECORD(tr).location = all_con(3:4,shuffle(tr));
            LINESEGRECORD(tr).ori = all_con(5:6,shuffle(tr));
        end
        
        case  'squareStim' %'simult'
        cond_code = [4];
        
        all_con = combvec(params.cond_code,params.linelen, params.location,params.ori); % All possible combos
        [row, col] = size(all_con); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            LINESEGRECORD(tr).cond_code = all_con(1,shuffle(tr));
            LINESEGRECORD(tr).linelen = all_con(2,shuffle(tr));
            LINESEGRECORD(tr).location = all_con(3:4,shuffle(tr));
            LINESEGRECORD(tr).ori = all_con(5:6,shuffle(tr));
        end
        
    case 'notsalientRw'
        params.cond_code = [5];
        
        all_con = combvec(params.cond_code,params.linelen, params.location,params.ori); % All possible combos
        [row, col] = size(all_con); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            LINESEGRECORD(tr).cond_code = all_con(1,shuffle(tr));
            LINESEGRECORD(tr).linelen = all_con(2,shuffle(tr));
            LINESEGRECORD(tr).location = all_con(3:4,shuffle(tr));
            LINESEGRECORD(tr).ori = all_con(5:6,shuffle(tr));
            
        end
end
%all_con               = combvec(params.theta,params.eccentricities,params.eye); 

%minpres = 10;                                   % total number of presentations at each loc
%npres   = 5;                                    % number of dot presentations per trial
%minntrs = size(all_con,2)*minpres ./ (npres);    %minpres/npres; % number of trials
%{
fprintf('The number of trials will be %d with %d presentations per trial.\n',minntrs,npres); 

noshuf = 0; % if you don't want to shuffle dot positions set to 1


if ~noshuf
shuflocs = randi([1 size(all_con,2)],(size(all_con,2)*minpres),1); 
else
 shuflocs = [1:(size(all_con,2)*minpres)]';    
end
%}
%{
for tr = 1:minntrs
    theseid = [((tr-1)*npres + 1):((tr-1)*npres + npres)]; 
    
        [x,y] = pol2cart(deg2rad(all_con(1,shuflocs(theseid))),all_con(2,shuflocs(theseid)));
 
    LINESEGRECORD(tr).dot_xpos         = ceil(x*100)./100;
    LINESEGRECORD(tr).dot_ypos         = ceil(y*100)./100;
    LINESEGRECORD(tr).dot_contrast     = repmat(params.contrast,npres,1)'; 
    LINESEGRECORD(tr).dot_eye          = all_con(3,shuflocs(theseid)); 
 clear x y 
end
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% combine with previous GLOBAL if needed
if ~isempty(oldLINESEGRECORD)
    LINESEGRECORD = [oldLINESEGRECORD LINESEGRECORD];
    clear oldLINESEGRECORD;
end

% save matlab variable
fname = datafile;
grname   = sprintf('%s/%s_%s_LINESEGRECORD%04u',SAVEPATH,fname,paradigm,TrialRecord.CurrentTrialNumber);
save(grname,'LINESEGRECORD'); 
  

end