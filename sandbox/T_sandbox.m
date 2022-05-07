% Initialize the escape key
hotkey('esc', 'escape_screen(); assignin(''caller'',''continue_'',false);');

% user input
stimuli = 'rds2';


%% Run Scene
switch stimuli
    case 'single grating'
    gray = [0.5 0.5 0.5];
    % Specify the properties
    contrast = 0.7;
    tf = 0;                         % 4 = drifting grating, 0 = static grating
    sf = [2];
    direction = 75;
    diameter = 2.5;
    position = [-15, -5; -10, -5];
    color1 = gray + (contrast ./ 2);
    color2 = gray - (contrast ./ 2);
    phase = [0,90];
    window = 'circular';
    duration = 6500;
    
    % Create the grating
    grat1a = SineGrating(null_);
    
    % Set the grating field values
    grat1a.Position = position(1,:);
    grat1a.Radius = diameter/2;
    grat1a.Direction = direction;
    grat1a.SpatialFrequency = sf;
    grat1a.TemporalFrequency = tf;
    grat1a.Phase = phase(1);
    grat1a.Color1 = color1;
    grat1a.Color2 = color2;
    grat1a.WindowType = window;
    
    % Set the grating field values
        % Create the grating
    grat2a = SineGrating(grat1a);
    grat2a.Position = position(2,:);
    grat2a.Radius = diameter/2;
    grat2a.Direction = direction;
    grat2a.SpatialFrequency = sf;
    grat2a.TemporalFrequency = tf;
    grat1a.Phase = phase(2);
    grat2a.Color1 = color1;
    grat2a.Color2 = color2;
    grat2a.WindowType = window;
    
    % Link the grating to the timer
    cnt = TimeCounter(grat2a);
    
    % Specify the timer field values
    cnt.Duration = duration;
    
    bck = ImageGraphic(cnt);
    bck.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };
    
    % Create the scene adapter
    scene1 = create_scene(bck);
    
    % Run the scene
    run_scene(scene1);
    
    
    case 'multiple gratings'
        gray = [0.5 0.5 0.5];
        %set_bgcolor([0.7, 0.7, 0.7]);
        % Specify the properties
        contrast = 0.7;
        tf = 0;                         % 4 = drifting grating, 0 = static grating
        sf = [0.5 1 2 3];
        direction = 75;
        direction2 = [0, 45, 90, 135];
        diameter = 2.5;
        position = [-20, -5; -15, -5; -10, -5; -5, -5;...
            -20, 5; -15, 5; -10, 5; -5, 5];
        color1 = gray + (contrast ./ 2);
        color2 = gray - (contrast ./ 2);
        window = 'circular';
        duration = 6500;         % Milliseconds
        
        
        % Create the grating
        grat1a = SineGrating(null_);
        
        % Set the grating field values
        grat1a.Position = position(1,:);
        grat1a.Radius = diameter/2;
        grat1a.Direction = direction;
        grat1a.SpatialFrequency = sf(1);
        grat1a.TemporalFrequency = tf;
        grat1a.Color1 = color1;
        grat1a.Color2 = color2;
        grat1a.WindowType = window;
        
        % Set the grating field values
        grat2a = SineGrating(grat1a);
        grat2a.Position = position(2,:);
        grat2a.Radius = diameter/2;
        grat2a.Direction = direction;
        grat2a.SpatialFrequency = sf(2);
        grat2a.TemporalFrequency = tf;
        grat2a.Color1 = color1;
        grat2a.Color2 = color2;
        grat2a.WindowType = window;
        
        % Set the grating field values
        grat3a = SineGrating(grat2a);
        grat3a.Position = position(3,:);
        grat3a.Radius = diameter/2;
        grat3a.Direction = direction;
        grat3a.SpatialFrequency = sf(3);
        grat3a.TemporalFrequency = tf;
        grat3a.Color1 = color1;
        grat3a.Color2 = color2;
        grat3a.WindowType = window;
        
        % Set the grating field values
        grat4a = SineGrating(grat3a);
        grat4a.Position = position(4,:);
        grat4a.Radius = diameter/2;
        grat4a.Direction = direction;
        grat4a.SpatialFrequency = sf(4);
        grat4a.TemporalFrequency = tf;
        grat4a.Color1 = color1;
        grat4a.Color2 = color2;
        grat4a.WindowType = window;
        
        grat5a = SineGrating(grat4a);
        grat5a.Position = position(5,:);
        grat5a.Radius = diameter/2;
        grat5a.Direction = direction2(1);
        grat5a.SpatialFrequency = sf(2);
        grat5a.TemporalFrequency = tf;
        grat5a.Color1 = color1;
        grat5a.Color2 = color2;
        grat5a.WindowType = window;
        
        % Set the grating field values
        grat6a = SineGrating(grat5a);
        grat6a.Position = position(6,:);
        grat6a.Radius = diameter/2;
        grat6a.Direction = direction2(2);
        grat6a.SpatialFrequency = sf(2);
        grat6a.TemporalFrequency = tf;
        grat6a.Color1 = color1;
        grat6a.Color2 = color2;
        grat6a.WindowType = window;
        
        % Set the grating field values
        grat7a = SineGrating(grat6a);
        grat7a.Position = position(7,:);
        grat7a.Radius = diameter/2;
        grat7a.Direction = direction2(3);
        grat7a.SpatialFrequency = sf(2);
        grat7a.TemporalFrequency = tf;
        grat7a.Color1 = color1;
        grat7a.Color2 = color2;
        grat7a.WindowType = window;
        
        % Set the grating field values
        grat8a = SineGrating(grat7a);
        grat8a.Position = position(8,:);
        grat8a.Radius = diameter/2;
        grat8a.Direction = direction2(4);
        grat8a.SpatialFrequency = sf(2);
        grat8a.TemporalFrequency = tf;
        grat8a.Color1 = color1;
        grat8a.Color2 = color2;
        grat8a.WindowType = window;
        
        grat9a = SineGrating(grat7a);
        grat9a.Position = position(8,:);
        grat9a.Radius = diameter/2;
        grat9a.Direction = direction2(4);
        grat9a.SpatialFrequency = sf(2);
        grat9a.TemporalFrequency = tf;
        grat9a.Color1 = color1;
        grat9a.Color2 = color2;
        grat9a.WindowType = window;
        
        % Link the grating to the timer
        cnt = TimeCounter(grat8a);
        
        % Specify the timer field values
        cnt.Duration = duration;
        
        bck = ImageGraphic(cnt);
        bck.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };
        
        % Create the scene adapter
        scene1 = create_scene(bck);
        
        % Run the scene
        run_scene(scene1);
        
        % Set the ITI
        set_iti(250);
        
        
        
    case 'rds'
        
        rdm = RandomDotMotion(null_);
        rdm.Position = [-15 5];
        rdm.Radius = 2;
        rdm.Coherence = 30;
        rdm.Direction = 0;
        rdm.NumDot = 50;
        rdm.DotColor = [0 0 0];
        rdm.DotShape = 'circle';
        rdm.Interleaf = 1;
        rdm.Speed = 0;
        tc = TimeCounter(rdm);
        tc.Duration = 8000;
        
        bck = ImageGraphic(tc);
        bck.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };
    
        scene = create_scene(bck);
        run_scene(scene);
        
    case 'rds2'
        
        position = [-10,5];
        
        [DOTS, dot_diameter] = makeRDS(TrialRecord,Screen,position,0); % last arg is gabor 
        
        img2 = ImageGraphic(null_);
        img2.List = { {DOTS}, [position] };
        
        bck2 = ImageGraphic(img2);
        bck2.List = { {'graybackgroundcross.png'}, [0 0], [0 0 0], Screen.SubjectScreenFullSize };
        
        scene = create_scene(bck2);
        run_scene(scene);
        
    case 'natural image'
        
end
