function [diameter] = scalewEccentricity(eccentricity)

epoint = 8; %eccentricity point (x)
dpoint = 1.15; %diameter point (square root) (y)
m = 0.16; %slope of this line reported in Gattass et al. 1981 for V1

b = dpoint - (m*epoint); %find constant in eq for linear line

diameter = m*eccentricity + b; 
diameter = diameter.^2; %square the diameter since the number reported are based on square root of diameter

% cheating...
diameter = .25;
end