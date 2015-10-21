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
setSize = 12;

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