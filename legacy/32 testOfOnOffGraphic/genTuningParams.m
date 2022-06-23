% June 2019, Jacob Rogatinsky

function r = genTuningParams(paradigm)

% Find screen size
scrsize = getCoord;  % Screen size [x y] in degrees

% Find dominant eye
de = getDE;

% Find receptive field
rf = getRF;

ori = [90];                             % Orientation
sf = [1];                               % Cycles per degree
tf = [4];                               % Cycles per second
diameter = [3];                         % Diameter of the grating
contr_left = [0.9];                     % Left eye contrasts 0 to 1
contr_right = [0.9];                    % Right eye contrasts 0 to 1
xloc_left = (-0.25*scrsize(1)+rf(1));   % Left eye x-coordinate
xloc_right = (0.25*scrsize(1)+rf(1));   % Right eye x-coordinate
color_code = [1];                       % Code to determine grating colors
phase_angle = [0];                      % Phase angle in degrees (0-360)

global dgrecord;
struct(dgrecord);

switch paradigm
    
    case 'cinteroc'
        contr_left = [0.11, 0.22 0.45 0.90]; % Left eye contrasts 0 to 1
        contr_right = [0.11, 0.22 0.45 0.90]; % Right eye contrasts 0 to 1
        
        vec_comb = combvec(ori,sf,tf,diameter,contr_left,contr_right,xloc_left,xloc_right,color_code,phase_angle); % All possible combos
        [~, col] = size(vec_comb); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).ori = vec_comb(1,shuffle(tr));
            dgrecord(tr).sf = vec_comb(2,shuffle(tr));
            dgrecord(tr).tf = vec_comb(3,shuffle(tr));
            dgrecord(tr).diam = vec_comb(4,shuffle(tr));
            dgrecord(tr).cont_left = vec_comb(5,shuffle(tr));
            dgrecord(tr).cont_right = vec_comb(6,shuffle(tr));
            dgrecord(tr).xloc_left = vec_comb(7,shuffle(tr));
            dgrecord(tr).xloc_right = vec_comb(8,shuffle(tr));
            dgrecord(tr).color = vec_comb(9,shuffle(tr));
            dgrecord(tr).phase = vec_comb(10,shuffle(tr));
        end
    
    case 'rfori'
        ori = [0:20:180]; % Grating orientations
        
        vec_comb = combvec(ori,sf,tf,diameter,contr_left,contr_right,xloc_left,xloc_right,color_code,phase_angle); % All possible combos
        [~, col] = size(vec_comb); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).ori = vec_comb(1,shuffle(tr));
            dgrecord(tr).sf = vec_comb(2,shuffle(tr));
            dgrecord(tr).tf = vec_comb(3,shuffle(tr));
            dgrecord(tr).diam = vec_comb(4,shuffle(tr));
            dgrecord(tr).cont_left = vec_comb(5,shuffle(tr));
            dgrecord(tr).cont_right = vec_comb(6,shuffle(tr));
            dgrecord(tr).xloc_left = vec_comb(7,shuffle(tr));
            dgrecord(tr).xloc_right = vec_comb(8,shuffle(tr));
            dgrecord(tr).color = vec_comb(9,shuffle(tr));
            dgrecord(tr).phase = vec_comb(10,shuffle(tr));
        end
        
    case 'rfsize'
        diameter = [0.5 1 2 3 4 5]; % Grating size
        
        vec_comb = combvec(ori,sf,tf,diameter,contr_left,contr_right,xloc_left,xloc_right,color_code,phase_angle); % All possible combos
        [~, col] = size(vec_comb); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).ori = vec_comb(1,shuffle(tr));
            dgrecord(tr).sf = vec_comb(2,shuffle(tr));
            dgrecord(tr).tf = vec_comb(3,shuffle(tr));
            dgrecord(tr).diam = vec_comb(4,shuffle(tr));
            dgrecord(tr).cont_left = vec_comb(5,shuffle(tr));
            dgrecord(tr).cont_right = vec_comb(6,shuffle(tr));
            dgrecord(tr).xloc_left = vec_comb(7,shuffle(tr));
            dgrecord(tr).xloc_right = vec_comb(8,shuffle(tr));
            dgrecord(tr).color = vec_comb(9,shuffle(tr));
            dgrecord(tr).phase = vec_comb(10,shuffle(tr));
        end
        
    case 'rfsf'
        sf = [0.2 0.5 1 2 3 4]; % Grating spatial frequency
        
        vec_comb = combvec(ori,sf,tf,diameter,contr_left,contr_right,xloc_left,xloc_right,color_code,phase_angle); % All possible combos
        [~, col] = size(vec_comb); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).ori = vec_comb(1,shuffle(tr));
            dgrecord(tr).sf = vec_comb(2,shuffle(tr));
            dgrecord(tr).tf = vec_comb(3,shuffle(tr));
            dgrecord(tr).diam = vec_comb(4,shuffle(tr));
            dgrecord(tr).cont_left = vec_comb(5,shuffle(tr));
            dgrecord(tr).cont_right = vec_comb(6,shuffle(tr));
            dgrecord(tr).xloc_left = vec_comb(7,shuffle(tr));
            dgrecord(tr).xloc_right = vec_comb(8,shuffle(tr));
            dgrecord(tr).color = vec_comb(9,shuffle(tr));
            dgrecord(tr).phase = vec_comb(10,shuffle(tr));
        end
        
    case 'posdisparity'
        add_const = [-0.5:0.25:0.5]; % Constant to add to eye x-coordinates
        if de == 3
            xloc_left = xloc_left + add_const; % Left eye x-coordinates
        else
            xloc_right = xloc_right + add_const; % Right eye x-coordinates
        end
        
        vec_comb = combvec(ori,sf,tf,diameter,contr_left,contr_right,xloc_left,xloc_right,color_code,phase_angle); % All possible combos
        [~, col] = size(vec_comb); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).ori = vec_comb(1,shuffle(tr));
            dgrecord(tr).sf = vec_comb(2,shuffle(tr));
            dgrecord(tr).tf = vec_comb(3,shuffle(tr));
            dgrecord(tr).diam = vec_comb(4,shuffle(tr));
            dgrecord(tr).cont_left = vec_comb(5,shuffle(tr));
            dgrecord(tr).cont_right = vec_comb(6,shuffle(tr));
            dgrecord(tr).xloc_left = vec_comb(7,shuffle(tr));
            dgrecord(tr).xloc_right = vec_comb(8,shuffle(tr));
            dgrecord(tr).color = vec_comb(9,shuffle(tr));
            dgrecord(tr).phase = vec_comb(10,shuffle(tr));
        end
        
    case 'phzdisparity'
        phase_angle = [-360:180:360]; % Phase angle in degrees (0-360)
        
        vec_comb = combvec(ori,sf,tf,diameter,contr_left,contr_right,xloc_left,xloc_right,color_code,phase_angle); % All possible combos
        [~, col] = size(vec_comb); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).ori = vec_comb(1,shuffle(tr));
            dgrecord(tr).sf = vec_comb(2,shuffle(tr));
            dgrecord(tr).tf = vec_comb(3,shuffle(tr));
            dgrecord(tr).diam = vec_comb(4,shuffle(tr));
            dgrecord(tr).cont_left = vec_comb(5,shuffle(tr));
            dgrecord(tr).cont_right = vec_comb(6,shuffle(tr));
            dgrecord(tr).xloc_left = vec_comb(7,shuffle(tr));
            dgrecord(tr).xloc_right = vec_comb(8,shuffle(tr));
            dgrecord(tr).color = vec_comb(9,shuffle(tr));
            dgrecord(tr).phase = vec_comb(10,shuffle(tr));
        end
        
    case 'cone'
        color_code = [2 3 4];
        
        vec_comb = combvec(ori,sf,tf,diameter,contr_left,contr_right,xloc_left,xloc_right,color_code,phase_angle); % All possible combos
        [~, col] = size(vec_comb); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).ori = vec_comb(1,shuffle(tr));
            dgrecord(tr).sf = vec_comb(2,shuffle(tr));
            dgrecord(tr).tf = vec_comb(3,shuffle(tr));
            dgrecord(tr).diam = vec_comb(4,shuffle(tr));
            dgrecord(tr).cont_left = vec_comb(5,shuffle(tr));
            dgrecord(tr).cont_right = vec_comb(6,shuffle(tr));
            dgrecord(tr).xloc_left = vec_comb(7,shuffle(tr));
            dgrecord(tr).xloc_right = vec_comb(8,shuffle(tr));
            dgrecord(tr).color = vec_comb(9,shuffle(tr));
            dgrecord(tr).phase = vec_comb(10,shuffle(tr));
        end
        
   
        
end

r = dgrecord;

end

