function n_juice = uRewardSchedule(type,n_juice,TrialRecord)
% allows user to specify a reward scheme of "type" 
% with n_juice serving as min/start number of pumps
%
% dev note: add a "params" structure as last (optional) vargin
% that can have diffrent fields of parameters for the diffrent reward types. 
% also, does ML record number of juice pumps given??
%
% December 2013, MAC 

% "type" can be a string or a number
if isstr(type)
    lower(type);
elseif type > 0
    % 0 = constant
    % 1 = random
    % 2 = pyramid
    stringcode = {'random','pyramid'};
    type = stringcode{type};
end

switch type 
    case 'random'
        % give a random number of pumps (1-5)
        n_juice = randi([n_juice,n_juice*4],1);
        
    case 'pyramid'
        % make reward dependent on behavior in prior trials
        if TrialRecord.CurrentTrialNumber > 1
            if TrialRecord.TrialErrors(end) == 0 % previous trial good
              
                % find number of consecutive error-free trials (error code 0)
                noerrors = TrialRecord.TrialErrors == 0;
                if  all(noerrors)
                    n = length(noerrors);
                else
                    n = length(noerrors) - find(diff(noerrors),1,'last');
                end
                % cap extra pumps of juice
                if n_juice == 1
                    maxjuice = 4;
                else
                    maxjuice = 6;
                end
                if n > maxjuice
                    n = maxjuice;
                end
                
                % get n_juice for 1st error-free trial, 
                % get one more pump for each additional error-free trial
                n_juice = n_juice + (n - 1); 
            end
        end
        
        
    otherwise
        % give n_juice pumps of reward
        n_juice = n_juice;
end