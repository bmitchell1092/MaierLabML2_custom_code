% June 2019, Jacob Rogatinsky

function r = genDGParams(paradigm)

% Find screen size
scrsize = getCoord;  % Screen size [x y] in degrees

% Find dominant eye
de = getDE;

% Find receptive field
rf = getRF;

direction = [90];                        % Orientation
sf = [1];                               % Cycles per degree
tf = [4];                               % Cycles per second
diameter = [3];                         % Diameter of the grating
time = [500];                          % Milliseconds
contr_left = [0.9];                     % Left eye contrasts 0 to 1
contr_right = [0.9];                    % Right eye contrasts 0 to 1
left_xloc = (-0.25*scrsize(1)+rf(1));   % Left eye x-coordinate
right_xloc = (0.25*scrsize(1)+rf(1));   % Right eye x-coordinate
color_code = [1];                       % Code to determine grating colors
phase_angle = [0];                      % Phase angle in degrees (0-360)

global dgrecord;
struct(dgrecord);

switch paradigm
    
    case 'cinteroc'
        contr_left = [0.05, 0.11, 0.22 0.45 0.90]; % Left eye contrasts 0 to 1
        contr_right = [0.05, 0.11, 0.22 0.45 0.90]; % Right eye contrasts 0 to 1
        
        vec_comb = combvec(direction,sf,tf,diameter,time,contr_left,contr_right,left_xloc,right_xloc,color_code,phase_angle); % All possible combos
        [row, col] = size(vec_comb); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).dir = vec_comb(1,shuffle(tr));
            dgrecord(tr).sfsf = vec_comb(2,shuffle(tr));
            dgrecord(tr).tftf = vec_comb(3,shuffle(tr));
            dgrecord(tr).diam = vec_comb(4,shuffle(tr));
            dgrecord(tr).tme = vec_comb(5,shuffle(tr));
            dgrecord(tr).lfteyec = vec_comb(6,shuffle(tr));
            dgrecord(tr).rteyec = vec_comb(7,shuffle(tr));
            dgrecord(tr).lftxloc = vec_comb(8,shuffle(tr));
            dgrecord(tr).rtxloc = vec_comb(9,shuffle(tr));
            dgrecord(tr).clr = vec_comb(10,shuffle(tr));
            dgrecord(tr).phase_a = vec_comb(11,shuffle(tr));
        end
    
    case 'rfori'
        direction = [0:20:180]; % Grating orientations
        
        vec_comb = combvec(direction,sf,tf,diameter,time,contr_left,contr_right,left_xloc,right_xloc,color_code,phase_angle); % All possible combos
        [row, col] = size(vec_comb); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).dir = vec_comb(1,shuffle(tr));
            dgrecord(tr).sfsf = vec_comb(2,shuffle(tr));
            dgrecord(tr).tftf = vec_comb(3,shuffle(tr));
            dgrecord(tr).diam = vec_comb(4,shuffle(tr));
            dgrecord(tr).tme = vec_comb(5,shuffle(tr));
            dgrecord(tr).lfteyec = vec_comb(6,shuffle(tr));
            dgrecord(tr).rteyec = vec_comb(7,shuffle(tr));
            dgrecord(tr).lftxloc = vec_comb(8,shuffle(tr));
            dgrecord(tr).rtxloc = vec_comb(9,shuffle(tr));
            dgrecord(tr).clr = vec_comb(10,shuffle(tr));
            dgrecord(tr).phase_a = vec_comb(11,shuffle(tr));
        end
        
    case 'posdisparity'
        add_const = [-0.5:0.25:0.5]; % Constant to add to eye x-coordinates
        if de == 3
            left_xloc = (-0.25*scrsize(1)) + add_const; % Left eye x-coordinates
        else
            right_xloc = (0.25*scrsize(1)) + add_const; % Right eye x-coordinates
        end
        
        vec_comb = combvec(direction,sf,tf,diameter,time,contr_left,contr_right,left_xloc,right_xloc,color_code,phase_angle); % All possible combos
        [row, col] = size(vec_comb); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).dir = vec_comb(1,shuffle(tr));
            dgrecord(tr).sfsf = vec_comb(2,shuffle(tr));
            dgrecord(tr).tftf = vec_comb(3,shuffle(tr));
            dgrecord(tr).diam = vec_comb(4,shuffle(tr));
            dgrecord(tr).tme = vec_comb(5,shuffle(tr));
            dgrecord(tr).lfteyec = vec_comb(6,shuffle(tr));
            dgrecord(tr).rteyec = vec_comb(7,shuffle(tr));
            dgrecord(tr).lftxloc = vec_comb(8,shuffle(tr));
            dgrecord(tr).rtxloc = vec_comb(9,shuffle(tr));
            dgrecord(tr).clr = vec_comb(10,shuffle(tr));
            dgrecord(tr).phase_a = vec_comb(11,shuffle(tr));
        end
        
    case 'cone'
        color_code = [2 3 4];
        
        vec_comb = combvec(direction,sf,tf,diameter,time,contr_left,contr_right,left_xloc,right_xloc,color_code,phase_angle); % All possible combos
        [row, col] = size(vec_comb); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).dir = vec_comb(1,shuffle(tr));
            dgrecord(tr).sfsf = vec_comb(2,shuffle(tr));
            dgrecord(tr).tftf = vec_comb(3,shuffle(tr));
            dgrecord(tr).diam = vec_comb(4,shuffle(tr));
            dgrecord(tr).tme = vec_comb(5,shuffle(tr));
            dgrecord(tr).lfteyec = vec_comb(6,shuffle(tr));
            dgrecord(tr).rteyec = vec_comb(7,shuffle(tr));
            dgrecord(tr).lftxloc = vec_comb(8,shuffle(tr));
            dgrecord(tr).rtxloc = vec_comb(9,shuffle(tr));
            dgrecord(tr).clr = vec_comb(10,shuffle(tr));
            dgrecord(tr).phase_a = vec_comb(11,shuffle(tr));
        end
        
    case 'disparity'
        phase_angle = [-360:180:360]; % Phase angle in degrees (0-360)
        
        vec_comb = combvec(direction,sf,tf,diameter,time,contr_left,contr_right,left_xloc,right_xloc,color_code,phase_angle); % All possible combos
        [row, col] = size(vec_comb); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).dir = vec_comb(1,shuffle(tr));
            dgrecord(tr).sfsf = vec_comb(2,shuffle(tr));
            dgrecord(tr).tftf = vec_comb(3,shuffle(tr));
            dgrecord(tr).diam = vec_comb(4,shuffle(tr));
            dgrecord(tr).tme = vec_comb(5,shuffle(tr));
            dgrecord(tr).lfteyec = vec_comb(6,shuffle(tr));
            dgrecord(tr).rteyec = vec_comb(7,shuffle(tr));
            dgrecord(tr).lftxloc = vec_comb(8,shuffle(tr));
            dgrecord(tr).rtxloc = vec_comb(9,shuffle(tr));
            dgrecord(tr).clr = vec_comb(10,shuffle(tr));
            dgrecord(tr).phase_a = vec_comb(11,shuffle(tr));
        end
        
end

r = dgrecord;

end

