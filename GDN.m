function [sol, delta] = GDN(f, x0, amp, maxTime, seeds)
    %---------------------------- GD-Numeric ----------------------------%
    % Perform gradient descent on any function/simulation which you can 
    % evaluate but not necessarily differentiate
    
    % INPUT : 
    % OUTPUT :
    
    %---------------------------- INIT ----------------------------%
    % Manipulations on inputs
    switch nargin
        case 2
          amp = 1;
          seeds = NaN;
          maxTime = inf;
        case 3
          seeds = NaN;
          maxTime = inf;
        case 4
          seeds = NaN;
    end
    
    % Check for errors
    err = false;
%     error(msg)

    %---------------------------- CODE ----------------------------%
    
    % Create the indices of every poosible direction of the gradients this
    % is done by giving a significant number to each possible direction and
    % then creating each combinations wheres each place should be in a
    % group of three
    dimVec = 1:size(x0,2)*3;
    C = nchoosek(dimVec,size(x0,2));
    for ii=3:3:size(dimVec,2)
        C = C(C(:,ii/3) <= ii & C(:,ii/3) >= ii-2, :);
    end
   
    % Set params for the optmization
    overall_delta = inf;
    step_delta = inf;
    x = x0;
    grad = 2*amp;
    
%     randn - need to add the seeds functionallty

    % Start optmization either by error or by time
    while overall_delta > 1e-10 % Stop when the change is smaller than epsilon
        if all(x == x0) || (f(x)-f(x0)) > 0 % First case is on start and if the value isnt smaller
            grad = 0.5 * grad;
            x = x0;
            
            % Find the local grad
            dx = repelem(x,3) .* repmat([0.99 1 1.01],1,size(x,2));
            step_delta = inf;
            for comb = C'
                if dx(comb) == x0
                    continue
                else
                    step = f(dx(comb))-f(x);
                    if step<step_delta
                        minima_point = dx(comb);
                        step_delta = step;
                    end
                end
            end
            dir = (minima_point-x)/vecnorm(minima_point-x);
        end 
        x0 = x; % Save current state
        x = x + grad * dir; % Go to the nest state
        
        % Update the params for the next loop
        overall_delta = abs(f(x)-f(x0));
        
    end
    
    % Save for output
    delta = overall_delta;
    sol = x;
end




