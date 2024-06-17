% Sample data
x = [1, 2, 3, 4, 5]';
y = [2, 3, 5, 7, 11]';

% Fit linear regression model
X = [ones(size(x)), x];
b = regress(y, X);

% Predicted values
y_pred = X * b;

% Residuals
residuals = y - y_pred;

% Leverage (hat matrix)
H = X * (X' * X)^-1 * X';
leverage = diag(H);

% Cook's distance
n = length(y);
p = size(X, 2);
MSE = sum(residuals.^2) / (n - p);
cooksD = residuals.^2 ./ (p * MSE) .* leverage ./ (1 - leverage).^2;

% Display results
disp('Leverage values:');
disp(leverage);

disp('Cook''s Distance values:');
disp(cooksD);

% Plotting leverage and Cook's distance
figure;

subplot(2,1,1);
stem(leverage, 'Marker', 'none');
title('Leverage Values');
xlabel('Observation Index');
ylabel('Leverage');
hold on;
plot(xlim, [2*mean(leverage) 2*mean(leverage)], 'r--');
hold off;

subplot(2,1,2);
stem(cooksD, 'Marker', 'none');
title('Cook''s Distance');
xlabel('Observation Index');
ylabel('Cook''s D');
hold on;
plot(xlim, [4/(n - p) 4/(n - p)], 'r--');
hold off;
