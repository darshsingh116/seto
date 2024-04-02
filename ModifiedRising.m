function [Shares, AlgorithmParams] = ModifiedRising(ii, Shares, AlgorithmParams, ProblemParams, BestShare, itr, alpha)
    preCost = Shares(ii).Cost;
    AlgorithmParams.PositiveCoefficient = Shares(ii).NumOfBuyers / (Shares(ii).NumOfSellers + 1);

    s = (BestShare - Shares(ii).Position);
    randomFactor = alpha * rand(size(s));  % Scale random factor by alpha
    %Shares(ii).Position = Shares(ii).Position + AlgorithmParams.PositiveCoefficient * randomFactor .* s;
    Shares(ii).Position = Shares(ii).Position +AlgorithmParams.PositiveCoefficient * rand(size(s)) .* s;

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
end
