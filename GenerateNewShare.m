function NewShare = GenerateNewShare(NumOfShares,ProblemParams)
    VarMinMatrix = repmat(ProblemParams.VarMin,NumOfShares,1);
    VarMaxMatrix = repmat(ProblemParams.VarMax,NumOfShares,1);
    NewShare = (VarMaxMatrix - VarMinMatrix) .* rand(size(VarMinMatrix)) + VarMinMatrix;
end