x = (1:10)';  % Predictor variable (column vector)
y = [2, 3, 2, 5, 7, 10, 11, 9, 13, 15]';  % Response variable (column vector)

n = length(y);  % Number of observations
p = 1;  % Number of predictors (not including the intercept)

% Full model with all observations
fullModel = fitlm(x, y);

% Initialize vector to store Cook's Distance
cooksD = zeros(n, 1);

% Loop through each observation
for i = 1:n
    % Create index for all observations except the current one in the loop
    index = true(n, 1);
    index(i) = false;

    % Fit model without the i-th observation
    reducedModel = fitlm(x(index), y(index));

    % Calculate the difference in fitted values
    fittedFull = predict(fullModel, x);
    fittedReduced = predict(reducedModel, x);

    % Compute the sum of squared differences
    SSE = sum((fittedFull - fittedReduced).^2);

    % Compute Cook's Distance
    cooksD(i) = (SSE / (p + 1)) / fullModel.MSE;
end

% Plot Cook's Distance
figure;
stem(cooksD, 'filled')
xlabel('Observation Index');
ylabel('Cook''s Distance');
title('Cook''s Distance for Each Observation (Manual Calculation)');
