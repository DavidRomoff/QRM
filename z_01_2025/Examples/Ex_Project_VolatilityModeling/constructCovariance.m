function covMatrix = constructCovariance(volatilityForecasts, correlationMatrix)
    % Calculate covariance matrix
    covMatrix = diag(volatilityForecasts) * correlationMatrix * diag(volatilityForecasts);

    % Check if the covariance matrix is positive semi-definite
    if ~isposdef(covMatrix)
        % If not, adjust the covariance matrix to make it valid
        covMatrix = nearestSPD(covMatrix);
    end
end