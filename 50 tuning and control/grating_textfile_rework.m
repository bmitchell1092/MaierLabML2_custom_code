    
%% 1st Trial, Write headers
fid = fopen(filename, 'w');
    formatSpec =  '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n';
    fprintf(fid,formatSpec,...
        'trial',...             % Trial number
        'header',...            % 'paradigm'
        'horzdva',...           % dva from fused fixation
        'vertdva',...           % dva from fused fixation
        'xpos_L',...            % actual x-position of grating in the LE
        'xpos_R',...            % actual x-position of grating in the RE
        'ypos_L',...            % actual y-position of grating in the LE
        'ypos_R',...            % actual y-position of grating in the RE
        'x_disparity',...       % difference (in visual deg) between LE and RE grating x-positions
        'y_disparity',...       % difference (in visual deg) between LE and RE grating y-positions
        'contrast_L',...        % Michelson contrast of grating in the LE
        'contrast_R',...        % Michelson contrast of grating in the RE
        'contrast_disparity',...% difference between LE and RE contrast
        'ori_L',...             % orientation (tilt) of grating in the LE
        'ori_R',...             % orientation (tilt) of grating in the RE
        'ori_disparity',...     % difference (in angle) between LE and RE orientations
        'phase_L',...           % Phase angle of grating in the LE
        'phase_R',...           % Phase angle of grating in the RE
        'phase_disparity',...   % difference (in phase angle) between LE and RE phase
        'sf_L',...              % Spatial frequency (cyc/deg) of grating in the LE
        'sf_R',...              % Spatial frequency (cyc/deg) of grating in the RE
        'sf_disparity',...      % difference (in phase angle) between LE and RE phase
        'tf_L',...              % Temporal frequency (cyc/deg/sec) of grating in the LE
        'tf_R',...              % Temporal frequency (cyc/deg/sec) of grating in the RE
        'tf_disparity',...      % difference (in cycles/deg) between LE and RE temporal frequency
        'diameter_L',...        % Diameter (size) of grating in the LE
        'diameter_R',...        % Diameter (size) of grating in the RE
        'diameter_disparity',...% difference between LE and RE diameters
        'oddball',...           % whether this trial has a blank presentation 
        'blank',...             % whether this presentation was a blank or not
        'gabor',...             % whether the grating was gabor filtered
        'gabor_std',...         % standard deviation of the gabor filter
        'eye',...               % 1 = LE, 2 = RE, 3 = Both eyes
        'duration',...          % stimulus duration
        'isi',...               % interstimulus interval 
        'pathw',...             % for cone isolation 
        'timestamp');
    
    fclose(fid);
    
    
    
    %% All trials, Append
    for pres = 1:prespertr
        
        fid = fopen(filename, 'a'); % append
        formatSpec =  '%04u\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n';
        fprintf(fid,formatSpec,...
            TrialRecord.CurrentTrialNumber,...
            grating_xpos(pres),... % in degrees of visual angle
            grating_ypos(pres),...
            stereo_xpos(pres),...
            grating_ypos(pres),...
            other_xpos(pres),...
            other_ypos(pres),...
            grating_tilt(pres),...
            grating_sf(pres),...
            grating_contrast(pres),...
            grating_fixedc(pres),...
            grating_diameter(pres),...
            grating_eye(pres),...
            grating_varyeye(pres),...
            grating_oridist(pres),...
            0,...
            0,...
            grating_header,...
            grating_phase(pres),...
            0,...
            now);
        
        fclose(fid);
    end