%% Estimate Value @ Risk

%% Import Global Equity Indices & Setup Key Variables
load GlobalEquityIndices   % Daily index closings
Returns = price2ret(Data);    % Logarithmic returns - continuosly compounded returns
Plot_NormalizedPriceSeries(Dates,Data,Returns,Names)

%% Calculate Cumulative Returns (Equally Weighted Portfolio)
% Finally, given the simulated returns of each index, form an equally weighted 
% global index portfolio composed of the individual indices (a global index of 
% country indices). Since we are working with daily logarithmic returns, the 
% cumulative returns over the risk horizon are simply the sums of the returns 
% over each intervening period. Also note that the portfolio weights are held
% fixed throughout the risk horizon, and that the simulation ignores any 
% transaction costs required to rebalance the portfolio (the daily rebalancing
% process is assumed to be self-financing).
%
% Note that although the simulated returns are logarithmic (continuously 
% compounded), the portfolio return series is constructed by first converting 
% the individual logarithmic returns to arithmetic returns (price change divided
% by initial price), then weighting the individual arithmetic returns to obtain 
% the arithmetic return of the portfolio, and finally converting back to 
% portfolio logarithmic return. With daily data and a short VaR horizon, the 
% repeated conversions make little difference, but for longer time periods the 
% disparity may be significant.

weights = repmat(1/6, 6, 1); % equally weighted portfolio
BackTestReturns = Returns*weights;
Performance     = ret2price(BackTestReturns,100);
figure
h1 = subplot(2,1,1);
plot(BackTestReturns)
grid on
h2 = subplot(2,1,2);
plot(Performance)
grid on
linkaxes([h1,h2],'x')

%% Value At Risk
Pd = createFit(BackTestReturns);
VaR = icdf(Pd,0.05)
hold on
plot([VaR VaR],[0 70])

%% Build a GARCH Model
GARCH_BackTestReturns = modelTimeSeries(BackTestReturns);

[residuals, variances] = infer(GARCH_BackTestReturns, BackTestReturns);


figure
subplot(2,1,1)
plot(Dates(2:end), residuals)
datetick('x')
xlabel('Date')
ylabel('Residual')
title ('Filtered Residuals')

subplot(2,1,2)
plot(Dates(2:end), sqrt(variances))
datetick('x')
xlabel('Date')
ylabel('Volatility')
title ('Filtered Conditional Standard Deviations')