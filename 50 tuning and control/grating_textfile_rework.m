    
%% 1st Trial, Write headers
filename = strcat(SAVEPATH,'\',datafile,'.g',upper(paradigm),'Grating_di');

fid = fopen(filename, 'w');
    formatSpec =  '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n';
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
        'ori_L',...             % orientation (tilt) of grating in the LE
        'ori_R',...             % orientation (tilt) of grating in the RE
        'phase_L',...           % Phase angle of grating in the LE
        'phase_R',...           % Phase angle of grating in the RE
        'sf_L',...              % Spatial frequency (cyc/deg) of grating in the LE
        'sf_R',...              % Spatial frequency (cyc/deg) of grating in the RE
        'tf_L',...              % Temporal frequency (cyc/deg/sec) of grating in the LE
        'tf_R',...              % Temporal frequency (cyc/deg/sec) of grating in the RE
        'diameter_L',...        % Diameter (size) of grating in the LE
        'diameter_R',...        % Diameter (size) of grating in the RE
        'trialHasBlank',...     % whether this trial has a blank presentation 
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
    formatSpec =  '%04u\t%s\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\r\n';
    fprintf(fid,formatSpec,...
        TrialRecord.CurrentTrialNumber,...
        header,...             % 'paradigm'
        grating_xpos(pres),...           % dva from fused fixation
        grating_ypos(pres),...           % dva from fused fixation
        stereo_xpos(pres)',...            % actual x-position of grating in the LE
        other_stereo_xpos(pres),...            % actual x-position of grating in the RE
        grating_ypos,...            % actual y-position of grating in the LE
        other_ypos,...            % actual y-position of grating in the RE
        grating_posdist,...       % difference (in visual deg) between LE and RE grating x-positions
        grating_phzdist,...       % difference (in visual deg) between LE and RE grating y-positions
        fixedc(pres),...        % Michelson contrast of grating in the LE
        grating_contrast(pres),...        % Michelson contrast of grating in the RE
        gratL_tilt,...             % orientation (tilt) of grating in the LE
        gratR_tilt,...             % orientation (tilt) of grating in the RE
        gratL_phase,...           % Phase angle of grating in the LE
        gratR_phase,...           % Phase angle of grating in the RE
        grating_sf,...              % Spatial frequency (cyc/deg) of grating in the LE
        grating_sf,...              % Spatial frequency (cyc/deg) of grating in the RE
        grating_tf,...              % Temporal frequency (cyc/deg/sec) of grating in the LE
        grating_tf,...              % Temporal frequency (cyc/deg/sec) of grating in the RE
        grating_diameter,...        % Diameter (size) of grating in the LE
        grating_diameter,...        % Diameter (size) of grating in the RE
        0,...     % whether this trial has a blank presentation
        0,...             % whether this presentation was a blank or not
        0,...             % whether the grating was gabor filtered
        0,...         % standard deviation of the gabor filter
        grating_eye,...               % 1 = LE, 2 = RE, 3 = Both eyes
        grating_stimdur,...          % stimulus duration
        grating_isi,...               % interstimulus interval
        nan,...             % for cone isolation
        now);
    
    fclose(fid);
end