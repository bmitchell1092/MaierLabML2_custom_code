% Aug 2019, Jacob Rogatinsky

% Condition codes:
% 1 = Monocular, DE, PO (dom. eye, preferred orientation)
% 2 = Monocular, DE, NO
% 3 = Monocular, NDE, PO
% 4 = Monocular, NDE, NO
% 5 = Dioptic, PO
% 6 = Dioptic, NPO
% 7 = Dichoptic, DE-PO, NDE-NO
% 8 = Dichoptic, DE-NO, NDE-PO
% 9 = Dioptic PO, DE2NDE   % dont need
% 10 = Dioptic NPO, DE2NDE % dont need
% 11 = Dicoptic DE-PO, NDE-NO, DE2NDE % dont need

function r = genBMinterocParams(paradigm)

isocontrast = [0.05, 0.10, 0.22, 0.45, 0.90];
contr_left = [0, 0.05, 0.10, 0.22, 0.45, 0.90];   % Contrast 0 to 1
contr_right = [0, 0.05, 0.10, 0.22, 0.45, 0.90];
                                    
global dgrecord;
struct(dgrecord);

switch paradigm
    
    case 'monocular'
        stim_code = [1 2 3 4];
        
        vec_comb = combvec(stim_code,isocontrast); % All possible combos
        [~, col] = size(vec_comb); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).stim_code = vec_comb(1,shuffle(tr));
            dgrecord(tr).contr_left = vec_comb(2,shuffle(tr));
            dgrecord(tr).contr_right = vec_comb(2,shuffle(tr)); % same contrast in each eye
        end
        
    case 'dioptic'
        stim_code = [5 6];
        
        vec_comb = combvec(stim_code,contr_left); % All possible combos
        [~, col] = size(vec_comb); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).stim_code = vec_comb(1,shuffle(tr));
            dgrecord(tr).contr_left = vec_comb(2,shuffle(tr));
            dgrecord(tr).contr_right = dgrecord(tr).contr_left; % same contrast in each eye
        end
        
    case 'dichoptic_contrast'
        stim_code = [7 8];
        
        vec_comb = combvec(stim_code,contr_left,contr_right); % All possible combos
        [~, col] = size(vec_comb); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).ori_code = vec_comb(1,shuffle(tr));
            dgrecord(tr).contr_left = vec_comb(2,shuffle(tr));
            dgrecord(tr).contr_right = vec_comb(3,shuffle(tr));
        end
        
    case 'dichoptic_ori'
        stim_code = [9 10];
        
        vec_comb = combvec(stim_code,contr_left); % All possible combos
        [~, col] = size(vec_comb); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).stim_code = vec_comb(1,shuffle(tr));
            dgrecord(tr).contr_left = vec_comb(2,shuffle(tr));
            dgrecord(tr).contr_right = dgrecord(tr).contr_left; % same contrast in each eye
        end
        
    case 'dichoptic_ori+contrast'
        stim_code = [11 12];
        
        vec_comb = combvec(stim_code,contr_left,contr_right); % All possible combos
        [~, col] = size(vec_comb); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).stim_code = vec_comb(1,shuffle(tr));
            dgrecord(tr).contr_left = vec_comb(2,shuffle(tr));
            dgrecord(tr).contr_right = vec_comb(3,shuffle(tr));
        end
        
    case 'bminteroc'
        contr_left = [0, 0.05, 0.10, 0.22, 0.45, 0.90];   % Contrast 0 to 1
        contr_right = [0, 0.05, 0.10, 0.22, 0.45, 0.90];
        stim_code = [11];
        
        vec_comb = combvec(stim_code,contr_left,contr_right); % All possible combos
        [~, col] = size(vec_comb); % Size of the combo vector
        ntrials = 15 * col; % 15 of each combination
        shuffle = randi([1 col],ntrials,1); % Randomly order them
        
        for tr = 1:ntrials
            dgrecord(tr).stim_code = vec_comb(1,shuffle(tr));
            dgrecord(tr).contr_left = vec_comb(2,shuffle(tr));
            dgrecord(tr).contr_right = vec_comb(3,shuffle(tr));
            
        end
        
end

r = dgrecord;

end