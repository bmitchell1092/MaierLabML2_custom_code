% Aug 2019, Jacob Rogatinsky
% Sept 2021, Edited by Blake Mitchell

function r = genDotParams(th, e)

th_rad = deg2rad(th); % Theta values degrees to radians
vec_comb = combvec(th_rad,e); % All possible combos

x=[];y=[];
thetas = vec_comb(1,:);
eccs = vec_comb(2,:);

global dgrecord;
struct(dgrecord);

for ii = 1:length(vec_comb)
    [x(end+1),y(end+1)]=pol2cart(thetas(ii),eccs(ii));
end

[~, col] = size(x); % Size of the combo vector
ntrials = 1 * col; % 1 of each combination
shuffle = randi([1 col],ntrials,1); % Randomly order them

for tr = 1:ntrials
    dgrecord(tr).x = x(shuffle(tr));
    dgrecord(tr).y = y(shuffle(tr));
end

r = dgrecord;

end