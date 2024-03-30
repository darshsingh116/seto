%function NewShare = ModifiedGenerateNewShare(NumOfShares,ProblemParams)
%    VarMinMatrix = repmat(ProblemParams.VarMin,NumOfShares,1);
%    VarMaxMatrix = repmat(ProblemParams.VarMax,NumOfShares,1);
%    NewShare = (VarMaxMatrix - VarMinMatrix) .* rand(size(VarMinMatrix)) + VarMinMatrix;
%end

function NewShare = ModifiedGenerateNewShare(NumOfShares, ProblemParams)
    % Define the ranges for each part
    range1 = [0, 0.3];
    range2 = [0.3, 0.6];
    range3 = [0.6, 1.0];
    
    % Calculate the number of shares in each part
    numSharesPart1 = round(NumOfShares * 0.25); % 25% of NumOfShares
    numSharesPart2 = round(NumOfShares * 0.25); % 25% of NumOfShares
    numSharesPart3 = round(NumOfShares * 0.25); % 25% of NumOfShares
    numSharesPart4 = NumOfShares - numSharesPart1 - numSharesPart2 - numSharesPart3; % Remaining shares
    
    % Generate shares for each part based on the ranges
    part1 = (range1(2) - range1(1)) * rand(numSharesPart1, ProblemParams.NPar) + range1(1);
    part2 = (range2(2) - range2(1)) * rand(numSharesPart2, ProblemParams.NPar) + range2(1);
    part3 = (range3(2) - range3(1)) * rand(numSharesPart3, ProblemParams.NPar) + range3(1);
    part4 = rand(numSharesPart4, ProblemParams.NPar);
    
    % Concatenate all parts to create NewShare
    NewShare = [part1; part2; part3; part4];
end
