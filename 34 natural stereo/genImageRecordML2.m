function genImageRecordML2(paradigm, TrialRecord)
%generate variable that pre-sets grating parameters for n number of trials

global IMAGERECORD SAVEPATH prespertr datafile
scrsize = getCoord;  

params.DE           = 2;
params.rf           = [-2, -3];
params.diameter     = 2;
params.left_xpos    = (-0.25*scrsize(1)+params.rf(1));   % Left eye x-coordinate
params.right_xpos   = (0.25*scrsize(1)+params.rf(1));   % Right eye x-coordinate

oldIMAGERECORD = IMAGERECORD;
IMAGERECORD = [];

switch paradigm
   
    case 'natdisparity_abs' 
        img_id = 1:2;
        cond     = [1];
        scramble = [0,1];
        ori = [0];
        xshift = [-0.5:0.25:0.5]; % Constant to add to dominant-eye x-coordinates
        
        prespertr = 3;
        mintr = 15;
        all_con  = combvec(cond,img_id,xshift,scramble,ori); %all possible conditions of the parameters that vary
        minpres = mintr* length(all_con); % total number of presentations at 10 per loc
        minntrs = floor(minpres/prespertr);   % number of trials
        
        fprintf('\nThe number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        rng shuffle
        shuflocs = []; idx = 1:length(all_con);
        for i = 1:mintr
            shuflocs = [shuflocs uShuffle(idx)];
        end
        idxtr = 1;
        theseid = [1:prespertr];
        
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            IMAGERECORD(tr).header                = paradigm;
            IMAGERECORD(tr).condition             = all_con(1,shuflocs((theseid)));
            IMAGERECORD(tr).image_id              = all_con(2,shuflocs((theseid)));
            IMAGERECORD(tr).image_xshift          = all_con(3,shuflocs((theseid)));
            IMAGERECORD(tr).image_scramble        = all_con(4,shuflocs((theseid)));
            IMAGERECORD(tr).image_xpos_L          = repmat(params.left_xpos,prespertr,1)';
            IMAGERECORD(tr).image_xpos_R          = repmat(params.right_xpos,prespertr,1)';
            IMAGERECORD(tr).image_ypos            = repmat(params.rf(2),prespertr,1)';
            IMAGERECORD(tr).image_ori             = all_con(5,shuflocs((theseid)));
            IMAGERECORD(tr).image_diameter        = repmat(params.diameter,prespertr,1)';          
            IMAGERECORD(tr).timestamp             = clock;
            IMAGERECORD(tr).image_isi             = 500; %interstimulus interval
            IMAGERECORD(tr).image_stimdur         = 250; %stim duration
            IMAGERECORD(tr).dom_eye               = params.DE;
        end
        
     case 'natdisparity_rel' 
        img_id = 1:2;
        cond     = [2];
        scramble = [0,1];
        ori = [0];
        prespertr = 3;
        mintr = 15; 
        all_con  = combvec(cond,img_id,scramble,ori); %all possible conditions of the parameters that vary
        minpres = mintr* length(all_con); % total number of presentations at 10 per loc
        minntrs = floor(minpres/prespertr);   % number of trials
        
        fprintf('\nThe number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        rng shuffle
        shuflocs = []; idx = 1:length(all_con);
        for i = 1:mintr
            shuflocs = [shuflocs uShuffle(idx)];
        end
        idxtr = 1;
        theseid = [1:prespertr];
        
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            IMAGERECORD(tr).header                = paradigm;
            IMAGERECORD(tr).condition             = all_con(1,shuflocs((theseid)));
            IMAGERECORD(tr).image_id              = all_con(2,shuflocs((theseid)));
            IMAGERECORD(tr).image_xshift          = zeros(prespertr,1)';
            IMAGERECORD(tr).image_scramble        = all_con(3,shuflocs((theseid)));
            IMAGERECORD(tr).image_xpos_L          = repmat(params.left_xpos,prespertr,1)';
            IMAGERECORD(tr).image_xpos_R          = repmat(params.right_xpos,prespertr,1)';
            IMAGERECORD(tr).image_ypos            = repmat(params.rf(2),prespertr,1)';
            IMAGERECORD(tr).image_ori             = all_con(4,shuflocs((theseid)));
            IMAGERECORD(tr).image_diameter        = repmat(params.diameter,prespertr,1)';          
            IMAGERECORD(tr).timestamp             = clock;
            IMAGERECORD(tr).image_isi             = 500; %interstimulus interval
            IMAGERECORD(tr).image_stimdur         = 250; %stim duration
            IMAGERECORD(tr).dom_eye               = params.DE;
        end

    case 'natdisparity_all'
        img_id = 1:2;
        cond     = [1,2];
        scramble = [0,1];
        ori = [0];
        xshift = [-0.5:0.25:0.5]; % Constant to add to dominant-eye x-coordinates
        prespertr = 3;
        mintr = 15;
        all_con  = combvec(cond,img_id,xshift,scramble,ori); %all possible conditions of the parameters that vary
        minpres = mintr* length(all_con); % total number of presentations at 10 per loc
        minntrs = floor(minpres/prespertr);   % number of trials
        
        fprintf('\nThe number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        rng shuffle
        shuflocs = []; idx = 1:length(all_con);
        for i = 1:mintr
            shuflocs = [shuflocs uShuffle(idx)];
        end
        idxtr = 1;
        theseid = [1:prespertr];
        
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            IMAGERECORD(tr).header                = paradigm;
            IMAGERECORD(tr).condition             = all_con(1,shuflocs((theseid)));
            IMAGERECORD(tr).image_id              = all_con(2,shuflocs((theseid)));
            IMAGERECORD(tr).image_xshift          = all_con(3,shuflocs((theseid)));
            IMAGERECORD(tr).image_scramble        = all_con(4,shuflocs((theseid)));
            IMAGERECORD(tr).image_xpos_L          = repmat(params.left_xpos,prespertr,1)';
            IMAGERECORD(tr).image_xpos_R          = repmat(params.right_xpos,prespertr,1)';
            IMAGERECORD(tr).image_ypos            = repmat(params.rf(2),prespertr,1)';
            IMAGERECORD(tr).image_ori             = all_con(5,shuflocs((theseid)));
            IMAGERECORD(tr).image_diameter        = repmat(params.diameter,prespertr,1)';          
            IMAGERECORD(tr).timestamp             = clock;
            IMAGERECORD(tr).image_isi             = 500; %interstimulus interval
            IMAGERECORD(tr).image_stimdur         = 250; %stim duration
            IMAGERECORD(tr).dom_eye               = params.DE;
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
