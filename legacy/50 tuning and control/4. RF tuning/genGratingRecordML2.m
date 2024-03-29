function genGratingRecordML2(paradigm,TrialRecord)

% choose paradigm: fori,rfsize,rfsf,contrastresp,cinteroc,cosinteroc,ss
% generate global variable that pre-sets grating parameters for n number of trials

% Note by BM: GRATINGRECORD is exactly as it was, with two additions: 1)
% .tf (temporal frequency) and 2) .stereo_xpos

global GRATINGRECORD SAVEPATH datafile params prespertr
oldGRATINGRECORD = GRATINGRECORD; 
GRATINGRECORD = []; scrsize = getCoord;
clear params   

% Default parameters
params.rf              = [5 -5];
params.diameters       = 1.5;   % Diameter in degrees
params.contrasts       = 0.9;  % Michelson contrast
params.spatial_freq    = 2;    % cycles per degree
params.temporal_freq   = 0;    % cycles per second
params.orientations    = 90;   % preferred orientation--remember 0 deg is vertical orientation, 90 deg is horizontal,  NAN makes RN patch
params.phase           = 0;    % phase angle of grating
                                    
params.stereo_xpos     = [-0.25*scrsize(1)+params.rf(1) 0.25*scrsize(1)+params.rf(1)]; % enter x position (1st element--LEFT eye, 2nd--RIGHT eye)
params.xpos            = [params.rf(1) params.rf(1)];     % enter x position (1st element--LEFT eye, 2nd--RIGHT eye)
params.ypos            = [params.rf(2) params.rf(2)];     % enter y posit

% legacy parameters
params.varyeye = nan;
params.fixedc = nan;

% Task-specific GRATINGRECORD 
switch paradigm
   
    case 'rfori' 

        % parameters to vary:
        params.orientations = 0:11.25:168.75; % degrees
        params.eye = [1,2,3];
        
        mintr = 12; 
        all_con  = combvec(params.orientations,params.eye,params.phase); %all possible conditions of the parameters that vary
        minpres = mintr* size(all_con,2); % total number of presentations at 10 per loc
        minntrs = floor(minpres/prespertr);   % number of trials
        
        fprintf('\nThe number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        shuflocs = randi([1 size(all_con,2)],minpres,1);

        GRATINGRECORD = struct; 
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt          = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_eye           = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_phase         = all_con(3,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_sf            = repmat(params.spatial_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_tf            = repmat(params.temporal_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast      = repmat(params.contrasts,prespertr,1)';
            GRATINGRECORD(tr).grating_diameter      = repmat(params.diameters,prespertr,1)';
            GRATINGRECORD(tr).grating_xpos          = repmat(params.xpos,prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos          = repmat(params.ypos,prespertr,1)';
            GRATINGRECORD(tr).header                = 'rfori';
            GRATINGRECORD(tr).timestamp             = clock;
            GRATINGRECORD(tr).grating_varyeye       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_fixedc        = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_oridist       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 200; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 400; %stim interval
            GRATINGRECORD(tr).path                  = zeros(1,3); % achromatic
        end
        
    case 'rforiDRFT'

        % parameters to vary:
        params.orientations = 0:11.25:168.75; % degrees
        params.eye = [1,2,3]; % this should be both eyes, right eye, or left eye
        params.temporal_freq = 8;
        
        mintr = 12;
        all_con  = combvec(params.orientations,params.eye,params.phase); %all possible conditions of the parameters that vary
        minpres = mintr* size(all_con,2); % total number of presentations at 10 per loc
        minntrs = floor(minpres/prespertr);   % number of trials
        
        fprintf('\nThe number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus     
        shuflocs = randi([1 size(all_con,2)],minpres,1);
        
        GRATINGRECORD = struct; 
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt          = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_eye           = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_phase         = all_con(3,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_sf            = repmat(params.spatial_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_tf            = repmat(params.temporal_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast      = repmat(params.contrasts,prespertr,1)';
            GRATINGRECORD(tr).grating_diameter      = repmat(params.diameters,prespertr,1)';
            GRATINGRECORD(tr).grating_xpos          = repmat(params.xpos,prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos          = repmat(params.ypos,prespertr,1)';
            GRATINGRECORD(tr).header                = 'rforiDRFT';
            GRATINGRECORD(tr).timestamp             = clock;
            GRATINGRECORD(tr).grating_varyeye       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_fixedc        = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_oridist       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 200; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 400; %stim interval
            GRATINGRECORD(tr).blankLikelihood       = 0.15;
            GRATINGRECORD(tr).path                  = zeros(1,3); % achromatic
        end
        
    case 'rfsize'

        params.diameters     = [logspace(log10(.5),log10(6),7)];
        params.eye           = 1; 
        
        all_con               = combvec(params.diameters,params.eye,params.phase); %all possible conditions of the parameters that vary      
        npres   = 15;
        minpres = npres* size(all_con,2); % total number of presentations per condition
        minntrs = minpres/prespertr;      % number of trials
        
        fprintf('The number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus     
        shuflocs = randi([1 size(all_con,2)],minpres,1);

        GRATINGRECORD = struct;
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt          = repmat(params.orientations,prespertr,1)';
            GRATINGRECORD(tr).grating_eye           = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_sf            = repmat(params.spatial_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_tf            = repmat(params.temporal_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast      = repmat(params.contrasts,prespertr,1)';
            GRATINGRECORD(tr).grating_phase         = all_con(3,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_diameter      = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_xpos          = repmat(params.xpos,prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos          = repmat(params.ypos,prespertr,1)';
            GRATINGRECORD(tr).header                = 'rfsize';
            GRATINGRECORD(tr).timestamp             = clock;
            GRATINGRECORD(tr).grating_varyeye       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_fixedc        = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_oridist       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 200; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 300; % stimdur
            GRATINGRECORD(tr).path                  = zeros(1,3); % achromatic
        end
        
        
    case 'rfsf'

        params.eye = 1;
        %vary:
        params.spatial_freq =  1./logspace(log10(0.5),log10(4),4);%[0.05 0.1 0.2 0.4 0.8 1];
        all_con  = combvec(params.spatial_freq,params.eye,params.phase); %all possible conditions of the paramters that vary
        
        mintr = 15; 
        minpres = mintr* size(all_con,2); % total number of presentations per condition
        minntrs = minpres/prespertr;      % number of trials
        
        fprintf('The number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        shuflocs = randi([1 size(all_con,2)],minpres,1);
        
        GRATINGRECORD = struct();
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr+ 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt          = repmat(params.orientations, prespertr,1)';
            GRATINGRECORD(tr).grating_eye           = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_sf            = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_tf            = repmat(params.temporal_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast      = repmat(params.contrasts, prespertr,1)';
            GRATINGRECORD(tr).grating_phase         = all_con(3,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_diameter      = repmat(params.diameters, prespertr,1)';
            GRATINGRECORD(tr).grating_xpos          = repmat(params.xpos, prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos          = repmat(params.ypos, prespertr,1)';
            GRATINGRECORD(tr).header                = 'rfsf';
            GRATINGRECORD(tr).timestamp             = clock;
            GRATINGRECORD(tr).grating_varyeye       = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_fixedc        = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_oridist       = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 200; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 300; %interstimulus interval
            GRATINGRECORD(tr).path                  = zeros(1,3); % achromatic
            
        end
        
    case 'rfphase'

        %vary:
        params.eye = 1;
        params.phase = [0:45:180]; 
        all_con  = combvec(params.eye,params.phase); %all possible conditions of the paramters that vary
        
        mintr = 15;
        minpres = mintr* size(all_con,2); % total number of presentations per condition
        minntrs = minpres/prespertr;      % number of trials
        
        fprintf('The number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        shuflocs = randi([1 size(all_con,2)],minpres,1);
        
        GRATINGRECORD = struct;
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr+ 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt          = repmat(params.orientations, prespertr,1)';
            GRATINGRECORD(tr).grating_eye           = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_sf            = repmat(params.spatial_freq, prespertr,1)';
            GRATINGRECORD(tr).grating_tf            = repmat(params.temporal_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast      = repmat(params.contrasts, prespertr,1)';
            GRATINGRECORD(tr).grating_phase         = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_diameter      = repmat(params.diameters, prespertr,1)';
            GRATINGRECORD(tr).grating_xpos          = repmat(params.xpos, prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos          = repmat(params.ypos, prespertr,1)';
            GRATINGRECORD(tr).header                = 'rfphase';
            GRATINGRECORD(tr).timestamp             = clock;
            GRATINGRECORD(tr).grating_varyeye       = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_fixedc        = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_oridist       = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 200; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 300; %interstimulus interval
            GRATINGRECORD(tr).path                  = zeros(1,3); % achromatic
            
        end
        
        
    case 'phzdisparity'

        %vary:
        params.phase_L = [0:90:270];
        params.phase_R = [0:90:270];
        params.temporal_freq = .75;
        params.eye = 1;
        all_con  = combvec(params.eye,params.phase_L,params.phase_R); %all possible conditions of the paramters that vary
        
        mintr = 15;
        minpres = mintr* length(all_con); % total number of presentations per condition
        minntrs = minpres/prespertr;      % number of trials
        
        fprintf('The number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        shuflocs = randi([1 length(all_con)],minpres,1);
        
        GRATINGRECORD = struct;
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr+ 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt          = repmat(params.orientations, prespertr,1)';
            GRATINGRECORD(tr).grating_eye           = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_sf            = repmat(params.spatial_freq, prespertr,1)';
            GRATINGRECORD(tr).grating_tf            = repmat(params.temporal_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast      = repmat(params.contrasts, prespertr,1)';
            GRATINGRECORD(tr).grating_phase         = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_phase_L       = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_phase_R       = all_con(3,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_diameter      = repmat(params.diameters, prespertr,1)';
            GRATINGRECORD(tr).grating_xpos          = repmat(params.xpos, prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos          = repmat(params.ypos, prespertr,1)';
            GRATINGRECORD(tr).header                = 'phzdisparity';
            GRATINGRECORD(tr).timestamp             = clock;
            GRATINGRECORD(tr).grating_varyeye       = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_fixedc        = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_oridist       = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 300; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 300; %interstimulus interval
            GRATINGRECORD(tr).path                  = zeros(1,3); % achromatic
            
        end
        
    case 'posdisparity'
   
        %vary:
        posdist = [-0.5:0.25:0.5]; % positition shift
        params.temporal_freq = .75;
        params.eye = [2,3];
        all_con  = combvec(params.eye,posdist); %all possible conditions of the paramters that vary, added eye so that it alternates between which eye is shifted
        
        mintr = 15;
        minpres = mintr* length(all_con); % total number of presentations per condition
        minntrs = minpres/prespertr;      % number of trials
        
        fprintf('The number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        shuflocs = randi([1 length(all_con)],minpres,1);
        
        GRATINGRECORD = struct;
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr+ 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt          = repmat(params.orientations, prespertr,1)';
            GRATINGRECORD(tr).grating_eye           = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_sf            = repmat(params.spatial_freq, prespertr,1)';
            GRATINGRECORD(tr).grating_tf            = repmat(params.temporal_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast      = repmat(params.contrasts, prespertr,1)';
            GRATINGRECORD(tr).grating_phase         = repmat(params.phase, prespertr,1);
            GRATINGRECORD(tr).grating_diameter      = repmat(params.diameters, prespertr,1)';
            GRATINGRECORD(tr).grating_xpos          = repmat(params.xpos, prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos          = repmat(params.ypos, prespertr,1)';
            GRATINGRECORD(tr).grating_posdist       = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_phzdist       = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).header                = 'posdisparity';
            GRATINGRECORD(tr).timestamp             = clock;
            GRATINGRECORD(tr).grating_varyeye       = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_fixedc        = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_oridist       = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan, prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 300; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 300; %interstimulus interval
            GRATINGRECORD(tr).path                  = zeros(1,3); % achromatic
            
        end
        
        
     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % % % % % % % % %  BEGIN Experimental Tassks % % % % % % % % % % % % % 
     % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    case 'cinteroc'

        %vary:
        params.contrasts  = [0 logspace(log10(.05),log10(1),5)];
        params.fixedc     = [0 logspace(log10(.05),log10(1),5)]; % contrast for second eye
       
        all_con  = combvec(params.contrasts,params.eye,params.fixedc,params.phase); %all possible conditions of the paramters that vary
        
        mintr = 30;
        minpres = mintr* length(all_con); % total number of presentations at 10 per loc
        
        minntrs = minpres/prespertr;           % number of trials
        
        fprintf('The number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        
        shuflocs = randi([1 length(all_con)],minpres,1);
        GRATINGRECORD = struct;
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt         = repmat(params.orientations,prespertr,1)';
            GRATINGRECORD(tr).grating_eye          = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_varyeye      = repmat(params.varyeye,prespertr,1)';
            GRATINGRECORD(tr).grating_sf           = repmat(params.spatial_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_tf           = repmat(params.temporal_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast     = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_phase        = all_con(4,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_fixedc       = all_con(3,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_diameter     = repmat(params.diameters,prespertr,1)';
            GRATINGRECORD(tr).grating_xpos         = repmat(params.xpos,prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos         = repmat(params.ypos,prespertr,1)';
            GRATINGRECORD(tr).header               = 'cinteroc';
            GRATINGRECORD(tr).timestamp            = clock;
            GRATINGRECORD(tr).grating_oridist       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 300; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 300; %stimulus duration
            GRATINGRECORD(tr).path                  = zeros(1,3); % 0 = ach, 1 = S_cone
            
        end
        
    case 'bminteroc'

        %vary:       
        params.contrasts  = [0 0.055 0.11 0.225 0.45 0.90];
        params.fixedc     = [0 0.055 0.11 0.225 0.45 0.90]; % contrast for second eye
        params.eye = nan;  % this is nan here due to having zero contrast above
        params.phase = 0;
        
        all_con  = combvec(params.contrasts,params.eye,params.fixedc,params.phase); %all possible conditions of the paramters that vary
        
        mintr = 30;
        minpres = mintr* size(all_con,2); % total number of presentations at 10 per loc
        
        minntrs = minpres/prespertr; % number of trials
        
        fprintf('The number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus       
        shuflocs = randi([1 size(all_con,2)],minpres,1);
        
        GRATINGRECORD = struct;
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt         = repmat(params.orientations,prespertr,1)';
            GRATINGRECORD(tr).grating_eye          = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_varyeye      = repmat(params.varyeye,prespertr,1)';
            GRATINGRECORD(tr).grating_sf           = repmat(params.spatial_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_tf           = repmat(params.temporal_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast     = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_phase        = all_con(4,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_fixedc       = all_con(3,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_diameter     = repmat(params.diameters,prespertr,1)';
            GRATINGRECORD(tr).grating_xpos         = repmat(params.xpos,prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos         = repmat(params.ypos,prespertr,1)';
            GRATINGRECORD(tr).header               = 'bminteroc';
            GRATINGRECORD(tr).timestamp            = clock;
            GRATINGRECORD(tr).grating_oridist       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 300; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 350; %stimulus duration
            GRATINGRECORD(tr).path                  = zeros(1,3); % achromatic
            
        end
        
    case 'mcosinteroc'
        % MAC, Dec 8th
        
        %vary:
        params.contrasts    = [0.9 0.45 0.225 0];  % choose  contrast
        params.fixedc       = params.contrasts;
        params.eye          = [2 3];  %enter both eyes so that preferred grating swaps between ND and D eye
        params.oridist      = [0 90]; % distance (in deg) between one eye grating and other eye grating//for dichoptic just run 90 deg seperation
        new_tilt            = uCalcTilts0to179(params.orientations, 90);
        params.orientations = [new_tilt params.orientations];

        
        
        all_con  = combvec(params.orientations,params.oridist,params.contrasts,params.fixedc,params.eye,params.phase); %all possible conditions of the paramters that vary
        % remove blanks
        remove = all_con(3,:)==0 & all_con(4,:) == 0;
        all_con(:,remove) = [];
        % remove non-monocular 0.225 contrasts
                remove = all_con(3,:) > 0 & all_con(4,:) == 0.225;
                all_con(:,remove) = [];
                remove = all_con(3,:)== 0.225 & all_con(4,:) > 0;
                all_con(:,remove) = [];
        
        mintr = 20;
        minpres = mintr* length(all_con); % total number of presentations at 10 per loc
        minntrs = floor(minpres/prespertr);   % number of trials
        
        fprintf('The number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus     
        shuflocs = randi([1 length(all_con)],minpres,1);
        
        GRATINGRECORD = struct;
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt          = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_oridist       = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_eye           = all_con(5,shuflocs((theseid))); % this is the eye that see the preferred grating
            GRATINGRECORD(tr).grating_varyeye       = nan(prespertr,1)';
            GRATINGRECORD(tr).grating_sf            = repmat(params.spatial_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_tf           = repmat(params.temporal_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast      = all_con(3,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_phase         =  all_con(6,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_fixedc        = all_con(4,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_diameter      = repmat(params.diameters,prespertr,1)';         
            GRATINGRECORD(tr).grating_xpos          = repmat(params.xpos,prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos          = repmat(params.ypos,prespertr,1)';
            GRATINGRECORD(tr).header                = 'mcosinteroc';
            GRATINGRECORD(tr).timestamp             = clock;
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 500; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 250;
            GRATINGRECORD(tr).path                  = zeros(1,3); % achromatic
            
        end
        
    case 'bcosinteroc' % im treating grating_tilt as the left
        % BM, 2021 Oct
        
        %vary:
        params.contrasts    = [0 0.055 0.11 0.225 0.45 0.90];  % choose  contrast
        params.fixedc       = params.contrasts;
        params.eye          = NaN;  % this is taken care of
        params.oridist      = [0 90]; % distance (in deg) between one eye grating and other eye grating//for dichoptic just run 90 deg seperation
        new_tilt            = uCalcTilts0to179(params.orientations, 90);
        params.orientations(2) = new_tilt;
  
        all_con  = combvec(params.orientations,params.oridist,params.contrasts,params.fixedc,params.eye,params.phase); %all possible conditions of the paramters that vary
        % remove blanks
        remove = all_con(3,:)==0 & all_con(4,:) == 0;
        all_con(:,remove) = [];
        
        mintr = 20;
        minpres = mintr* length(all_con); % total number of presentations at 10 per loc
        minntrs = floor(minpres/prespertr);   % number of trials
        
        fprintf('The number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus       
        shuflocs = randi([1 length(all_con)],minpres,1);

        GRATINGRECORD = struct;
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt          = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_oridist       = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_eye           = all_con(5,shuflocs((theseid))); % this is the eye that see the preferred grating
            GRATINGRECORD(tr).grating_varyeye       = nan(prespertr,1)';
            GRATINGRECORD(tr).grating_sf            = repmat(params.spatial_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_tf           = repmat(params.temporal_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast      = all_con(3,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_phase         =  all_con(6,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_fixedc        = all_con(4,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_diameter      = repmat(params.diameters,prespertr,1)';
            GRATINGRECORD(tr).grating_xpos          = repmat(params.xpos,prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos          = repmat(params.ypos,prespertr,1)';
            GRATINGRECORD(tr).header                = 'mcosinteroc';
            GRATINGRECORD(tr).timestamp             = clock;
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 500; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 250;
            GRATINGRECORD(tr).path                  = zeros(1,3); % achromatic
            
        end
        
        
    case 'cosinteroc'
        
        %vary:
        params.contrasts  = [params.contrast([4 6])]; % 3 contrast levels, 1 at 0
        params.fixedc     = params.contrasts;
        params.eye        = [2 3];  %enter both eyes so that preferred grating swaps between ND and D eye
        params.oridist    = [90]; % distance (in deg) between one eye grating and other eye grating//for dichoptic just run 90 deg seperation
        
        all_con  = combvec(params.oridist,params.contrasts,params.fixedc,params.eye,params.phase); %all possible conditions of the paramters that vary
        % dibinoc = intersect(find(all_con(4,:) == 1),find(all_con(1,:) == 90));
        % all_con(:,dibinoc) = [];
        
        mintr = 15;
        minpres = mintr* size(all_con,2); % total number of presentations
        
        minntrs = minpres/prespertr;           % number of trials
        
        fprintf('The number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        shuflocs = randi([1 size(all_con,2)],minpres,1);

        GRATINGRECORD = struct;
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt          = repmat(params.orientations,prespertr,1)';
            GRATINGRECORD(tr).grating_oridist       = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_eye           = all_con(4,shuflocs((theseid))); % this is the eye that see the preferred grating
            GRATINGRECORD(tr).grating_varyeye       = nan(prespertr,1)';
            GRATINGRECORD(tr).grating_sf            = repmat(params.spatial_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_tf           = repmat(params.temporal_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast      = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_phase         = all_con(5,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_fixedc        = all_con(3,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_diameter      = repmat(params.diameters,prespertr,1)';
            GRATINGRECORD(tr).grating_xpos          = repmat(params.xpos,prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos          = repmat(params.ypos,prespertr,1)';
            GRATINGRECORD(tr).header                = 'cosinteroc';
            GRATINGRECORD(tr).timestamp             = clock;
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 200; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 200;
            GRATINGRECORD(tr).path                  = zeros(1,3); % achromatic
            
        end
        
    case 'ss'
        
        % there should be 5 conditions: DOM/ND
        % 1) annulus / center grating
        % 2) annulus / nothing
        % 3) center grating / nothing
        % 4) center grating /center grating
        % 5) sum of both center and surround (sum of images) / nothing
        
        
        %vary:
        params.contrasts           = [0.35 0.5];
        params.oridist             = [0 30 60];      %[0:36:90]; % distance (in deg) between one eye grating and other eye grating (SURROUND)
        params.outerdiameter       = [0:0.5:1];      %for mixed gratings-diameter of outside grating (number to add to center grating diameter)
        params.space               = [0 0.5];        %in dva, any space (background color) between center grating and surround? (i.e. make annulus?)
        params.sscond          = [1:5];          % 5 conditions: C only (DE), surround only (DE), C+S (DE), C+S (both), S(ND) and C (DE)
        
        all_con  = combvec(params.oridist,params.contrasts,params.fixedc,params.outerdiameter,params.space,params.sscond); %all possible conditions of the paramters that vary
        mintr = 20;
        minpres = mintr* length(all_con); % total number of presentations at 10 per loc
        
        minntrs = minpres/prespertr;          % number of trials
        
        fprintf('The number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        shuflocs = randi([1 size(all_con,2)],minpres,1);
        
        GRATINGRECORD = struct;    
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt           = repmat(params.orientations,prespertr,1)';
            GRATINGRECORD(tr).grating_oridist        = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_outerdiameter  = all_con(4,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_space          = all_con(5,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_eye            = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_varyeye      = repmat(params.varyeye,prespertr,1)'; % vary will be the eye that gets the surround
            GRATINGRECORD(tr).grating_sf           = repmat(params.spatial_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast     = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_fixedc       = all_con(2,shuflocs((theseid))); % always make contrast level the same between the eyes
            GRATINGRECORD(tr).grating_diameter     = repmat(params.diameters,prespertr,1)';
            GRATINGRECORD(tr).grating_xpos         = repmat(params.xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos         = repmat(params.ypos,prespertr,1)';
            GRATINGRECORD(tr).header               = 'ss';
            GRATINGRECORD(tr).sscond               = all_con(6,shuflocs((theseid)));
            GRATINGRECORD(tr).timestamp            = clock;
            GRATINGRECORD(tr).grating_isi          = 200; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur      = 200; %interstimulus interval
            GRATINGRECORD(tr).path                  = zeros(1,3); % achromatic
        end
        
        
    case 'contrastresp'

        %vary:
        params.contrasts           = [0 0.055 0.11 0.225 0.45 0.90];
        params.eye                 = [1:3];
        
        all_con  = combvec(params.contrasts,params.eye,params.phase); %all possible conditions of the paramters that vary
        mintr = 30;
        minpres = mintr* size(all_con,2); % total number of presentations at 10 per loc
        minntrs = minpres/prespertr;           % number of trials
        
        fprintf('The number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        shuflocs = randi([1 size(all_con,2)],minpres,1);
        
        GRATINGRECORD = struct;
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt         = repmat(params.orientations,prespertr,1)';
            GRATINGRECORD(tr).grating_eye          = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_sf           = repmat(params.spatial_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_tf           = repmat(params.temporal_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast     = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_phase        = all_con(3,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_diameter     = repmat(params.diameters,prespertr,1)';
            GRATINGRECORD(tr).grating_xpos         = repmat(params.xpos,prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos         = repmat(params.ypos,prespertr,1)';
            GRATINGRECORD(tr).header               = 'contrastresp';
            GRATINGRECORD(tr).timestamp            = clock;
            GRATINGRECORD(tr).grating_varyeye      = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_fixedc       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_oridist      = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_outerdiameter      = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_space    = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 500; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 250; %interstimulus interval
            GRATINGRECORD(tr).path                  = zeros(1,3); % achromatic
        end
        
    case 'interocori'
        
        %vary:
        params.oridist = [0 90];
        params.eye     = [1 2 3];
        params.orientations   = 10;
        
        all_con  = combvec(params.oridist,params.eye,params.orientations,params.phase); %all possible conditions of the paramters that vary
        dibinoc = intersect(find(all_con(2,:) == 3),find(all_con(1,:) == 90));
        all_con(:,dibinoc) = [];
        dibinoc = intersect(find(all_con(2,:) == 2),find(all_con(1,:) == 90));
        all_con(:,dibinoc) = [];
        
        mintr = 10;
        minpres = mintr* size(all_con,2); % total number of presentations at 10 per loc
        
        minntrs = minpres/prespertr;           % number of trials
        
        fprintf('The number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        shuflocs = randi([1 size(all_con,2)],minpres,1);
        
        GRATINGRECORD = struct;
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt         = all_con(3,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_eye          = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_varyeye      = nan(prespertr,1)';
            GRATINGRECORD(tr).grating_sf           = repmat(params.spatial_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_tf           = repmat(params.temporal_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast     = repmat(params.contrasts,prespertr,1)';
            GRATINGRECORD(tr).grating_phase        = all_con(4,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_fixedc       = repmat(params.contrasts,prespertr,1)';
            GRATINGRECORD(tr).grating_diameter     = repmat(params.diameters,prespertr,1)';
            GRATINGRECORD(tr).grating_xpos         = repmat(params.xpos,prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos         = repmat(params.ypos,prespertr,1)';
            GRATINGRECORD(tr).header               = 'interocori';
            GRATINGRECORD(tr).timestamp            = clock;
            GRATINGRECORD(tr).grating_oridist       = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 200; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 200; %interstimulus interval
            GRATINGRECORD(tr).path                  = zeros(1,3); % achromatic
            
        end
        
    case 'color'
        
        % NOTE: CONTRAST IS USED TO DEFINE COLOR FOR THIS PARADIGM:
        % ALWAYS RUN AT 100% contrast
        params.path     = [1:4 5:8]; % 1-LM, 2-S, 3-LM opponent, 4-achromatic
        params.contrast = 1;
        
        mintr    = 15;
        all_con  = combvec(params.eye,params.path); %all possible conditions of the parameters that vary
        minpres  = mintr* length(all_con); % total number of presentations at 10 per loc
        minntrs  = floor(minpres/prespertr);   % number of trials
        
        fprintf('\nThe number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        shuflocs = randi([1 size(all_con,2)],minpres,1);
        
        GRATINGRECORD = struct;        
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt          = repmat(params.orientations,prespertr,1)';
            GRATINGRECORD(tr).grating_eye           = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_phase         = repmat(params.phase,prespertr,1)';
            GRATINGRECORD(tr).grating_sf            = repmat(params.spatial_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_tf           = repmat(params.temporal_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast      = repmat(params.contrast,prespertr,1)';
            GRATINGRECORD(tr).grating_diameter      = repmat(params.diameters,prespertr,1)';
            GRATINGRECORD(tr).grating_xpos          = repmat(params.xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos          = repmat(params.ypos,prespertr,1)';
            GRATINGRECORD(tr).header                = 'color';
            GRATINGRECORD(tr).timestamp             = clock;
            GRATINGRECORD(tr).path                  = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_varyeye       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_fixedc        = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_oridist       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan,prespertr,1); %#ok<*RPMTN>
            GRATINGRECORD(tr).grating_space         = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 200; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 200; % ms
            GRATINGRECORD(tr).prespertr             = prespertr;
            GRATINGRECORD(tr).path                  = zeros(1,3); % achromatic
        end
        
    case 'coneOLD'
        
        % parameters to vary:
        % ALWAYS RUN AT 100% contrast
        params.path = [1 2 3 4]; % LM,S,LplusMminus and LminusMplus,MAGNO
        params.eye = 1;
        mintr    = 15;
        all_con  = combvec(params.eye,params.path,params.orientations,params.phase); %all possible conditions of the parameters that vary
        minpres  = mintr* length(all_con); % total number of presentations at 10 per loc
        minntrs  = floor(minpres/prespertr);   % number of trials
        
        fprintf('\nThe number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        shuflocs = randi([1 size(all_con,2)],minpres,1);
        

        GRATINGRECORD = struct; 
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt          = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_eye           = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_phase         = all_con(4,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_sf            = repmat(params.spatial_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast      = repmat(params.contrasts,prespertr,1)';
            GRATINGRECORD(tr).grating_diameter      = repmat(params.diameters,prespertr,1)';
            GRATINGRECORD(tr).grating_xpos          = repmat(params.xpos,prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos          = repmat(params.ypos,prespertr,1)';
            GRATINGRECORD(tr).header                = 'cone';
            GRATINGRECORD(tr).timestamp             = clock;
            GRATINGRECORD(tr).grating_varyeye       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_fixedc        = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_oridist       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 200; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 200; %stim interval
            GRATINGRECORD(tr).path                  = all_con(3,shuflocs((theseid)));
        end
        
        
    case 'cone'
        
        params.path = [0,1]; % 1 = S 
        params.temporal_freq = [8];
        params.contrasts = 0.5; % for achromatic grating
        params.spatial_freq = [0,params.spatial_freq];
        params.eye = 1;
        
        mintr    = 20;
        all_con  = combvec(params.eye,params.spatial_freq,params.temporal_freq,params.contrasts,params.path); %all possible conditions of the parameters that vary
        minpres  = mintr* size(all_con,2); % total number of presentations at 10 per loc
        minntrs  = floor(minpres/prespertr);   % number of trials
        
        fprintf('\nThe number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        shuflocs = randi([1 size(all_con,2)],minpres,1);
        
        GRATINGRECORD = struct;
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt          = repmat(params.orientations,prespertr,1)';
            GRATINGRECORD(tr).grating_eye           = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_phase         = repmat(params.phase,prespertr,1)';
            GRATINGRECORD(tr).grating_sf            = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_tf            = all_con(3,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_contrast      = all_con(4,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_diameter      = repmat(params.diameters,prespertr,1)';
            GRATINGRECORD(tr).grating_xpos          = repmat(params.xpos,prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos          = repmat(params.ypos,prespertr,1)';
            GRATINGRECORD(tr).header                = 's_cone';
            GRATINGRECORD(tr).timestamp             = clock;
            GRATINGRECORD(tr).grating_varyeye       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_fixedc        = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_oridist       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 200; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 400; %stim interval
            GRATINGRECORD(tr).path                  = all_con(5,shuflocs((theseid)));
        end
        
    case 'cpatch'
        
        %vary:
        params.contrasts  = [0 logspace(log10(.05),log10(1),5)];
        params.fixedc     = [0 params.contrasts(3) 1]; % contrast for second eye
        
        all_con  = combvec(params.contrasts,params.eye,params.fixedc); %all possible conditions of the paramters that vary
        
        mintr = 30;
        minpres = mintr* length(all_con); % total number of presentations at 10 per loc
        
        minntrs = minpres/prespertr;           % number of trials
        
        fprintf('The number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        
        shuflocs = randi([1 length(all_con)],minpres,1);

        GRATINGRECORD = struct; 
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt          = repmat(NaN,prespertr,1)';
            GRATINGRECORD(tr).grating_eye           = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_varyeye       = repmat(params.varyeye,prespertr,1)';
            GRATINGRECORD(tr).grating_sf            = repmat(NaN,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast      = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_phase         = repmat(NaN,prespertr,1)';
            GRATINGRECORD(tr).grating_fixedc        = all_con(3,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_diameter      = repmat(params.diameters,prespertr,1)';
            GRATINGRECORD(tr).grating_xpos          = repmat(params.xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos          = repmat(params.ypos,prespertr,1)';
            GRATINGRECORD(tr).header                = 'cpatch';
            GRATINGRECORD(tr).timestamp             = clock;
            GRATINGRECORD(tr).grating_oridist       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 200; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 200; %interstimulus interval
            GRATINGRECORD(tr).path                  = zeros(1,3); % achromatic
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%% FOR LESION STUDY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        case 'rfori4lesions' 

        % parameters to vary:
        params.orientations = 0:11.25:168.75; % degrees
        params.eye = [1,2,3];
        
        mintr = 12; 
        all_con  = combvec(params.orientations,params.eye,params.phase); %all possible conditions of the parameters that vary
        minpres = mintr* size(all_con,2); % total number of presentations at 10 per loc
        minntrs = floor(minpres/prespertr);   % number of trials
        
        fprintf('\nThe number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        shuflocs = randi([1 size(all_con,2)],minpres,1);

        GRATINGRECORD = struct; 
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt          = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_eye           = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_phase         = all_con(3,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_sf            = repmat(params.spatial_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_tf            = repmat(params.temporal_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast      = repmat(params.contrasts,prespertr,1)';
            GRATINGRECORD(tr).grating_diameter      = repmat(params.diameters,prespertr,1)';
            GRATINGRECORD(tr).grating_xpos          = repmat(params.xpos,prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos          = repmat(params.ypos,prespertr,1)';
            GRATINGRECORD(tr).header                = 'rfori4lesions';
            GRATINGRECORD(tr).timestamp             = clock;
            GRATINGRECORD(tr).grating_varyeye       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_fixedc        = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_oridist       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 500; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 500; %stim interval
            GRATINGRECORD(tr).path                  = zeros(1,3); % achromatic
        end
        
    case 'rforiDRFT4lesions'

        % parameters to vary:
        params.orientations = 0:11.25:168.75; % degrees
        params.eye = [1,2,3]; % this should be both eyes, right eye, or left eye
        params.temporal_freq = 8;
        
        mintr = 12;
        all_con  = combvec(params.orientations,params.eye,params.phase); %all possible conditions of the parameters that vary
        minpres = mintr* size(all_con,2); % total number of presentations at 10 per loc
        minntrs = floor(minpres/prespertr);   % number of trials
        
        fprintf('\nThe number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus     
        shuflocs = randi([1 size(all_con,2)],minpres,1);
        
        GRATINGRECORD = struct; 
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt          = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_eye           = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_phase         = all_con(3,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_sf            = repmat(params.spatial_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_tf            = repmat(params.temporal_freq,prespertr,1)';
            GRATINGRECORD(tr).grating_contrast      = repmat(params.contrasts,prespertr,1)';
            GRATINGRECORD(tr).grating_diameter      = repmat(params.diameters,prespertr,1)';
            GRATINGRECORD(tr).grating_xpos          = repmat(params.xpos,prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos          = repmat(params.ypos,prespertr,1)';
            GRATINGRECORD(tr).header                = 'rforiDRFT4lesions';
            GRATINGRECORD(tr).timestamp             = clock;
            GRATINGRECORD(tr).grating_varyeye       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_fixedc        = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_oridist       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 500; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 500; %stim interval
            GRATINGRECORD(tr).blankLikelihood       = 0;
            GRATINGRECORD(tr).path                  = zeros(1,3); % achromatic
        end
        
    case 'cone4lesions'
        
        params.path = [0,1]; % 1 = S
        params.temporal_freq = [8];
        params.contrasts = 0.5; % for achromatic grating
        params.spatial_freq = [0,params.spatial_freq];
        params.eye = 1;
        
        mintr    = 20;
        all_con  = combvec(params.eye,params.spatial_freq,params.temporal_freq,params.contrasts,params.path); %all possible conditions of the parameters that vary
        minpres  = mintr* size(all_con,2); % total number of presentations at 10 per loc
        minntrs  = floor(minpres/prespertr);   % number of trials
        
        fprintf('\nThe number of trials will be %d with %d presentations per trial.\n',minntrs,prespertr);
        
        % Randomly draw parameters for stimulus
        shuflocs = randi([1 size(all_con,2)],minpres,1);
        
        GRATINGRECORD = struct;
        for tr = 1:minntrs
            
            theseid = [((tr-1)*prespertr + 1):((tr-1)*prespertr + prespertr)];
            % Randomly draw parameters for stimulus
            GRATINGRECORD(tr).grating_tilt          = repmat(params.orientations,prespertr,1)';
            GRATINGRECORD(tr).grating_eye           = all_con(1,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_phase         = repmat(params.phase,prespertr,1)';
            GRATINGRECORD(tr).grating_sf            = all_con(2,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_tf            = all_con(3,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_contrast      = all_con(4,shuflocs((theseid)));
            GRATINGRECORD(tr).grating_diameter      = repmat(params.diameters,prespertr,1)';
            GRATINGRECORD(tr).grating_xpos          = repmat(params.xpos,prespertr,1)';
            GRATINGRECORD(tr).stereo_xpos           = repmat(params.stereo_xpos,prespertr,1)';
            GRATINGRECORD(tr).grating_ypos          = repmat(params.ypos,prespertr,1)';
            GRATINGRECORD(tr).header                = 's_cone';
            GRATINGRECORD(tr).timestamp             = clock;
            GRATINGRECORD(tr).grating_varyeye       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_fixedc        = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_oridist       = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_outerdiameter = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_space         = repmat(nan,prespertr,1);
            GRATINGRECORD(tr).grating_isi           = 500; %interstimulus interval
            GRATINGRECORD(tr).grating_stimdur       = 500; %stim interval
            GRATINGRECORD(tr).path                  = all_con(5,shuflocs((theseid)));
        end
        
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% combine with previous GLOBAL if needed
if ~isempty(oldGRATINGRECORD)
    GRATINGRECORD = [oldGRATINGRECORD GRATINGRECORD];
    clear oldGRATINGRECORD;
end

%% save matlab variable

fname = datafile;
grname   = sprintf('%s/%s_GRATINGRECORD%04u',SAVEPATH,fname,TrialRecord.CurrentTrialNumber);
save(grname,'GRATINGRECORD'); 
  
end
