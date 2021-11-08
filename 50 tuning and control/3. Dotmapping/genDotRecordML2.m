function genDotRecordML2(TrialRecord)
%generate variable that pre-sets grating parameters for n number of trials

global DOTRECORD SAVEPATH GABOR npres datafile params
params.eye            =  [2,3]; % can have several inputs here
params.theta          =  180:10:270; % around 320 -30:5:10; 200:10:250;
params.eccentricities =  1.5:1:5.5;
params.contrast       =  0.8; % must be scaler! edit g
GABOR                 =  1; % must be scaler! 
oldDOTRECORD = DOTRECORD;
DOTRECORD = [];
fprintf('n conditions %u\n',length(params.eccentricities)*length(params.theta)); 

all_con               = combvec(params.theta,params.eccentricities,params.eye); 

minpres = 15;                                   % total number of presentations at each loc
npres   = 5;                                    % number of dot presentations per trial
minntrs = size(all_con,2)*minpres ./ (npres);    %minpres/npres; % number of trials

fprintf('The number of trials will be %d with %d presentations per trial.\n',minntrs,npres); 

noshuf = 0; % if you don't want to shuffle dot positions set to 1
idxtr = 1; 

if ~noshuf
shuflocs = randi([1 size(all_con,2)],(size(all_con,2)*minpres),1); 
else
 shuflocs = [1:(size(all_con,2)*minpres)]';    
end
for tr = 1:minntrs
    theseid = [((tr-1)*npres + 1):((tr-1)*npres + npres)]; 
    
        [x,y] = pol2cart(deg2rad(all_con(1,shuflocs(theseid))),all_con(2,shuflocs(theseid)));
 
    DOTRECORD(tr).dot_xpos         = ceil(x*100)./100;
    DOTRECORD(tr).dot_ypos         = ceil(y*100)./100;
    DOTRECORD(tr).dot_contrast     = repmat(params.contrast,npres,1)'; 
    DOTRECORD(tr).dot_eye          = all_con(3,shuflocs(theseid)); 
 clear x y 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% combine with previous GLOBAL if needed
if ~isempty(oldDOTRECORD)
    DOTRECORD = [oldDOTRECORD DOTRECORD];
    clear oldDOTRECORD;
end

% save matlab variable
fname = datafile;
grname   = sprintf('%s/%s_DOTRECORD%04u',SAVEPATH,fname,TrialRecord.CurrentTrialNumber);
save(grname,'DOTRECORD'); 
  
end
