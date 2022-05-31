function [color1,color2] = calcContrast(contr)
%Contrast. Converts Michelson contrast to RGB

gray = [0.5 0.5 0.5];
color1 = gray + (contr / 2);
color2 = gray - (contr / 2);
end

