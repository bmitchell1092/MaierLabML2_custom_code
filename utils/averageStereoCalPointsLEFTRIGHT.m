% average stereo calibration values 

pathhead=getenv('USERPROFILE');
fname = [pathhead ...
    '\Documents\stereostimuli\distimuli\17-Apr-2017-stereoeyecal-left.txt'];

obs  = readstereoeyecal(fname);
nobs = struct2cell(obs); 
nobs = cell2mat(squeeze(nobs)); 
unqpts = unique(([nobs(1,:); nobs(2,:)]'),'rows');
ebars = 0; 
figure,
for i = 1:size(unqpts,1)
    
   fpts =  nobs(1,:) == unqpts(i,1) & nobs(2,:) == unqpts(i,2);
   xvals = nobs(5,fpts); 
   yvals = nobs(6,fpts);
   
   mxvals  = mean(xvals); 
   myvals  = mean(yvals); 
   exvals  = std(xvals,0,2)./sqrt(length(xvals)); 
   eyvals  = std(yvals,0,2)./sqrt(length(yvals)); 
   id = find(fpts,1,'first'); 
%     if  unqpts(i,1) < 0
        le = plot([mxvals],[myvals],'c.');
        h  = text([mxvals],[myvals],sprintf('(%1.0f,%1.0f)',round(nobs(3,id)),round(nobs(4,id))),'FontSize',8);
        hold on
        if ebars == 1
        errorbarxy(mxvals,myvals,exvals,eyvals,{'--','c','c'}); 
        end
        hold on;
      
%     else
%         le = plot([mxvals],[myvals],'m.');
%         h  = text([mxvals],[myvals],sprintf('(%1.0f,%1.0f)',round(nobs(3,id)),round(nobs(4,id))),'FontSize',8);
%         hold on
%         if ebars == 1
%            errorbarxy(mxvals,myvals,exvals,eyvals,{'--','m','m'}); 
%         end
%         hold on;
%     end

end

clear obs 
fname = [pathhead ...
    '\Documents\stereostimuli\distimuli\17-Apr-2017-stereoeyecal-right.txt'];

obs  = readstereoeyecal(fname);
nobs = struct2cell(obs); 
nobs = cell2mat(squeeze(nobs)); 
unqpts = unique(([nobs(1,:); nobs(2,:)]'),'rows');
ebars = 0; 

for i = 1:size(unqpts,1)
    
   fpts =  nobs(1,:) == unqpts(i,1) & nobs(2,:) == unqpts(i,2);
   xvals = nobs(5,fpts); 
   yvals = nobs(6,fpts); 
   
   mxvals  = mean(xvals); 
   myvals  = mean(yvals); 
   exvals  = std(xvals,0,2)./sqrt(length(xvals)); 
   eyvals  = std(yvals,0,2)./sqrt(length(yvals)); 
   id = find(fpts,1,'first'); 
% %     if  unqpts(i,1) < 0
%         le = plot([mxvals],[myvals],'c.');
%         h  = text([mxvals],[myvals],sprintf('(%1.0f,%1.0f)',round(nobs(3,id)),round(nobs(4,id))),'FontSize',8);
%         hold on
%         if ebars == 1
%         errorbarxy(mxvals,myvals,exvals,eyvals,{'--','c','c'}); 
%         end
%         hold on;
%       
% %     else
        le = plot([mxvals],[myvals],'m.');
        h  = text([mxvals],[myvals],sprintf('(%1.0f,%1.0f)',round(nobs(3,id)),round(nobs(4,id))),'FontSize',8);
        hold on
        if ebars == 1
           errorbarxy(mxvals,myvals,exvals,eyvals,{'--','m','m'}); 
        end
        hold on;
   
% end
end
 

xlim([-5 5]); ylim([-5 5]);
axis square;
ylabel('Y voltage');
xlabel('X voltage');
set(gca,'YDir','reverse'); 
set(gca,'XDir','reverse')
title(datestr(obs(end).timestamp));
%legend([le re h],'Left Eye','Right Eye','(x,y) dva','Location','BestOutside')
%legend([le re],'Left Eye','Right Eye','Location','BestOutside')
