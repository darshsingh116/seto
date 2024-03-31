function [Shares, AlgorithmParams] = ModifiedExchange(Shares, AlgorithmParams, ub, lb)
    Costs = [Shares.Cost];
    bestIndex = find(Costs == min(Costs), 1);
    worstIndex = find(Costs == max(Costs), 1);

    Shares(bestIndex).NumOfTraders = min(Shares(bestIndex).NumOfTraders + 1, AlgorithmParams.NumOfTraders);
    Shares(worstIndex).NumOfTraders = max(Shares(worstIndex).NumOfTraders - 1, 0);

    Shares(bestIndex).NumOfBuyers = min(Shares(bestIndex).NumOfBuyers + 1, Shares(bestIndex).NumOfTraders);
    
    % Calculate the range for position change based on the best share
    bestPosition = Shares(bestIndex).Position;
    positionRange = 0.1 * (ub - lb);
    
    % Randomly change worst share position near 0.1 times in the range of the best share's position
    newPosition = bestPosition + positionRange * (2 * rand - 1); % Random change around the best position
    newPosition = max(min(newPosition, ub), lb); % Ensure position stays within bounds
    Shares(worstIndex).Position = newPosition;
end
