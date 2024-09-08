
C = customCombvec(5)

function combinations = customCombvec(degree)
    % Initialize the Cartesian product with the first input vector
    BaseVec = [1 -1 0]';
    combinations = BaseVec;
    
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