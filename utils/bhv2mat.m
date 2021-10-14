%Kacie, 05/13/2014
%Michele, 07/15/14

cd('C:\Users\MLab\Documents')

[filelist,path] = uigetfile('.bhv','MultiSelect','on');
if ~iscell(filelist);
    filelist = {filelist};
end

 for i = 1:length(filelist)
    clear BHV filename
    
     filename = fullfile(path,filelist{i});
     BHV      = bhv_read(filename);
     
     save(strcat(path,BHV.DataFileName,'.mat'),'BHV');
     
 end
 
 