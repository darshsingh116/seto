function [Shares, AlgorithmParams] = ModifiedExchange(Shares,AlgorithmParams)
    Costs = [Shares.Cost];
    bestIndex = find(Costs == min(Costs),1);
    worstIndex = find(Costs == max(Costs),1);

    Shares(bestIndex).NumOfTraders=min(Shares(bestIndex).NumOfTraders+1, AlgorithmParams.NumOfTraders);
    Shares(worstIndex).NumOfTraders=max(Shares(worstIndex).NumOfTraders-1,0);

    Shares(bestIndex).NumOfBuyers=min(Shares(bestIndex).NumOfBuyers+1,Shares(bestIndex).NumOfTraders) ;
    Shares(worstIndex).NumOfSellers=max(Shares(worstIndex).NumOfSellers-1,0) ;
end