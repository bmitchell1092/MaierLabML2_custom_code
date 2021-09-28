function DOT = makeDots(diameter, pixperdeg, bg_color)

standev = round((diameter/2)*pixperdeg);      % Gaussian standard deviation (radius)
rad_mask = standev*3;                         % Radius of circular mask
dim = standev*10;                             % Size of grating image

% Create a patch of noise
dot = rand([dim dim]); % Random values
dot(dot>0.5) = 1; % Send half to 1
dot(dot<=0.5) = -1; % Send half to -1

% Set up the Gabor filter
[x,y] = meshgrid(-dim/2:1:(dim/2-1), (dim/2):-1:(-dim/2+1));
gabor   = exp(-(x.^2 + y.^2)/2/standev^2);
target  = ((dot .* gabor) + 1) ./ (2);
target = repmat(target,[1 1 3]);

% Apply circular mask to the noise patch
mask = sqrt(x.^2 + y.^2) > rad_mask;
DOT=[];
for rgb = 1:3
RGBchannel = target(:,:,rgb);
RGBchannel(mask) =  bg_color(rgb);
DOT(:,:,rgb) = RGBchannel;
end

% Crop image
DOT = DOT(abs(y(:,1))< rad_mask, abs(x(1,:))< rad_mask, :);

end