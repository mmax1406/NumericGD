% Protections on dimensions
if size(x0,2)==1
    x0 = x0';
end

error = False;
epsilon = 1e-6;

% Init the Possible combinations and store them in memory throught
% optmization
directions = customCombvec(size(x0,2));
% Evaluate the current value(Intial guess) and the values around it
directions = directions(1:end-1,:)./vecnorm(directions(1:end-1,:),2,2); % The last one is the point itself
% Select the current lowest result to the cost function as the movment direction
bestDirIndex = findBestDir(f, amplitude, directions, x0, limitsTest);

% Begin optemization
maxTime = 100; dT=10;
while ((abs(f(x0 + amplitude*directions(bestDirIndex,:)) - f(x0)) > epsilon) || dT>maxTime) 
    % Start moving until the set timelimit is Hit or the script converged
    if(f(x0 + amplitude*directions(bestDirIndex,:)) < f(x0))
        % If all is good keep going
        x0 = x0 + amplitude*directions(bestDirIndex,:);
    else
        % If The next step dosent optmize the cost function recalculate
        % gradient
        temp = findBestDir(f, amplitude, directions, x0, limitsTest);
        if isnan(temp)
            error = True;
            break % Exit if no direction was found    
        end
        % If vectors are parallel than half the amplitude size (
        % geomatriicly it means we skipped the minima)
        if abs(dot(directions(temp,:), directions(bestDirIndex,:))) > 1 - epsilon
            amplitude = amplitude / 2;
        end
        bestDirIndex = temp;
    end
    if error
        break % Exit if no direction was found
    end
end

if error
    print('Something went wrong');
    sol = nan;
else 
    sol = x0;
end

function bestDirIndex = findBestDir(f, amplitude, combinations, x0, limitsTest)
    % Testing whats the best gradient direction
    cost = inf;
    f0 = f(x0);
    
    for ii=1:size(combinations,1)
        if limitsTest(combinations(ii,:))
            if f(combinations(ii,:))-f0 < cost
                cost = f(combinations(ii,:))-f0;
                bestDirIndex = ii;
            end
        else
            continue
        end       
    end
end

function Flag = limitsTest(candidate, limitsTest)
    
end

function combinations = customCombvec(degree)
    % Initialize the Cartesian product with the first input vector
    BaseVec = [1 -1 0]';
    combinations = BaseVec;
    
    % combinations - should be of size [3^degree,degree]
    
    % Loop through the remaining input vectors
    for i = 2:degree
        B = BaseVec;  % Convert next vector to column
        
        % Repeat each combination in C for every element in B
        numRowsC = size(combinations,1);  % Get the number of rows in current C
        combinations = repelem(combinations, numel(B), 1);  % Repeat the entire current set
        
        % Tile B to match the number of elements in C
        B_repeated = repmat(B, numRowsC, 1);
        
        % Concatenate B as a new column in the final output
        combinations = [combinations, B_repeated];
    end
end





