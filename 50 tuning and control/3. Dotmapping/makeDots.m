function [DOT,dot_diameter] = makeDots2(TrialRecord,Screen, presN)

global DOTRECORD GABOR
CurrentTrialNumber    = TrialRecord.CurrentTrialNumber;
dot_contrast          = DOTRECORD(CurrentTrialNumber).dot_contrast(presN);
dot_x                 = DOTRECORD(CurrentTrialNumber).dot_xpos(presN);
dot_y                 = DOTRECORD(CurrentTrialNumber).dot_ypos(presN);
% dot_eye               = DOTRECORD(CurrentTrialNumber).dot_eye(presN);

[~,dot_eccentricity]  = cart2pol(dot_x,dot_y);
dot_diameter          = scalewEccentricity(dot_eccentricity) ; % scale with eccentricity (Gattass et al., 1981, Fig 13);
dot_diameter          = floor(dot_diameter) + ceil( (dot_diameter-floor(dot_diameter))/.25) * 0.25; %round up to the nearest .25 deg

% extract screen info from TrialRecord
pixperdeg   = Screen.PixelsPerDegree;
bg_color    = [0.5 0.5 0.5]; %Screen.BackgroundColor;

%%
if GABOR == 0
    % make rns
    dim = round(dot_diameter * pixperdeg);
    J = dim; I = dim;
    contrast = dot_contrast;                % contrast
    sd = 0;
    
    dot = rand([I J]);
    dot(dot>0.5) = 1; dot(dot<=0.5) = 0;
    dot = dot .* contrast;
    dot = repmat(dot,[1 1 3]);
    
    [x,y] = meshgrid(-J/2:1:(J/2-1), (I/2):-1:(-I/2+1));
    
    % apply circular mask  (DEV: would be nice to do this (here and later) without iteration, linear indexing instead? bsxfun?)
    rad_mask = sqrt(x.^2 + y.^2) > dim/2;
    for rgb = 1:3
        RGBchannel = dot(:,:,rgb);
        RGBchannel(rad_mask) =  bg_color(rgb);
        DOT(:,:,rgb) = RGBchannel;
    end
    
else
    
    sd = round(dot_diameter/2*pixperdeg);% gaussian standard deviation (radius)
    rad_mask = sd*3;                                % radius of circular mask
    dim = sd*10; J = dim; I = dim;                 % size of grating image
    contrast = dot_contrast;                   % contrast
    
    dot = rand([I J]);
    dot(dot>0.5) = 1; dot(dot<=0.5) = -1; % data range [-1 1]
    dot = dot .* contrast;
    
    [x,y] = meshgrid(-J/2:1:(J/2-1), (I/2):-1:(-I/2+1));
    gabor   = exp(-(x.^2 + y.^2)/2/sd^2); %gabor window, s = std of window, range [0 1]
    target  = ((dot .* gabor) + 1) ./ (2); % apply gabor to grating, rescale data to range [0 1]
    
    target = repmat(target,[1 1 3]);
    
    % apply circular mask
    mask = sqrt(x.^2 + y.^2) > rad_mask;
    DOT = [];
    for rgb = 1:3
        RGBchannel = target(:,:,rgb);
        RGBchannel(mask) =  bg_color(rgb);
        DOT(:,:,rgb) = RGBchannel;
    end
    % crop image
    DOT = DOT(abs(y(:,1))< rad_mask, abs(x(1,:))< rad_mask, :);
end
end