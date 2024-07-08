function [R,Qy] = removeDependentCols(Qy,R,perm,nobs,nvar)

if isempty(R)
    Rtol = 1;
    keepCols = zeros(1,0);
else
    % use tolerance used by fullQRfactor 
    scaleT = max(nobs,nvar).*eps(class(R));  % here ScaleT will increase linearly with data size
    scaleT = min(scaleT, sqrt(eps(class(R)))); % Cap scaleT to roughly 1e-8 for double and 1e-4 in single
    Rtol = abs(R(1)).*scaleT;
    if isrow(R)
        keepCols = 1;
    else
        keepCols = find(abs(diag(R)) > Rtol);
    end
end

rankX = length(keepCols);
R0 = R;
perm0 = perm;
if rankX < nvar
    R = R(keepCols,keepCols);
    Qy = Qy(keepCols,:);
    perm = perm(keepCols);
end