clear all;
close all;
clc;

% Specify the number of runs
numRuns = 30;
%funcName = "F15";

% Call the RunAlgorithm function
%avgGlobalCost = RunAlgorithm(numRuns,funcName);
%avgGlobalCostModified = ModifiedRunAlgorithm(numRuns,funcName);

% Display the average global cost
%disp(['Average Global Cost after ' num2str(numRuns) ' runs: ' num2str(avgGlobalCost)]);
%disp(['Modified Average Global Cost after ' num2str(numRuns) ' runs: ' num2str(avgGlobalCostModified)]);


p_values = zeros(1, 30);
for funcNum = 1:30
    if funcNum == 2
        continue;
    end
    funcName = ['F' num2str(funcNum)];

   % Call the RunAlgorithm function
[avgGlobalCost,globalCostsArr] = RunAlgorithm(numRuns,funcName);
[avgGlobalCostModified,globalCostsArrModified] = ModifiedRunAlgorithm(numRuns,funcName);

% Display the average global cost

disp(['Function CEC17 F' num2str(funcNum)]);
disp(['Average Global Cost after ' num2str(numRuns) ' runs: ' num2str(avgGlobalCost)]);
disp(['Modified Average Global Cost after ' num2str(numRuns) ' runs: ' num2str(avgGlobalCostModified)]);

% Wilcoxon Rank Sum test
[p_values(funcNum), ~, stats] = ranksum(globalCostsArr(:, funcNum), globalCostsArrModified(:, funcNum));
fprintf('Pvalue is %f \n', p_values(funcNum));

end