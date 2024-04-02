clear all;
close all;
clc;

alpha=0.5;
alpha2=1;
alphaDump=0.98;
RSITimeFrame=14;

ProblemParams.CostFuncName = "F2";


%[lowerbound, upperbound, dimension, fobj]=Get_Functions_details(ProblemParams.CostFuncName);
[lowerbound, upperbound, dimension, fobj]=CEC2014(ProblemParams.CostFuncName);
globalCost=0;

ProblemParams.CostFuncName=fobj;
ProblemParams.lb=lowerbound;
ProblemParams.ub=upperbound;
ProblemParams.NPar = dimension;
ProblemParams.gcost=globalCost;

ProblemParams.VarMin =ProblemParams.lb;
ProblemParams.VarMax = ProblemParams.ub;


%fprintf("here");
if isscalar(ProblemParams.VarMin)
    
    ProblemParams.VarMin=repmat(ProblemParams.VarMin,1,ProblemParams.NPar);
    ProblemParams.VarMax=repmat(ProblemParams.VarMax,1,ProblemParams.NPar);
    
end
ProblemParams.SearchSpaceSize = ProblemParams.VarMax - ProblemParams.VarMin;

if isscalar(ProblemParams.VarMin) && isscalar(ProblemParams.VarMax)
   % fprintf("there");
    ProblemParams.dmax = (ProblemParams.VarMax-ProblemParams.VarMin)*sqrt(ProblemParams.NPar);
else
    %fprintf("there2");
    ProblemParams.dmax = norm(ProblemParams.VarMax-ProblemParams.VarMin);
end


%% Algorithmic Parameter Setting
AlgorithmParams.NumOfShares = 30;
AlgorithmParams.NumOfTraders = 100;
AlgorithmParams.NumOfDays = 1800;

InitialShares = ModifiedGenerateNewShare(AlgorithmParams.NumOfShares, ProblemParams);
InitialCost = zeros(1, AlgorithmParams.NumOfShares); % Initialize an array to store individual costs
for i = 1:AlgorithmParams.NumOfShares
    InitialCost(i) = feval(ProblemParams.CostFuncName, InitialShares(i,:)); % Calculate cost for each share
end
%InitialCost = feval(ProblemParams.CostFuncName,InitialShares); %here error
Shares = ModifiedCreateInitialShares(InitialShares,InitialCost',AlgorithmParams, ProblemParams); %sometimes ' is used sometimes not note

local=Shares;
Costs = [Shares.Cost];
BestIndex = find(Costs == min(Costs));
%fprintf(BestIndex);
bestSolution = Shares(BestIndex).Position;
globalCost = Shares(BestIndex).Cost;

for itr = 1:AlgorithmParams.NumOfDays
    disp([num2str(alpha)]);
    for ii=1:AlgorithmParams.NumOfShares
        if(itr>RSITimeFrame && Shares(ii).RSI(itr-1)<30)
            [Shares, AlgorithmParams]= ModifiedRising(ii,Shares,AlgorithmParams,ProblemParams,bestSolution,itr, alpha);
        elseif(itr>RSITimeFrame && Shares(ii).RSI(itr-1)>70)
            [Shares, local, AlgorithmParams]= m2Falling(ii,Shares, local, AlgorithmParams,ProblemParams,bestSolution,itr,alpha2);
        else
            r=rand;
            if(r>0.5)
                [Shares, AlgorithmParams]= ModifiedRising(ii,Shares,AlgorithmParams,ProblemParams,bestSolution,itr, alpha);
            else
                [Shares, local, AlgorithmParams]= m2Falling(ii,Shares, local, AlgorithmParams,ProblemParams,bestSolution,itr,alpha2);
            end
        end
        
        [Shares, AlgorithmParams]= Exchange(Shares, AlgorithmParams);
        
        si=numel(Shares(ii).priceChanges);
        if(itr>=RSITimeFrame)
            Pi=sum(Shares(ii).priceChanges(itr-RSITimeFrame+1:itr)>0);
            Ni=sum(Shares(ii).priceChanges(itr-RSITimeFrame+1:itr)<0);
            Shares(ii).RSI(itr)=100-(100/(1+(Pi/Ni)));
        end
        
    end
    
    Costs = [Shares.Cost];
    BestIndex = find(Costs == min(Costs),1);
    currentBestSolution = Shares(BestIndex).Position;
    currentBestCost = Shares(BestIndex).Cost;
    if(currentBestCost< globalCost)
        globalCost= currentBestCost;
        bestSolution=currentBestSolution;
    else
        Shares(BestIndex).Position=bestSolution;
    end
    
    fprintf('Minimum Cost in Iteration %d is %f \n', itr, globalCost);
    alpha=alpha*alphaDump;
    alpha2=alpha2*0.98;
    
    % Check if it's time to perform Pump and Dump
    if(mod(itr, 20) == 0)                
        [Shares, globalCost] = DumpAndPump(Shares, AlgorithmParams, ProblemParams, globalCost, ProblemParams.ub, ProblemParams.lb,0.3);
    end
    if(mod(itr, 10) == 0)              
        [Shares, globalCost] = PumpAndDump(Shares, AlgorithmParams, ProblemParams, globalCost, ProblemParams.ub, ProblemParams.lb,0.8);
    end
    
    if(mod(itr, 200) == 0)
        alpha = 0.5;
        alpha2 = 1;
    end
    

end




