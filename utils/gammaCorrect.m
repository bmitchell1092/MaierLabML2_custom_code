function [corRGB] = gammaCorrect(rgbval,monitor,gun)

%rgbval is uncorrected rgb value you want to correct
%monname is monitor you will display it on (for example, '022NEC'--NEC
%monitor in room 022)

if class(monitor) ~= 'char'
    error('invalid monitor name\n');
end

if any(rgbval>255) | any(rgbval<0)
    error('invalid rgb values');
end

if any(rgbval(:) >1)
    rgbval = rgbval./255;
end

rgbval = double(rgbval);

switch monitor
    case '022NEC'
        
        RgammaValue = [1.89529545781256];
        GgammaValue = [1.91693821238065];
        BgammaValue = [1.94936132373926];
        if gun == 1
            corRGB = rgbval .^ (1/RgammaValue);
        elseif gun == 2
            corRGB = rgbval .^ (1/GgammaValue);
        else
            corRGB = rgbval .^ (1/BgammaValue);
        end
        
        corRGB = ceil(corRGB .* 255);
        
    case '022MIT'
        RgammaValue = 2.196721236900493;
        GgammaValue = 2.358728059232701;
        BgammaValue = 2.142137491570094;
        if gun == 1
            corRGB = rgbval .^ (1/RgammaValue);
        elseif gun == 2
            corRGB = rgbval .^ (1/GgammaValue);
        else
            corRGB = rgbval .^ (1/BgammaValue);
        end
        
        corRGB = ceil(corRGB .* 255);
        
    case '021MIT'
%         RgammaValue = 2.196721236900493;
%         GgammaValue = 2.358728059232701;
%         BgammaValue = 2.142137491570094;
%         load('C:\Users\MLab\Documents\autogammacorrect\gammaValues.mat');         
RgammaValue = [2.54770021931163];
GgammaValue = [3.06558562709144];
BgammaValue = [2.56930933531134];
        
        if gun == 1
            corRGB = rgbval .^ (1/RgammaValue);
        elseif gun == 2
            corRGB = rgbval .^ (1/GgammaValue);
        else
            corRGB = rgbval .^ (1/BgammaValue);
        end
        
        corRGB = ceil(corRGB .* 255);
        
end




%         %original measurements on 022 NEC CRT (3 trials each contrast):
%         testpts = [0,0.0625000000000000,0.125000000000000,0.187500000000000,0.250000000000000,0.312500000000000,0.375000000000000,0.437500000000000,0.500000000000000,0.562500000000000,0.625000000000000,0.687500000000000,0.750000000000000,0.812500000000000,0.875000000000000,0.937500000000000,1]; % 0-1 (rgb val*255 = 0 - 255 scale) contrasts tested
%         rlum = [0.550000000000000,0.550000000000000,0.550000000000000;0.650000000000000,0.670000000000000,0.670000000000000;0.820000000000000,0.830000000000000,0.800000000000000;1.04000000000000,1.05000000000000,1.03000000000000;1.28000000000000,1.28000000000000,1.27000000000000;1.59000000000000,1.60000000000000,1.60000000000000;1.95000000000000,1.98000000000000,1.98000000000000;2.44000000000000,2.45000000000000,2.41000000000000;2.91000000000000,2.93000000000000,2.95000000000000;3.55000000000000,3.56000000000000,3.50000000000000;4.16000000000000,4.18000000000000,4.22000000000000;4.94000000000000,4.92000000000000,4.85000000000000;5.74000000000000,5.75000000000000,5.76000000000000;6.62000000000000,6.61000000000000,6.54000000000000;7.60000000000000,7.62000000000000,7.65000000000000;8.67000000000000,8.63000000000000,8.66000000000000;9.72000000000000,10,9.80000000000000];
%         glum = [0.550000000000000,0.530000000000000,0.550000000000000;0.720000000000000,0.840000000000000,0.870000000000000;1.30000000000000,1.30000000000000,1.30000000000000;1.92000000000000,1.97000000000000,1.97000000000000;2.76000000000000,2.74000000000000,2.77000000000000;3.78000000000000,3.78000000000000,3.85000000000000;4.93000000000000,4.97000000000000,4.94000000000000;6.37000000000000,6.36000000000000,6.46000000000000;7.91000000000000,8.08000000000000,8.16000000000000;9.84000000000000,9.90000000000000,10;11.8100000000000,11.8000000000000,11.8700000000000;14.4700000000000,14.3000000000000,14.4600000000000;17.1000000000000,16.8400000000000,16.9200000000000;20.0500000000000,20.2000000000000,19.8500000000000;22.7800000000000,23.3200000000000,22.6000000000000;26.1300000000000,26.5400000000000,26.2000000000000;29.6500000000000,29.9600000000000,30.0200000000000];
%         blum = [0.550000000000000,0.570000000000000,0.550000000000000;0.600000000000000,0.600000000000000,0.620000000000000;0.670000000000000,0.660000000000000,0.680000000000000;0.720000000000000,0.760000000000000,0.760000000000000;0.870000000000000,0.880000000000000,0.870000000000000;1.05000000000000,1.03000000000000,1.01000000000000;1.15000000000000,1.17000000000000,1.16000000000000;1.39000000000000,1.37000000000000,1.37000000000000;1.64000000000000,1.61000000000000,1.60000000000000;1.85000000000000,1.87000000000000,1.88000000000000;2.15000000000000,2.17000000000000,2.20000000000000;2.52000000000000,2.51000000000000,2.54000000000000;2.90000000000000,2.89000000000000,2.89000000000000;3.28000000000000,3.33000000000000,3.31000000000000;3.77000000000000,3.78000000000000,3.78000000000000;4.29000000000000,4.25000000000000,4.23000000000000;4.87000000000000,4.83000000000000,4.76000000000000];
%         
%         cIn = [0:16:240 255];
%         % RED GUN:
%         mlum   = mean(rlum,2)' - mean(rlum(1,:),2);
%         lummax = max(mlum); %max luminance
%         lumpc = (mlum./repmat(lummax,length(testpts),1)'); %percent lum (rel to min/max)
%         
%         % fit data to function to find gamma value
%         in = inline('sum( ((lum .^ (1/g)) - lin ) .^2)','g','lum','lin');
%         RgammaValue = fminbnd(in,1,10,[],lumpc,testpts);
%         
%         fprintf('R gamma value: %0.03d\n',RgammaValue);
%         
%         figure,
%         
%         subplot(1,3,1);
%         plot(testpts*255,mlum,'r.');
%         hold on;
%         plot(testpts*255,mlum(1) + ((testpts).^ RgammaValue) * mlum(end),'r--');
%         xlabel('uncorrected input value');
%         ylabel('output luminance');
%         legend('display output',['fit with gamma= ' num2str(RgammaValue)],'Location','SouthOutside');
%         set(gca,'ylim',[0 lummax]);
%         hold off;
%         title(gca,'Display charcteristic');
%         
%         subplot(1,3,2);
%         plot(testpts*255,mlum(1) + testpts .^ (1/RgammaValue) * 255);
%         title('Inverse gamma');
%         xlabel('uncorrected input value');
%         ylabel('corrected input value');
%         set(gca,'ytick',(testpts(1:4:end))*255,'xlim',[0 255],'ylim',[0 255]);
%         legend('y = x\^(1/gamma)','Location','SouthOutside');
%         
%         subplot(1,3,3)
%         cOut = lumpc .^ (1/RgammaValue) * lummax;
%         x = testpts*255;
%         y = cOut + mlum(1);
%         plot(x,y,'.'); hold on
%         disp([cIn cOut]);
%         p = polyfit(x,y,1);
%         yfit = polyval(p,x);
%         plot(x,yfit,'r')
%         yresid = y - yfit;
%         SSresid = sum(yresid.^2);
%         SStotal = (length(y)-1) * var(y);
%         rsq = 1 - SSresid/SStotal;
%         disp(rsq);
%         title('Linearized');
%         xlabel('corrected input value');
%         ylabel('output luminance');
%         set(gca,'ylim',[0 lummax]);
%         legend('corrected display output',['linear fit, R^2= ' num2str(rsq)],'Location','SouthOutside');
%         
%         
%         
%         % GREEN GUN:
%         clear mlum lummax lumpc in
%         mlum   = mean(glum,2)' - mean(glum(1,:),2);
%         lummax = max(mlum); %max luminance
%         lumpc = (mlum./repmat(lummax,length(testpts),1)'); %percent lum (rel to min/max)
%         
%         % fit data to function to find gamma value
%         in = inline('sum( ((lum .^ (1/g)) - lin ) .^2)','g','lum','lin');
%         GgammaValue = fminbnd(in,1,10,[],lumpc,testpts);
%         
%         fprintf('G gamma value: %0.03d\n',GgammaValue);
%         
%         figure,
%         
%         subplot(1,3,1);
%         plot(testpts*255,mlum,'g.');
%         hold on;
%         plot(testpts*255,mlum(1) + ((testpts).^ GgammaValue) * mlum(end),'r--');
%         xlabel('uncorrected input value');
%         ylabel('output luminance');
%         legend('display output',['fit with gamma= ' num2str(GgammaValue)],'Location','SouthOutside');
%         set(gca,'ylim',[0 lummax]);
%         hold off;
%         title(gca,'Display charcteristic');
%         
%         subplot(1,3,2);
%         plot(testpts*255,mlum(1) + testpts .^ (1/GgammaValue) * 255);
%         title('Inverse gamma');
%         xlabel('uncorrected input value');
%         ylabel('corrected input value');
%         set(gca,'ytick',(testpts(1:4:end))*255,'xlim',[0 255],'ylim',[0 255]);
%         legend('y = x\^(1/gamma)','Location','SouthOutside');
%         
%         subplot(1,3,3)
%         cOut = lumpc .^ (1/GgammaValue) * lummax;
%         x = testpts*255;
%         y = cOut + mlum(1);
%         plot(x,y,'.'); hold on
%         disp([cIn cOut]);
%         p = polyfit(x,y,1);
%         yfit = polyval(p,x);
%         plot(x,yfit,'r')
%         yresid = y - yfit;
%         SSresid = sum(yresid.^2);
%         SStotal = (length(y)-1) * var(y);
%         rsq = 1 - SSresid/SStotal;
%         disp(rsq);
%         title('Linearized');
%         xlabel('corrected input value');
%         ylabel('output luminance');
%         set(gca,'ylim',[0 lummax]);
%         legend('corrected display output',['linear fit, R^2= ' num2str(rsq)],'Location','SouthOutside');
%         
%         % BLUE GUN:
%         clear mlum lummax lumpc in
%         mlum   = mean(blum,2)' - mean(blum(1,:),2);
%         lummax = max(mlum); %max luminance
%         lumpc = (mlum./repmat(lummax,length(testpts),1)'); %percent lum (rel to min/max)
%         
%         % fit data to function to find gamma value
%         in = inline('sum( ((lum .^ (1/g)) - lin ) .^2)','g','lum','lin');
%         BgammaValue = fminbnd(in,1,10,[],lumpc,testpts);
%         
%         fprintf('B gamma value: %0.03d\n',BgammaValue);
%         
%         figure,
%         
%         subplot(1,3,1);
%         plot(testpts*255,mlum,'b.');
%         hold on;
%         plot(testpts*255,mlum(1) + ((testpts).^ BgammaValue) * mlum(end),'r--');
%         xlabel('uncorrected input value');
%         ylabel('output luminance');
%         legend('display output',['fit with gamma= ' num2str(BgammaValue)],'Location','SouthOutside');
%         set(gca,'ylim',[0 lummax]);
%         hold off;
%         title(gca,'Display charcteristic');
%         
%         subplot(1,3,2);
%         plot(testpts*255,mlum(1) + testpts .^ (1/BgammaValue) * 255);
%         title('Inverse gamma');
%         xlabel('uncorrected input value');
%         ylabel('corrected input value');
%         set(gca,'ytick',(testpts(1:4:end))*255,'xlim',[0 255],'ylim',[0 255]);
%         legend('y = x\^(1/gamma)','Location','SouthOutside');
%         
%         subplot(1,3,3)
%         cOut = lumpc .^ (1/BgammaValue) * lummax;
%         x = testpts*255;
%         y = cOut + mlum(1);
%         plot(x,y,'.'); hold on
%         disp([cIn cOut]);
%         p = polyfit(x,y,1);
%         yfit = polyval(p,x);
%         plot(x,yfit,'r')
%         yresid = y - yfit;
%         SSresid = sum(yresid.^2);
%         SStotal = (length(y)-1) * var(y);
%         rsq = 1 - SSresid/SStotal;
%         disp(rsq);
%         title('Linearized');
%         xlabel('corrected input value');
%         ylabel('output luminance');
%         set(gca,'ylim',[0 lummax]);
%         legend('corrected display output',['linear fit, R^2= ' num2str(rsq)],'Location','SouthOutside');
%         
%         
% corRGB = ceil(corRGB .* 255);         
end

%%
% cd('c:/users/user/documents/gitMonkeyLogic/UTILS/gammacorrectiondata')
% 
% load('rightred'); load('leftred'); 
% load('rightgreen'); load('leftgreen'); 
% load('rightblue'); load('leftblue'); 
% load('rightlum'); load('leftlum'); 
% 
% figure, 
% set(gcf,'Color','w','Position',[1 1 1000 800]); 
% subplot(2,2,1)
% plot(testpts,rightred,'-.r'); 
% hold on; 
% plot(testpts,leftred,'r');
% set(gca,'Box','off','FontSize',14,'TickDir','out');
% title(gca,'RED gun'); legend(gca,'right side','','','leftside','','','Location','northeastoutside'); 
% xlabel('contrast level'); ylabel('cd/m^2')
% 
% subplot(2,2,2)
% plot(testpts,rightgreen,'-.g'); 
% hold on; 
% plot(testpts,leftgreen,'g');
% set(gca,'Box','off','FontSize',14,'TickDir','out'); 
% title(gca,'GREEN gun'); legend(gca,'right side','','','leftside','','','Location','northeastoutside'); 
% xlabel('contrast level'); ylabel('cd/m^2')
% 
% subplot(2,2,3)
% plot(testpts,rightblue,'-.b'); 
% hold on; 
% plot(testpts,leftblue,'b');
% set(gca,'Box','off','FontSize',14,'TickDir','out'); 
% title(gca,'BLUE gun'); legend(gca,'right side','','','leftside','','','Location','northeastoutside'); 
% xlabel('contrast level'); ylabel('cd/m^2')
% 
% 
% % subplot(2,2,4)
% % plot(testpts,rightlum,'-.','Color',[0.5 0.5 0.5]); 
% % hold on; 
% % plot(testpts,leftlum,'Color',[0.5 0.5 0.5]);
% % set(gca,'Box','off','FontSize',14,'TickDir','out'); 
% % title(gca,'ALL guns'); legend(gca,'right side','leftside','Location','northeastoutside'); 
% % xlabel('contrast level'); ylabel('cd/m^2')
% %%
% figure, 
% set(gcf,'Color','w','Position',[1 1 1000 800]); 
% subplot(2,2,1)
% plot(testpts,mean(rightred),'-.r'); 
% hold on; 
% plot(testpts,mean(leftred),'r');
% set(gca,'Box','off','FontSize',14,'TickDir','out');
% title(gca,'RED gun'); legend(gca,'right side','leftside','Location','northeastoutside'); 
% xlabel('contrast level'); ylabel('cd/m^2')
% 
% subplot(2,2,2)
% plot(testpts,mean(rightgreen),'-.g'); 
% hold on; 
% plot(testpts,mean(leftgreen),'g');
% set(gca,'Box','off','FontSize',14,'TickDir','out'); 
% title(gca,'GREEN gun'); legend(gca,'right side','leftside','Location','northeastoutside'); 
% xlabel('contrast level'); ylabel('cd/m^2')
% 
% subplot(2,2,3)
% plot(testpts,mean(rightblue),'-.b'); 
% hold on; 
% plot(testpts,mean(leftblue),'b');
% set(gca,'Box','off','FontSize',14,'TickDir','out'); 
% title(gca,'BLUE gun'); legend(gca,'right side','leftside','Location','northeastoutside'); 
% xlabel('contrast level'); ylabel('cd/m^2')
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure, 
% set(gcf,'Color','w','Position',[1 1 1000 800]); 
% subplot(2,2,1)
% plot(testpts,mean(rightred)-mean(leftred),'o-r'); 
% set(gca,'Box','off','FontSize',14,'TickDir','out');
% title(gca,'delta right/left RED gun'); 
% xlabel('contrast level'); ylabel('delta cd/m^2')
% 
% subplot(2,2,2)
% plot(testpts,mean(rightgreen)-mean(leftgreen),'o-g'); 
% set(gca,'Box','off','FontSize',14,'TickDir','out'); 
% title(gca,'delta right/left GREEN gun'); 
% xlabel('contrast level'); ylabel('delta cd/m^2')
% 
% subplot(2,2,3)
% plot(testpts,mean(rightblue)-mean(leftblue),'o-b'); 
% set(gca,'Box','off','FontSize',14,'TickDir','out'); 
% title(gca,'delta right/left BLUE gun'); 
% xlabel('contrast level'); ylabel('delta cd/m^2')
% 
% % subplot(2,2,4)
% % plot(testpts,rightlum-leftlum,'o-k'); 
% % set(gca,'Box','off','FontSize',14,'TickDir','out'); 
% % title(gca,'delta right/left ALL guns');
% % xlabel('contrast level');ylabel('delta cd/m^2')
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure, 
% set(gcf,'Color','w','Position',[1 1 1000 800]); 
% subplot(2,2,1)
% mlum = mean(cat(2,rightred,leftred)); 
% plot(testpts,(rightred-leftred)./(mlum),'o-r'); 
% set(gca,'Box','off','FontSize',14,'TickDir','out');
% title(gca,'delta lum/mean lum right/left RED gun'); 
% xlabel('contrast level'); ylabel('delta/mean')
% 
% subplot(2,2,2)
% mlum = mean(cat(2,rightgreen,leftgreen)); 
% plot(testpts,(rightgreen-leftgreen)./(mlum),'o-g'); 
% set(gca,'Box','off','FontSize',14,'TickDir','out'); 
% title(gca,'delta lum/mean lum GREEN gun'); 
% xlabel('contrast level'); ylabel('delta/mean')
% 
% subplot(2,2,3)
% mlum = mean(cat(2,rightblue,leftblue));
% plot(testpts,(rightblue-leftblue)./(mlum),'o-b'); 
% set(gca,'Box','off','FontSize',14,'TickDir','out'); 
% title(gca,'delta lum/mean lum BLUE gun'); 
% xlabel('contrast level'); ylabel('delta/mean')
% 
% subplot(2,2,4)
% mlum = mean(cat(2,rightlum,leftlum)); 
% plot(testpts,(rightlum-leftlum)./mlum,'o-k'); 
% set(gca,'Box','off','FontSize',14,'TickDir','out'); 
% title(gca,'delta lum/mean lum ALL guns');
% xlabel('contrast level');ylabel('delta/mean')
% 
% 
% 
% figure, 
% set(gcf,'Color','w','Position',[1 1 1000 800]); 
% subplot(2,2,1)
% plot(testpts,rightred,'ro','MarkerFacecolor','r'); 
% hold on; 
% plot(testpts,leftred,'ro');
% set(gca,'Box','off','FontSize',14,'TickDir','out');
% title(gca,'RED gun'); legend(gca,'right side','','','leftside','','','Location','northeastoutside'); 
% xlabel('contrast level'); ylabel('cd/m^2')
% 
% subplot(2,2,2)
% plot(testpts,rightgreen,'go','MarkerFaceColor','g'); 
% hold on; 
% plot(testpts,leftgreen,'go');
% set(gca,'Box','off','FontSize',14,'TickDir','out'); 
% title(gca,'GREEN gun'); legend(gca,'right side','','','leftside','','','Location','northeastoutside'); 
% xlabel('contrast level'); ylabel('cd/m^2')
% 
% subplot(2,2,3)
% plot(testpts,rightblue,'bo','MarkerFaceColor','b'); 
% hold on; 
% plot(testpts,leftblue,'bo');
% set(gca,'Box','off','FontSize',14,'TickDir','out'); 
% title(gca,'BLUE gun'); legend(gca,'right side','','','leftside','','','Location','northeastoutside'); 
% xlabel('contrast level'); ylabel('cd/m^2')
% 
% figure, 
% plot(testpts, R,'ro'); 
% hold on
% plot(testpts,G,'go'); 
% hold on
% plot(testpts,B,'bo'); 
% ylabel('luminance'); xlabel('rgb value'); 

% vals = [14.91 18.77; 12.49 19.89; 11.21 21.67; 9.95 22.91; 8.68 24.19; 7.06 25.22; 5.75 26.75; 4.60 27.38; 2.94 27.57; 15.08 17.22]; 
% vals2 = [13.70 18.59; 12.41 20.30; 11.05 20.93; 9.97 22.85; 8.20 24.15; 6.89 25.33; 5.54 26.65; 4.21 27.54; 2.83 27.96; 14.96 16.95]; 
% for i = 1:length(vals)
%     
%     mc(i) = (vals(i,2) - vals(i,1))./(vals(i,1) + vals(i,2)); 
%        mc2(i) = (vals2(i,2) - vals2(i,1))./(vals2(i,1) + vals2(i,2)); 
%     
% end
% contrasts        = [.1:.1:1];
% for i = 1:10
%     CurrentTrialNumber = i; 
%     
% grating_contrast(i) = contrasts(mod(CurrentTrialNumber,length(contrasts))+1);
% end