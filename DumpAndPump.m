function [Shares, globalCost] = PumpAndDump(Shares, AlgorithmParams, ProblemParams, globalCost, ub, lb, beta)
    % Generate temporary new shares
    TempShares = ModifiedGenerateNewShare(AlgorithmParams.NumOfShares, ProblemParams);
    
    % Update each TempShare's position around the worst share within the specified range
    worstIndex = find([Shares.Cost] == max([Shares.Cost]), 1);
    worstPosition = Shares(worstIndex).Position;
    
    for i = 1:AlgorithmParams.NumOfShares
        newPosition = worstPosition + (beta * (ub - lb)) * (2 * rand(1, ProblemParams.NPar) - 1);
        
        % Ensure positions are within bounds
        newPosition(newPosition > ub) = ub;
        newPosition(newPosition < lb) = lb;
        
        % Update TempShare's position
        TempShares(i, :) = newPosition;
    end
    
    % Evaluate costs for TempShares
    TempCosts = zeros(1, AlgorithmParams.NumOfShares);
    for i = 1:AlgorithmParams.NumOfShares
        TempCosts(i) = feval(ProblemParams.CostFuncName, TempShares(i,:));
    end
    
    % Check if any TempShare has a better cost than the current worst share cost
    maxTempCost = min(TempCosts);
    if maxTempCost < globalCost
        % Replace worst share with the TempShare having the better cost
        Shares(worstIndex).Position = TempShares(TempCosts == maxTempCost, :);
        Shares(worstIndex).Cost = maxTempCost;
        
        % Update global cost
        globalCost = maxTempCost;
    end
end
