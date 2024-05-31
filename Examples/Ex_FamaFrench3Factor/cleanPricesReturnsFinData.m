function [Prices,Returns,FinData] = cleanPricesReturnsFinData(Prices,Returns,FinData)

% Remove tickers which have missing data
Ibad = any(isnan(Prices{:,:}));
Prices(:,Ibad)  = [];
Returns(:,Ibad) = [];
FinData(Ibad,:) = [];
disp("Missing data detected, removing the following tickers")
disp("-----------------------------------------------------")
disp(string(Prices.Properties.VariableNames(Ibad)))