function [Shares, globalCost] = PumpAndDump(Shares, AlgorithmParams, ProblemParams, globalCost, ub, lb,beta)
    % Generate temporary new shares
    TempShares = ModifiedGenerateNewShare(AlgorithmParams.NumOfShares, ProblemParams);
    
    % Update each TempShare's position around the best share within the specified range
    bestIndex = find([Shares.Cost] == min([Shares.Cost]), 1);
    bestPosition = Shares(bestIndex).Position;
    
    for i = 1:AlgorithmParams.NumOfShares
        newPosition = bestPosition + (beta * (ub - lb)) * (2 * rand(1, ProblemParams.NPar) - 1);
        
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
    
    % Check if any TempShare has a better cost than the current best global cost
    minTempCost = min(TempCosts);
    if minTempCost < globalCost
        % Replace worst share with the TempShare having the better cost
        worstIndex = find([Shares.Cost] == max([Shares.Cost]), 1);
        Shares(worstIndex).Position = TempShares(TempCosts == minTempCost, :);
        Shares(worstIndex).Cost = minTempCost;
        
        % Update global cost
        globalCost = minTempCost;
    end

end
