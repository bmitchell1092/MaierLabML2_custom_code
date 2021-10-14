pathhead=getenv('USERPROFILE');
fname = sprintf(...
    '%s\\Documents\\stereostimuli\\distimuli\\%s-stereoeyecal.txt',...
    pathhead,date);

obs = readstereoeyecal(fname);

figure,
% mp = length(unique(abs([obs.Xml]))) *  length(unique([obs.Yml]));
% colors = spring(mp);
for i =[1:length(obs)]
    
    if obs(i).Xml < 0
        le = plot([obs(i).Xvol],[obs(i).Yvol],'c.');
        h  = text([obs(i).Xvol],[obs(i).Yvol],sprintf('(%1.0f,%1.0f)',round(obs(i).Xeye),round(obs(i).Yeye)),'FontSize',8);
        hold on
        
        
    else
        re = plot([obs(i).Xvol],[obs(i).Yvol],'m.');
       h  = text([obs(i).Xvol],[obs(i).Yvol],sprintf('(%1.0f,%1.0f)',round(obs(i).Xeye),round(obs(i).Yeye)),'FontSize',8);
        hold on
     end
   
    
    
end

xlim([-5 5]); ylim([-5 5]);
axis square;
ylabel('Y voltage');
xlabel('X voltage');
set(gca,'YDir','reverse'); 
title(datestr(obs(end).timestamp));
%legend([le re h],'Left Eye','Right Eye','(x,y) dva','Location','BestOutside')
legend([le re],'Left Eye','Right Eye','Location','BestOutside')



% clear obs;
%
% obs = readstereoeyecal('C:\Users\MLab\Desktop\distimuli\12-Mar-2015-stereoeyecal_pm1left.txt');
% for i =[1:length(obs)]
%     if obs(i).Xml < 0
%         plot([obs(i).Xvol],[obs(i).Yvol],'b.');
%     else
%         plot([obs(i).Xvol],[obs(i).Yvol],'r.');
%     end
%     text([obs(i).Xvol],[obs(i).Yvol],sprintf('(%0.1f,%0.1f)',obs(i).Xeye,obs(i).Yeye));
%     hold on
%
%
% end

% %%
% % find center data points for each L and R sides:
% xs = find([obs.Xml] == 11.4 | [obs.Xml] == -11.4);
% ys = find([obs.Yml] == 0);
% 
% idxc = intersect(xs,ys);
% figure
% for i = 1:length(idxc)
%     
%     if obs(i).Xml < 0
%         plot([obs(idxc(i)).Xvol],[obs(idxc(i)).Yvol],'r.');
%     else
%         plot([obs(idxc(i)).Xvol],[obs(idxc(i)).Yvol],'b.');
%     end
%     text([obs(idxc(i)).Xvol],[obs(idxc(i)).Yvol],sprintf('(%0.1f,%0.1f)',obs(idxc(i)).Xeye,obs(idxc(i)).Yeye));
%     hold on
%     
% end
% rnge = [range([obs.Xvol]) range([obs.Yvol])];
% title(gca,sprintf('range XY vols: [%d %d]',rnge));

% %%
% 
% % find center data points for each L and R sides:
% xs = find([obs.Xml] == 11.4 | [obs.Xml] == -11.4);
% ys = [1:length([obs.Yml])];
% 
% idxc = intersect(xs,ys);
% figure
% for i = 1:length(idxc)
%     
%     if obs(i).Xml < 0
%         plot([obs(idxc(i)).Xvol],[obs(idxc(i)).Yvol],'r.');
%     else
%         plot([obs(idxc(i)).Xvol],[obs(idxc(i)).Yvol],'b.');
%     end
%     text([obs(idxc(i)).Xvol],[obs(idxc(i)).Yvol],sprintf('(%0.1f,%0.1f)',obs(idxc(i)).Xeye,obs(idxc(i)).Yeye));
%     hold on
%     
% end
% rnge = [range([obs.Xvol]) range([obs.Yvol])];
% title(gca,sprintf('range XY vols: [%d %d]',rnge));