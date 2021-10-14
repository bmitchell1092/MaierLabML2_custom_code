% get xy points (deg) on screen for eye calibration for dichoptic paradigms

% Fall 2015, KD
% April 2016, MAC 

% setup array of x and y cordinates
clear x y tl int
int = 8;
y = [8:-int:-8];
x = y;
tl = combvec(x,y); 
tl = horzcat([0;0], tl);

% extract ScreenInfo from Calibration Window BasicData
clear fig ScreenInfo BasicData
fig = findobj('tag', 'xycalibrate');
BasicData = get(fig, 'userdata');
ScreenInfo   = BasicData.ScreenInfo;
fprintf('\n<<<  Maier Lab  >>> PixelsPerDegree = %0.2f\n',ScreenInfo.PixelsPerDegree);


% findScreenPos
clear rightlist leftlist 
for TOcount = 1:2
    % 1 = LE, 2 = RE
    clear X Y 
    [X,Y] = findScreenPos(TOcount,ScreenInfo,tl(1,:),tl(2,:),'cart');
    
    if TOcount == 1
        leftlist = [X;Y];
    elseif TOcount == 2
        X = X([1 4 3 2 7 6 5 10 9 8]); 
        rightlist = [X;Y];
        
    end

end

dva_L = [leftlist(1,:) - leftlist(1,1); leftlist(2,:)]'; 
dva_R = [rightlist(1,:) - rightlist(1,1); rightlist(2,:)]'; 
rightlist = rightlist'; 
leftlist  = leftlist'; 
for i = 1:size(dva_L,1)
   
    Lpt = dva_L(i,:); 
    match_idx = find(ismember(dva_R,Lpt,'rows'));
    R_match(i) = match_idx(1); 
    
end
new_targetlist = nan(size(dva_L,1)*2,2); 
new_targetlist([1:2:end-1],:) = leftlist; 
new_targetlist([2:2:end],:) = rightlist([R_match],:);  

    
clearvars -except rightlist leftlist new_targetlist