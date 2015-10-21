function img = makeSearchDisplay(itemLocs,targetDirec,imTarget,imDistractor,setSize,targetPresent,rotateDistractor,rect,bgColor)

% Size of search items
itemWH = max([size(imTarget,1) size(imTarget,2) size(imDistractor,1) size(imDistractor,2)]);

% Window size
W=rect(RectRight); % screen width
H=rect(RectBottom); % screen height

% Background image
img = bgColor*ones(H,W,3);

% Place items on a jittered grid
% Number of grid squares in X and Y
X = 8 %sqrt(setSize*(W/H));
Y = 6 %sqrt(setSize*(H/W));

% Grid start positions and jitter
gridPosY = [round((H/Y)*(0:(Y-1))) H];
gridPosX = [round((W/X)*(0:(X-1))) W];
jitterH = (gridPosY(2:Y+1) - gridPosY(1:Y)) - itemWH;
jitterW = (gridPosX(2:X+1) - gridPosX(1:X)) - itemWH;
gridPosY = repmat(gridPosY(1:Y)',[1 X]);
gridPosX = repmat(gridPosX(1:X),[Y 1]);
jitterY = floor(rand(Y,X).*repmat(jitterH',[1 X]));
jitterX = floor(rand(Y,X).*repmat(jitterW,[Y 1]));

% Random grid positions for items
%% note: original was 
%% pos = [(gridPosY(r(1:setSize))+jitterY(r(1:setSize)))' (gridPosX(r(1:setSize))+jitterX(r(1:setSize)))'];
%% but I have no idea where 'r' is supposed to come from. Guessing it should be
pos = [(gridPosY(randperm(setSize))+jitterY(randperm(setSize)))' (gridPosX(randperm(setSize))+jitterX(randperm(setSize)))'];

% Paste search items on the background
for i = 1:setSize
    % If target (OLD 'T' stimulus) present, place target first
    if (i == 1)&&(targetPresent == 1)
    %% ORIGINALLY NOTHING HAPPENS HERE!?!?. Not sure what to make of that. Guessing...
        d = imTarget;
        % If NEW 'T' stimulus is present, place NEW 'T" stimulus (i.e. targetPresent == 0) first.
        elseif (i == 1)&&(targetPresent == 0)
        d = imTarget;
        if targetDirec==1
            d = flip(d,2);
        end    
    else
        d = imDistractor;
        % Randomly rotate distractors
        if rotateDistractor == 1
            if rand < 0.5
                d = flip(flip(d,1),2);
            end
            if rand < 0.5
                d = flip(permute(d,[2 1 3]),1);
            end
        end
    end
    img(pos(i,1)+1:pos(i,1)+size(d,1),pos(i,2)+1:pos(i,2)+size(d,2),:) = d;
end