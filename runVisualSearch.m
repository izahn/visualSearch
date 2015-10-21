function runVisualSearch(subID)
%% PTB experiment template: Visual search
%
% To run, call this function with the id code for your subject, eg:
% runVisualSearch('key1');

%% Set up the experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% settingsVisualSearch; % Load all the settings from the file

%% Settings for image sequence experiment

% Target and distractor images (these are in the "images" folder)
imTarget = 'T.png';
% imTarget_y = 'T_yellow.jpg';
% imTarget_r = 'T_red.jpg';
% imTarget_g = 'T_green.jpg';
% imTarget_b = 'T_blue.jpg';
imDistractor = 'L.png';
% imDistractor_y = 'L_yellow.jpg';
% imDistractor_r = 'L_red.jpg';
% imDistractor_g = 'L_green.jpg';
% imDistractor_b = 'L_blue.jpg';
% I will need to build a list with these images. For distractors something like this:
% distractor_list = [imDistractor_y, imDistractor_r, imDistractor_g, imDistractor_b];
% x = distractor_list;
% distractor_list =  rand();
% for i=1:11;
% if x < .25;
%   'imDistractor_y'
% elseif x < .5;
%   'imDistractor_r'
% elseif x < .75;
%   'imDistractor_g'
% elseif x < .75;
% 'imDistractor_b'
% end;

% If this is correct, I build it this way for targets too.

% Randomly rotate distractors? (1 = yes, 0 = no)
rotateDistractor = 1;

% Set size (number of items to display in each search display).
setSize = 12; % see line 132 of makeSearchDisplay

% Number of trials per block
nTrials = 24;
nBlocks = 16;

% Response keys (for no subject response use empty list)
% 'z' for rotated 'T's to the left and 'm' for rotated 'T's to the right
responseKeys = {'z','m'};
%responseKeys = {};

% Background color: choose a number from 0 (black) to 255 (white): 192 for
% grey
backgroundColor = 192;

% Text color: choose a number from 0 (black) to 255 (white)
textColor = 255;

% How long to wait (in seconds) for subject response before the trial times out
trialTimeout = 0.7;

% How long to pause in between trials (if 0, the experiment will wait for
% the subject to press a key before every trial)
timeBetweenTrials = 0;

rand('state', sum(100*clock)); % Initialize the random number generator

% Keyboard setup
KbName('UnifyKeyNames');
KbCheckList = [KbName('space'),KbName('ESCAPE')];
for i = 1:length(responseKeys)
    KbCheckList = [KbName(responseKeys{i}),KbCheckList];
end
RestrictKeysForKbCheck(KbCheckList);

% Screen setup
clear screen
whichScreen = max(Screen('Screens'));
[window1, rect] = Screen('Openwindow',whichScreen,backgroundColor,[],[],2);
slack = Screen('GetFlipInterval', window1)/2;
W=rect(RectRight); % screen width
H=rect(RectBottom); % screen height
Screen(window1,'FillRect',backgroundColor);
Screen('Flip', window1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set up stimuli lists and results file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the image files for the experiment
imageFolder = 'images';
imageTarget = imread(strcat(imageFolder, '/', imTarget));
imageDistractor = imread(strcat(imageFolder, '/', imDistractor));

% Set up the trials
setSize = repmat(setSize, [nTrials 1]);
targetPresent = ones(nTrials, 1);
targetDirec = rand(nTrials, nBlocks)<0.50;

for i=1:nTrials
   posLocs = randperm(48);
   itemLocs(i,:) = posLocs(1:setSize(i));
end

for i=1:nBlocks
    randomizedTrials(:,i) = randperm(nTrials);
end

% Set up the output file
resultsFolder = 'results';
outputfile = fopen([resultsFolder '/resultfile_' num2str(subID) '.txt'],'a');
fprintf(outputfile, 'subID\t block\t trial\t display\t targetDirec\t setSize\t targetPresent\t response\t RT\n');
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Run experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Start screen
Screen('TextFont', window1, '-misc-fixed-bold-r-normal--13-100-100-100-c-70-iso8859-1') % CHAMGEME!!!
Screen('DrawText',window1,'You will see "T" and "L" stimuli. Your job is to search for a rotated "T" stimuli as quickly and accurately as possible. Press the "z" key for rotated "T"s to the left and the key "m" for rotated keys to the right. You may receive a mild electric stimulation if your reponse is not made before the "T" stimulus disappears. Press the space bar to begin', (W/2-300), (H/2), textColor);
Screen('Flip',window1)
% Wait for subject to press spacebar
while 1
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyCode(KbName('space'))==1
        break
    end
end

% Draw a fixation cross (overlapping horizontal and vertical bar)
function drawCross(window,W,H)
    barLength = 16; % in pixels
    barWidth = 2; % in pixels
    barColor = 0.5; % number from 0 (black) to 1 (white) 
    Screen('FillRect', window, barColor,[ (W-barLength)/2 (H-barWidth)/2 (W+barLength)/2 (H+barWidth)/2]);
    Screen('FillRect', window, barColor ,[ (W-barWidth)/2 (H-barLength)/2 (W+barWidth)/2 (H+barLength)/2]);
end

% Run experimental trials
for b = 1:nBlocks
    for n = 1:nTrials
        t = randomizedTrials(n,b);
        
        % Make search display
        img = makeSearchDisplay(itemLocs(t,:),targetDirec(n,b),imageTarget,imageDistractor,setSize(t),targetPresent(t),rotateDistractor,rect,backgroundColor);
        imageDisplay = Screen('MakeTexture', window1, img);

        % Calculate image position (center of the screen)
        imageSize = size(img);
        pos = [(W-imageSize(2))/2 (H-imageSize(1))/2 (W+imageSize(2))/2 (H+imageSize(1))/2];

        % Screen priority
        Priority(MaxPriority(window1));
        Priority(2);

        % Show fixation cross
        fixationDuration = 0.5; % Length of fixation in seconds
        drawCross(window1,W,H);
        tFixation = Screen('Flip', window1);

        % Blank screen
        Screen(window1, 'FillRect', backgroundColor);
        Screen('Flip', window1, tFixation + fixationDuration - slack,0);

        % Show the search display
        Screen(window1, 'FillRect', backgroundColor);
        Screen('DrawTexture', window1, imageDisplay, [], pos);
        startTime = Screen('Flip', window1); % Start of trial

        % Get keypress response
        rt = 0;
        resp = 0;
        while GetSecs - startTime < trialTimeout
            [keyIsDown,secs,keyCode] = KbCheck;
            respTime = GetSecs;
            pressedKeys = find(keyCode);
            
            if t<=(nTrials/2/3) % one third of the 'old' displays that will be paired with shock
                % Send shock on these trials!
                else
                pause (0.2);    
            end
            
            %%% For Blocks 21-36: receive four shocks for new stimuli
            % Subjects receive a shock here for one third of the 'new' displays that will be paired with shock
            % if targetPresent = false 
            %    ?<=(nTrials/2/3)
            %    Send shock on these trials!
            %    else
            %    pause (0.2);    
            % end
            
            % ESC key quits the experiment
            if keyCode(KbName('ESCAPE')) == 1
                clear all
                close all
                sca
                return;
            end

            % Check for response keys
            if ~isempty(pressedKeys)
                for i = 1:length(responseKeys)
                    if KbName(responseKeys{i}) == pressedKeys(1)
                        resp = responseKeys{i};
                        rt = respTime - startTime;
                    end
                end
            end

            % Exit loop once a response is recorded
            if rt > 0
                break;
            end

        end
              
        % Blank screen
        Screen(window1, 'FillRect', backgroundColor);
        Screen('Flip', window1, tFixation + fixationDuration - slack,0);

        % Save results to file
        % t 1-4 = old, shock
        % t 5-12 = old, no shock
        % t 13-24 = new
        fprintf(outputfile, '%s\t %d\t %d\t %d\t %d\t %d\t %d\t %s\t %f\n',...
            subID, b, n, t, targetDirec(n,b), setSize(t), targetPresent(t), resp, rt);

        % Clear textures
        Screen(imageDisplay,'Close');

        % Pause between trials
        if timeBetweenTrials == 0
            while 1 % Wait for space
                [keyIsDown,secs,keyCode] = KbCheck;
                if keyCode(KbName('space'))==1
                    break
                end
            end
        else
            WaitSecs(timeBetweenTrials); 
        end
    end
    
    % At the end of each block, lets randomize the second half of the
    % displays
    for i=(nTrials/2+1):nTrials
       % there are 8x6 locations, so 48 possible
       posLocs = randperm(48);
       targetLoc = itemLocs(i,1);
       posLocs(posLocs==targetLoc) = [];
       % we do not replace the target location, so don't allow it as an
       % option for a new distractor location
       itemLocs(i,2:end) = posLocs(1:setSize(i)-1); 
    end
    
    Screen('DrawText',window1,'Break time. Press space bar when you are ready to continue', (W/2-300), (H/2), textColor);
    Screen('Flip',window1)
    % Wait for subject to press spacebar
    while 1
        [keyIsDown,secs,keyCode] = KbCheck;
        if keyCode(KbName('space')) == 1
            break
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% End the experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RestrictKeysForKbCheck([]);
fclose(outputfile);
Screen(window1,'Close');
close all
sca;
return

end


