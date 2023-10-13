function [sol, delta] = GDN(f, x0, amp, epsilon, maxTime, seeds, range)
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
          seeds = 1;
          maxTime = inf;
          epsilon = 1e-10;
        case 3
          seeds = 1;
          maxTime = inf;
          epsilon = 1e-10;
        case 4
          maxTime = inf;
          seeds = 1;
        case 5
          seeds = 1;
        case 6 
          range = 10000;
    end
    
    % Check for errors (TBD)
    err = false;
%     error(msg)

    %---------------------------- CODE ----------------------------%
    
    % Create the indices of every poosible direction of the gradients this
    % is done by giving a significant number to each possible direction and
    % then creating each combinations wheres each place in each coloumn should 
    % be in a group of three (belonging to that column)
    dimVec = 1:size(x0,2)*3;
    C = nchoosek(dimVec,size(x0,2));
    for ii=3:3:size(dimVec,2)
        C = C(C(:,ii/3) <= ii & C(:,ii/3) >= ii-2, :);
    end
   
    % Create seeds
    if seeds == 1
        seed_options = x0';
    else
        % range for random seeds (Maybe allow change from outside)
        seed_options = randn(size(x0,2), seeds)*range;
    end
    
    ii = 1;
    for x0 = seed_options
        overall_delta = inf;
        step_delta = inf;
        grad = 2*amp;
        x0 = x0';
        x = x0;
        tic; % Take current time
        % Start optmization either by error or by time
        while (overall_delta>epsilon && toc<maxTime)% Stop when the change is smaller than epsilon
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
                dir = (minima_point-x)/vecnorm(minima_point-x); % Calculate the new dir
            else 
                x0 = x;
            end 
            % Update the params for the next loop       
            x = x0 + grad*dir;
            overall_delta = abs(f(x));
        end

        % Save for output
        delta(ii) = f(x);
        sol(ii,:) = x;
        ii = ii + 1;
    end
end




