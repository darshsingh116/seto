function Shares = ModifiedCreateInitialShares(InitialShares,InitialCost,AlgorithmParams, ProblemParams)

AllSharesPosition = InitialShares;
AllSharesCost= InitialCost(1:AlgorithmParams.NumOfShares,:);

if max(AllSharesCost)>0
    AllSharesPower = 1.3 * max(AllSharesCost) - AllSharesCost;
else
    AllSharesPower = 0.7 * max(AllSharesCost) - AllSharesCost;
end

AllSharesNumOfTraders = round(AllSharesPower/sum(AllSharesPower) * AlgorithmParams.NumOfTraders);
AllSharesNumOfTraders(end) = AlgorithmParams.NumOfTraders - sum(AllSharesNumOfTraders(1:end-1));

Shares(AlgorithmParams.NumOfShares).Position = 0;

for ii = 1:AlgorithmParams.NumOfShares
    Shares(ii).Position = AllSharesPosition(ii,:);
    Shares(ii).Cost = AllSharesCost(ii,:);
    
    Shares(ii).NumOfTraders= AllSharesNumOfTraders(ii);
    if numel(Shares(ii).NumOfTraders) == 0
        Shares(ii).NumOfTraders = 1;
    end
    p=rand;
    Shares(ii).NumOfBuyers=ceil(p*Shares(ii).NumOfTraders);
    Shares(ii).NumOfSellers=Shares(ii).NumOfTraders-Shares(ii).NumOfBuyers;
end