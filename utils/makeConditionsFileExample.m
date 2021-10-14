
eccentricity = 3;
theta = [360/8:360/8:360] - 360/8/2;

fid = fopen('C:\Users\MLab\Documents\spatial-featural-dms\sfdms_nodistractor.txt','w');
header = generate_condition('Header', 8, 'FID', fid);
fprintf(fid,'\r\n');

ct=0;

clear Info
Info.dms =  'f';

clear textline

%BLOCKS = {'grating distractor','no distracotr'};
BLOCKS = {'no distractor'};
bmax = length(BLOCKS);
for b = 1:bmax
    block = BLOCKS{b};
    
    
    for sc = 1:length(theta);
        [x y] = pol2cart(degtorad(theta(sc)),eccentricity);
        sample_cord = [x y];
        for tc = 1:length(theta);
            [x y] = pol2cart(degtorad(theta(tc)),eccentricity);
            target_cord = [x y];
            for dc = 1:length(theta);
                [x y] = pol2cart(degtorad(theta(dc)),eccentricity);
                distractor_cord = [x y];
                
                if isequal(distractor_cord,target_cord)
                    % do not want distractor and target at same location
                    continue
                elseif isequal(sample_cord,target_cord) || isequal(sample_cord,distractor_cord)
                    % for initial training, do not want sample and target/distractor at same location
                    continue
                end
                
                clear TaskObject
                ct = ct + 1;
                
                % sample
                TaskObject(1).Type = 'gen';
                TaskObject(1).Arg{1} = 'gTargetGrating';
                TaskObject(1).Arg{2} = sample_cord(1);
                TaskObject(1).Arg{3} = sample_cord(2);
                
                % target
                TaskObject(2).Type = 'gen';
                TaskObject(2).Arg{1} =  'gTargetGrating';
                TaskObject(2).Arg{2} = target_cord(1);
                TaskObject(2).Arg{3} = target_cord(2);
                
                % distractor
                switch block
                    case 'grating distractor'
                        TaskObject(3).Type = 'gen';
                        TaskObject(3).Arg{1} =  'gDistractorGrating';
                        TaskObject(3).Arg{2} = distractor_cord(1);
                        TaskObject(3).Arg{3} = distractor_cord(2);
                    case 'no distractor'
                        TaskObject(3).Type = 'sqr';
                        TaskObject(3).Arg{1} = .5;
                        TaskObject(3).Arg{2} = [.5 .5 .5];
                        TaskObject(3).Arg{3} = 1;
                        TaskObject(3).Arg{4} = distractor_cord(1);
                        TaskObject(3).Arg{5} = distractor_cord(2);
                    otherwise
                        error('provide block info')
                end
                
                % various "error squares" and fixation cues:
                
                %sqr(5,[1 0 0], 1,  0,  0)
                TaskObject(4).Type = 'sqr';
                TaskObject(4).Arg{1} = 5;
                TaskObject(4).Arg{2} = [1 0 0];
                TaskObject(4).Arg{3} = 1;
                TaskObject(4).Arg{4} = 0;
                TaskObject(4).Arg{5} = 0;
                
                %sqr(5,[0 0 0], 1,  0,  0)
                TaskObject(5).Type = 'sqr';
                TaskObject(5).Arg{1} = 5;
                TaskObject(5).Arg{2} = [0 0 0];
                TaskObject(5).Arg{3} = 1;
                TaskObject(5).Arg{4} = 0;
                TaskObject(5).Arg{5} = 0;
                
                %sqr(5,[1 1 1], 1,  0,  0)
                TaskObject(6).Type = 'sqr';
                TaskObject(6).Arg{1} = 5;
                TaskObject(6).Arg{2} = [1 1 1];
                TaskObject(6).Arg{3} = 1;
                TaskObject(6).Arg{4} = 0;
                TaskObject(6).Arg{5} = 0;
                
                %crc(0.2,[0 1 1], 0,  0,  0)
                TaskObject(7).Type = 'crc';
                TaskObject(7).Arg{1} = 0.2;
                TaskObject(7).Arg{2} = [0 1 1];
                TaskObject(7).Arg{3} = 0;
                TaskObject(7).Arg{4} = 0;
                TaskObject(7).Arg{5} = 0;
                
                %crc(0.2,[0 1 1], 1,  0,  0)
                TaskObject(8).Type = 'crc';
                TaskObject(8).Arg{1} = 0.2;
                TaskObject(8).Arg{2} = [0 1 1];
                TaskObject(8).Arg{3} = 1;
                TaskObject(8).Arg{4} = 0;
                TaskObject(8).Arg{5} = 0;
                
                
                
                % make textline
                textline{ct,1} = generate_condition('Condition', ct, 'Block', [b bmax+1], 'Frequency', 1, 'TimingFile', 'tSFDMS_gen', 'Info', Info, 'TaskObject', TaskObject,'FID',fid);
                
            end
        end
    end
end

fclose(fid);
fprintf('\n DONE! \n')


