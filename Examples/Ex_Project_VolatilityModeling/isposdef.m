function result = isposdef(matrix)
    % Check if a matrix is positive semi-definite
    tol = 1e-6; % Tolerance for checking eigenvalues
    result = all(eig(matrix) >= -tol);
end