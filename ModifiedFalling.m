function [Shares, local, AlgorithmParams] = ModifiedFalling(ii, Shares, local, AlgorithmParams, ProblemParams, BestShare,BestCost, itr)
    
    preCost = Shares(ii).Cost;
    AlgorithmParams.NegativeCoefficient = Shares(ii).NumOfSellers / (Shares(ii).NumOfBuyers + 1);
    d = BestShare - Shares(ii).Position; % Calculate the direction towards the best share
    Shares(ii).Position = (Shares(ii).Position + d) .* AlgorithmParams.NegativeCoefficient .* rand(size(d)); % Move in the direction of the best share
    Shares(ii).Position = max(Shares(ii).Position, ProblemParams.VarMin);
    Shares(ii).Position = min(Shares(ii).Position, ProblemParams.VarMax);
    Shares(ii).Cost = feval(ProblemParams.CostFuncName, Shares(ii).Position);

    if (Shares(ii).Cost < preCost)
        Shares(ii).priceChanges(itr) = 1;
        Shares(ii).NumOfBuyers = min(Shares(ii).NumOfBuyers + 1, Shares(ii).NumOfTraders);
        Shares(ii).NumOfSellers = max(Shares(ii).NumOfSellers - 1, 0);

    elseif (Shares(ii).Cost > preCost)
        Shares(ii).priceChanges(itr) = -1;
        Shares(ii).NumOfBuyers = max(Shares(ii).NumOfBuyers - 1, 0);
        Shares(ii).NumOfSellers = min(Shares(ii).NumOfSellers + 1, Shares(ii).NumOfTraders);
    else
        Shares(ii).priceChanges(itr) = 0;
    end

    if (Shares(ii).Cost < BestCost)
        local(ii).Position = Shares(ii).Position;
        local(ii).Cost = Shares(ii).Cost;
    end
end
