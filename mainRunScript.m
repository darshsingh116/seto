clc;
clear;
clear all;
% Specify number of runs and significance level
numRuns = 50;
alpha = 0.05;  % Significance level

% Function names (excluding F2)
funcNames = arrayfun(@(x) ['F' num2str(x)], 1:1, 'UniformOutput', false);
%funcNames(2) = [];  % Remove F2

% Initialize results storage
originalCosts = cell(1, length(funcNames));
modifiedCosts = cell(1, length(funcNames));
pValues = zeros(1, length(funcNames));

% Loop through functions
for i = 1:length(funcNames)
  funcName = funcNames{i};
  
  % Run algorithms and store average costs
  for run = 1:numRuns
    originalCosts{i}(run) = OriginalSolo(numRuns, funcName);
    modifiedCosts{i}(run) = ModifiedSolo(numRuns, funcName);
    % Print the cost after each run
    disp(['func', funcNames{i}]);
    fprintf('Run %d - Original Cost: %.4f, Modified Cost: %.4f\n', run, originalCosts{i}(run), modifiedCosts{i}(run));
  end
  
  
  % Perform two-sample t-test (assuming costs are normally distributed)
  [~, pValues(i)] = ttest2(originalCosts{i}, modifiedCosts{i});
end

% Display results
for i = 1:length(funcNames)
  funcName = funcNames{i};
  avgOriginalCost = mean(originalCosts{i});
  avgModifiedCost = mean(modifiedCosts{i});
  pValue = pValues(i);
  
  fprintf('Function: %s\n', funcName);
  fprintf('  Average Original Cost: %f\n', avgOriginalCost);
  fprintf('  Average Modified Cost: %f\n', avgModifiedCost);
  if pValue < alpha
    fprintf('  p-value: %f better\n', pValue);
    fprintf('  Modified algorithm performs statistically better.\n');
  else
    fprintf('  p-value: %f worse\n', pValue);
    fprintf('  No statistically significant difference found.\n');
  end
  fprintf('\n');
end
