function Ahat = nearestSPD(A)
    % Find the nearest symmetric positive semi-definite matrix to A
    [V,D] = eig(A);
    d = diag(D);
    d(d<0) = 0;
    Ahat = V*diag(d)*V';
end