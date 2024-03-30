%___________________________________________________________________%
%   SAND CAT OPTIMIZATION ALGORITHM source codes                    %
%   ... (rest of the code remains the same) ...                 %
%________
% ___________________________________________________________%
clc
clear all;

% Search agent parameters
SearchAgents_no =20;
Max_iteration = 10;
num_runs = 5;  % Number of runs for each function
a=1;
b=30;

% Pre-allocate arrays for storing results
original_scores = zeros(num_runs, b-a+1);  % Stores best scores for original SCSO
modified_scores = zeros(num_runs, b-a+1);  % Stores best scores for modified SCSO
p_values = zeros(1, b-a+1);  % Stores p-values from Wilcoxon Rank Sum test

for i = a:b
    % Define test function details (replace with your implementation)
    Function_name = sprintf('F%d', i);
    [lb, ub, dim, fobj] = CEC2014(Function_name);
    for run = 1:num_runs
        % Run original SCSO
        [BsSCSO_original, ~, ~] = SCSO(SearchAgents_no, Max_iteration, lb, ub, dim, fobj);
        original_scores(run, i) = BsSCSO_original;
        % Run modified SCSO
        k = max(1, floor(0.25 * SearchAgents_no));
        [BsSCSO_modified, ~, ~] = updated(SearchAgents_no, Max_iteration, lb, ub, dim, fobj,k);
        modified_scores(run, i) = BsSCSO_modified;
    end

    % Wilcoxon Rank Sum test
    [p_values(i), ~, stats] = ranksum(original_scores(:, i), modified_scores(:, i));

    % Print/store results (modify as needed)
    fprintf('Function Number %d\n',i);
    fprintf('Original SCSO Average Score: %f\n', mean(original_scores(:, i)));
    fprintf('Modified SCSO Average Score: %f\n', mean(modified_scores(:, i)));
    fprintf('p-value (Wilcoxon Rank Sum): %f\n', p_values(i));
    fprintf('\n\n');

    % Correlation analysis (optional)
    % You can modify this section to plot the desired correlation
    correlation = corrcoef(original_scores(:, i), modified_scores(:, i));
    fprintf('Correlation coefficient (original vs. modified): %f\n', correlation(1,2));
    % Consider plotting a scatter plot with original vs. modified scores
    %  and highlighting significant correlations based on p-values

    % Subplots (optional, similar to previous version)
    % ... (code for subplots can be included here) ...
end