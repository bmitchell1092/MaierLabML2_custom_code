function genImageRecordML2(paradigm, TrialRecord)
%generate variable that pre-sets grating parameters for n number of trials

global IMAGERECORD SAVEPATH prespertr datafile IMAGEPATH
scrsize = getCoord;  

params.eye          = 1; % 1 = Both, 2 = R, 3 = L
params.rf           = [-1.1, -1.2]; % [0, 0] for humans
params.scale        = 1.3; % 10 for humans % in visual degrees (Xsize, Ysize)
params.left_xpos    = (-0.25*scrsize(1)+params.rf(1));   % Left eye x-coordinate
params.right_xpos   = (0.25*scrsize(1)+params.rf(1));   % Right eye x-coordinate

oldIMAGERECORD = IMAGERECORD;
IMAGERECORD = [];

switch paradigm
   
    case 'natdisparity_abs' 
        img_num = 1:2;
        cond     = [1];
        scramble = [0,1];
        ori = [0];
        xshift = [-0.5:0.25:0.5]; % Constant to add to dominant-eye x-coordinates
        
        prespertr = 3;
        mintr = 15;
        all_con  = combvec(cond,img_num,xshift,scramble,ori); %all possible conditions of the parameters that vary
        minpres = mintr* length(all_con); % total number of presentations at 10 per loc
        minntrs = floor(minpres/prespertr);   % number of trials
        
        fprintf('\nThe number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters ffileID = fopen(filename,'r');or stimulus
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
            IMAGERECORD(tr).image_num              = all_con(2,shuflocs((theseid)));
            IMAGERECORD(tr).image_xshift          = all_con(3,shuflocs((theseid)));
            IMAGERECORD(tr).image_scramble        = all_con(4,shuflocs((theseid)));
            IMAGERECORD(tr).image_xpos_L          = repmat(params.left_xpos,prespertr,1)';
            IMAGERECORD(tr).image_xpos_R          = repmat(params.right_xpos,prespertr,1)';
            IMAGERECORD(tr).image_ypos            = repmat(params.rf(2),prespertr,1)';
            IMAGERECORD(tr).image_ori             = all_con(5,shuflocs((theseid)));
            IMAGERECORD(tr).image_scale           = params.scale;          
            IMAGERECORD(tr).timestamp             = clock;
            IMAGERECORD(tr).image_isi             = 500; %interstimulus interval
            IMAGERECORD(tr).image_stimdur         = 250; %stim duration
            IMAGERECORD(tr).dom_eye               = params.DE;
        end
        
     case 'natdisparity_rel' 
        img_num = 1:2;
        cond     = [2];
        scramble = [0,1];
        ori = [0];
        prespertr = 3;
        mintr = 15; 
        all_con  = combvec(cond,img_num,scramble,ori); %all possible conditions of the parameters that vary
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
            IMAGERECORD(tr).image_num              = all_con(2,shuflocs((theseid)));
            IMAGERECORD(tr).image_xshift          = zeros(prespertr,1)';
            IMAGERECORD(tr).image_scramble        = all_con(3,shuflocs((theseid)));
            IMAGERECORD(tr).image_xpos_L          = repmat(params.left_xpos,prespertr,1)';
            IMAGERECORD(tr).image_xpos_R          = repmat(params.right_xpos,prespertr,1)';
            IMAGERECORD(tr).image_ypos            = repmat(params.rf(2),prespertr,1)';
            IMAGERECORD(tr).image_ori             = all_con(4,shuflocs((theseid)));
            IMAGERECORD(tr).image_scale        = repmat(params.scale,prespertr,1)';
            IMAGERECORD(tr).timestamp             = clock;
            IMAGERECORD(tr).image_isi             = 500; %interstimulus interval
            IMAGERECORD(tr).image_stimdur         = 250; %stim duration
            IMAGERECORD(tr).dom_eye               = params.DE;
        end
        
    case 'natdisparity'
        img_num = 1:2;
        cond     = [1,2];
        scramble = [0,1];
        ori = [0];
        xshift = [-0.5:0.25:0.5]; % Constant to add to dominant-eye x-coordinates
        prespertr = 3;
        mintr = 15;
        all_con  = combvec(cond,img_num,xshift,scramble,ori); %all possible conditions of the parameters that vary
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
            IMAGERECORD(tr).image_num             = all_con(2,shuflocs((theseid)));
            IMAGERECORD(tr).image_xshift          = all_con(3,shuflocs((theseid)));
            IMAGERECORD(tr).image_scramble        = all_con(4,shuflocs((theseid)));
            IMAGERECORD(tr).image_xpos_L          = repmat(params.left_xpos,prespertr,1)';
            IMAGERECORD(tr).image_xpos_R          = repmat(params.right_xpos,prespertr,1)';
            IMAGERECORD(tr).image_ypos            = repmat(params.rf(2),prespertr,1)';
            IMAGERECORD(tr).image_ori             = all_con(5,shuflocs((theseid)));
            IMAGERECORD(tr).image_scale           = repmat(params.scale,prespertr,1)';
            IMAGERECORD(tr).timestamp             = clock;
            IMAGERECORD(tr).image_isi             = 500; %interstimulus interval
            IMAGERECORD(tr).image_stimdur         = 300; %stim duration
            IMAGERECORD(tr).rf_x                  = params.rf(1); % RF x-pos (determined by dotmapping)
            IMAGERECORD(tr).rf_y                  = params.rf(2); % RF y-pos (determined by dotmapping)
        end
        
        
    case 'natstereo'
        
        cd(strcat(IMAGEPATH,'\L_image\'))
        img_files = dir; img_files(1:2) = [];
        totfiles = length(img_files);
        
        img_num = 1:totfiles;
        cond     = [1,2];
        scramble = [0,1];
        ori = [0];
        xshift = [0]; % Constant to add to one of the eye's x-coordinate
        yshift = [0]; 
        
        prespertr = 3;
        mintr = 15;
        all_con  = combvec(img_num,cond,scramble,ori); %all possible conditions of the parameters that vary
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
            IMAGERECORD(tr).header          = paradigm;
            IMAGERECORD(tr).num             = all_con(1,shuflocs((theseid)));
            IMAGERECORD(tr).xpos_L          = repmat(params.left_xpos,prespertr,1)';
            IMAGERECORD(tr).xpos_R          = repmat(params.right_xpos,prespertr,1)';
            IMAGERECORD(tr).ypos_L          = repmat(params.rf(2),prespertr,1)';
            IMAGERECORD(tr).ypos_R          = repmat(params.rf(2),prespertr,1)';
            IMAGERECORD(tr).eye             = repmat(params.eye,prespertr,1)';
            IMAGERECORD(tr).condition       = all_con(2,shuflocs((theseid)));
            IMAGERECORD(tr).shifted_eye     = nan;
            IMAGERECORD(tr).x_disparity     = repmat(xshift,prespertr,1)';
            IMAGERECORD(tr).y_disparity     = repmat(yshift,prespertr,1)';
            IMAGERECORD(tr).scramble        = all_con(3,shuflocs((theseid)));
            IMAGERECORD(tr).ori             = all_con(4,shuflocs((theseid)));
            IMAGERECORD(tr).scale           = params.scale;
            IMAGERECORD(tr).timestamp       = clock;
            IMAGERECORD(tr).isi             = 500; %interstimulus interval
            IMAGERECORD(tr).stimdur         = 250; %stim duration
            IMAGERECORD(tr).rf_x            = params.rf(1); % RF x-pos (determined by dotmapping)
            IMAGERECORD(tr).rf_y            = params.rf(2); % RF y-pos (determined by dotmapping)
        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% combine with previous GLOBAL if needed
if ~isempty(oldIMAGERECORD)
    IMAGERECORD = [oldIMAGERECORD IMAGERECORD];
    clear oldIMAGERECORD;
end

% save matlab variable
fname = datafile;
grname   = sprintf('%s/%s_IMAGERECORD%04u',SAVEPATH,fname,TrialRecord.CurrentTrialNumber);
save(grname,'IMAGERECORD'); 
  
end
