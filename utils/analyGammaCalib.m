% compute test points for gamma calibration 

% find test points to display on monitor: 
bits = 4; 
val = round(0.5 * 2 .^ bits) / 2 .^ bits; % start with middle gray (0.5)
catval = [val]; 

% move from middle to 0: 
nval = 0.5; 
while nval >0
nval = nval - 2 .^ -4; 
nval = round(nval * 2 .^ bits) / 2 .^ bits; 
nval = max(0,min(1,nval)); 
catval = [catval nval]; 
end

% move from middle to 1: 
nval = 0.5; 
while nval <1
nval = nval + 2 .^ -4; 
nval = round(nval * 2 .^ bits) / 2 .^ bits; 
nval = max(0,min(1,nval)); 
catval = [catval nval]; 
end

% sort values from 0 to 1: 
testpts = sort(catval,'ascend'); 

%%
load('C:\Users\MLab\documents\gitMonkeyLogic\RGB_uncorrected_MIT'); 
% load('C:\Users\user\documents\gitMonkeyLogic\022MIT_leftside_uncorrectedlum'); 
rlum = R; glum = G; blum = B; 

cIn = [0:16:240 255];
% RED GUN: 
if size(rlum,1) >1
mlum   = mean(rlum,2)' - mean(rlum(1,:),2); 
lummax = max(mlum); %max luminance 
lumpc = (mlum./repmat(lummax,length(testpts),1)'); %percent lum (rel to min/max)
else
    mlum   = rlum;
lummax = max(mlum); %max luminance 
lumpc = (mlum./repmat(lummax,length(testpts),1)'); %percent lum (rel to min/max)
end

% fit data to function to find gamma value
in = inline('sum( ((lum .^ (1/g)) - lin ) .^2)','g','lum','lin'); 
RgammaValue = fminbnd(in,1,10,[],lumpc,testpts); 

fprintf('R gamma value: %0.03d\n',RgammaValue); 

figure, 

subplot(1,3,1); 
plot(testpts*255,mlum,'r.'); 
hold on; 
plot(testpts*255,mlum(1) + ((testpts).^ RgammaValue) * mlum(end),'r--'); 
xlabel('uncorrected input value'); 
ylabel('output luminance'); 
legend('display output',['fit with gamma= ' num2str(RgammaValue)],'Location','SouthOutside'); 
set(gca,'ylim',[0 lummax]); 
hold off; 
title(gca,'Display charcteristic'); 

subplot(1,3,2); 
plot(testpts*255,mlum(1) + testpts .^ (1/RgammaValue) * 255); 
title('Inverse gamma'); 
xlabel('uncorrected input value'); 
ylabel('corrected input value'); 
set(gca,'ytick',(testpts(1:4:end))*255,'xlim',[0 255],'ylim',[0 255]); 
legend('y = x\^(1/gamma)','Location','SouthOutside');  

subplot(1,3,3)
cOut = lumpc .^ (1/RgammaValue) * lummax; 
x = testpts*255;
y = cOut + mlum(1);
plot(x,y,'.'); hold on
disp([cIn cOut]); 
p = polyfit(x,y,1);
yfit = polyval(p,x);
plot(x,yfit,'r')
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1) * var(y);
rsq = 1 - SSresid/SStotal;
disp(rsq);
title('Linearized'); 
xlabel('corrected input value'); 
ylabel('output luminance'); 
set(gca,'ylim',[0 lummax]); 
legend('corrected display output',['linear fit, R^2= ' num2str(rsq)],'Location','SouthOutside'); 



% GREEN GUN: 
clear mlum lummax lumpc in 
if size(glum,1) > 1
mlum   = mean(glum,2)' - mean(glum(1,:),2); 
lummax = max(mlum); %max luminance 
lumpc = (mlum./repmat(lummax,length(testpts),1)'); %percent lum (rel to min/max)
else
   mlum   = glum;
lummax = max(mlum); %max luminance 
lumpc = (mlum./repmat(lummax,length(testpts),1)'); %percent lum (rel to min/max) 
end

% fit data to function to find gamma value
in = inline('sum( ((lum .^ (1/g)) - lin ) .^2)','g','lum','lin'); 
GgammaValue = fminbnd(in,1,10,[],lumpc,testpts); 

fprintf('G gamma value: %0.03d\n',GgammaValue); 

figure, 

subplot(1,3,1); 
plot(testpts*255,mlum,'g.');  
hold on; 
plot(testpts*255,mlum(1) + ((testpts).^ GgammaValue) * mlum(end),'r--'); 
xlabel('uncorrected input value'); 
ylabel('output luminance'); 
legend('display output',['fit with gamma= ' num2str(GgammaValue)],'Location','SouthOutside'); 
set(gca,'ylim',[0 lummax]); 
hold off; 
title(gca,'Display charcteristic'); 

subplot(1,3,2); 
plot(testpts*255,mlum(1) + testpts .^ (1/GgammaValue) * 255); 
title('Inverse gamma'); 
xlabel('uncorrected input value'); 
ylabel('corrected input value'); 
set(gca,'ytick',(testpts(1:4:end))*255,'xlim',[0 255],'ylim',[0 255]); 
legend('y = x\^(1/gamma)','Location','SouthOutside');  

subplot(1,3,3)
cOut = lumpc .^ (1/GgammaValue) * lummax; 
x = testpts*255;
y = cOut + mlum(1);
plot(x,y,'.'); hold on
disp([cIn cOut]); 
p = polyfit(x,y,1);
yfit = polyval(p,x);
plot(x,yfit,'r')
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1) * var(y);
rsq = 1 - SSresid/SStotal;
disp(rsq);
title('Linearized'); 
xlabel('corrected input value'); 
ylabel('output luminance'); 
set(gca,'ylim',[0 lummax]); 
legend('corrected display output',['linear fit, R^2= ' num2str(rsq)],'Location','SouthOutside'); 

% BLUE GUN: 
clear mlum lummax lumpc in 
if size(blum,1) > 1
mlum   = mean(blum,2)' - mean(blum(1,:),2); 
lummax = max(mlum); %max luminance 
lumpc = (mlum./repmat(lummax,length(testpts),1)'); %percent lum (rel to min/max)
else
  mlum   = blum;
lummax = max(mlum); %max luminance 
lumpc = (mlum./repmat(lummax,length(testpts),1)'); %percent lum (rel to min/max)  
end

% fit data to function to find gamma value
in = inline('sum( ((lum .^ (1/g)) - lin ) .^2)','g','lum','lin'); 
BgammaValue = fminbnd(in,1,10,[],lumpc,testpts); 

fprintf('B gamma value: %0.03d\n',BgammaValue); 

figure, 

subplot(1,3,1); 
plot(testpts*255,mlum,'b.'); 
hold on; 
plot(testpts*255,mlum(1) + ((testpts).^ BgammaValue) * mlum(end),'r--'); 
xlabel('uncorrected input value'); 
ylabel('output luminance'); 
legend('display output',['fit with gamma= ' num2str(BgammaValue)],'Location','SouthOutside');  
set(gca,'ylim',[0 lummax]); 
hold off; 
title(gca,'Display charcteristic'); 

subplot(1,3,2); 
plot(testpts*255,mlum(1) + testpts .^ (1/BgammaValue) * 255); 
title('Inverse gamma'); 
xlabel('uncorrected input value'); 
ylabel('corrected input value'); 
set(gca,'ytick',(testpts(1:4:end))*255,'xlim',[0 255],'ylim',[0 255]); 
legend('y = x\^(1/gamma)','Location','SouthOutside'); 

subplot(1,3,3)
cOut = lumpc .^ (1/BgammaValue) * lummax; 
x = testpts*255;
y = cOut + mlum(1);
plot(x,y,'.'); hold on
disp([cIn cOut]); 
p = polyfit(x,y,1);
yfit = polyval(p,x);
plot(x,yfit,'r')
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1) * var(y);
rsq = 1 - SSresid/SStotal;
disp(rsq);
title('Linearized'); 
xlabel('corrected input value'); 
ylabel('output luminance'); 
set(gca,'ylim',[0 lummax]); 
legend('corrected display output',['linear fit, R^2= ' num2str(rsq)],'Location','SouthOutside'); 

