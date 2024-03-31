function globalCost = ModifiedSolo(numRuns,funcName)        
        alpha=0.5;
        alphaDump=0.95;
        RSITimeFrame=14;
        
        ProblemParams.CostFuncName = funcName;
        
        
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
        AlgorithmParams.NumOfTraders = 1000;
        AlgorithmParams.NumOfDays = 200;
        
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
            
            for ii=1:AlgorithmParams.NumOfShares
                if(itr>RSITimeFrame && Shares(ii).RSI(itr-1)<45)
                    [Shares, AlgorithmParams]= ModifiedRising(ii,Shares,AlgorithmParams,ProblemParams,bestSolution,itr, alpha);
                elseif(itr>RSITimeFrame && Shares(ii).RSI(itr-1)>70)
                    [Shares, local, AlgorithmParams]= ModifiedFalling(ii,Shares, local, AlgorithmParams,ProblemParams,bestSolution,globalCost,itr);
                else
                    r=rand;
                    if(r>0.2)
                        [Shares, AlgorithmParams]= ModifiedRising(ii,Shares,AlgorithmParams,ProblemParams,bestSolution,itr, alpha);
                    else
                        [Shares, local, AlgorithmParams]= ModifiedFalling(ii,Shares, local, AlgorithmParams,ProblemParams,bestSolution,globalCost,itr);
                    end
                end
                
                [Shares, AlgorithmParams]= ModifiedExchange(Shares, AlgorithmParams, ProblemParams.ub,ProblemParams.lb);
                
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
            
            %fprintf('Minimum Cost in Iteration %d is %e \n', itr, globalCost);
            
            alpha=alpha*alphaDump;
            if(itr== AlgorithmParams.NumOfDays/2 || itr== AlgorithmParams.NumOfDays/4)
                alpha = 1;
                alphaDump = 0.98;
            end
            
            % Check if it's time to perform Pump and Dump
            if(mod(AlgorithmParams.NumOfDays, 20) == 0)                
                [Shares, globalCost] = DumpAndPump(Shares, AlgorithmParams, ProblemParams, globalCost, ProblemParams.ub, ProblemParams.lb,0.3);
            end
            if(mod(AlgorithmParams.NumOfDays, 10) == 0)              
                [Shares, globalCost] = PumpAndDump(Shares, AlgorithmParams, ProblemParams, globalCost, ProblemParams.ub, ProblemParams.lb,0.8);
            end

        end

end