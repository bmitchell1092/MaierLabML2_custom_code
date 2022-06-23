% June 2019, Jacob Rogatinsky

function r = genNiParams(paradigm)

% Find screen size
scrsize = getCoord;  % Screen size [x y] in degrees

% Find dominant eye
de = getDE;

% Find receptive field
rf = getRF;

left_xloc = (-0.25*scrsize(1)+rf(1));   % Left eye x-coordinate
right_xloc = (0.25*scrsize(1)+rf(1));   % Right eye x-coordinate

global dgrecord;
struct(dgrecord);

switch paradigm
        
    case 'posdisparity'
        img_id = 1:2;
        scramble = [0,1];
        ori = [0, 90, 180, 270];
        add_const = [-0.5:0.25:0.5]; % Constant to add to dominant-eye x-coordinates
        if de == 3
            left_xloc = left_xloc + add_const; % Left eye x-coordinates
        else
            right_xloc = right_xloc + add_const; % Right eye x-coordinates
        end
        
        vec_comb = combvec(img_id,ori,left_xloc,right_xloc,scramble); % All possible combos
        [row, col] = size(vec_comb); % Size of the combo vector
        ntrials = 12 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).img_id = vec_comb(1,shuffle(tr));
            dgrecord(tr).ori = vec_comb(2,shuffle(tr));
            dgrecord(tr).lftxloc = vec_comb(3,shuffle(tr));
            dgrecord(tr).rtxloc = vec_comb(4,shuffle(tr));
            dgrecord(tr).scramble = vec_comb(5,shuffle(tr));
        end
        
        
    case 'phzdisparity'
        phase_angle = [-360:180:360]; % Phase angle in degrees (0-360)
        
        vec_comb = combvec(direction,sf,tf,diameter,time,contr_left,contr_right,left_xloc,right_xloc,color_code,phase_angle); % All possible combos
        [row, col] = size(vec_comb); % Size of the combo vector
        ntrials = 8 * col; % 8 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
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

