function summarizeResults(cumulativeReturns,VaR)

fprintf('Maximum Simulated Loss: %8.4f%s\n'   , -100*min(cumulativeReturns), '%')
fprintf('Maximum Simulated Gain: %8.4f%s\n\n' ,  100*max(cumulativeReturns), '%')
fprintf('     Simulated 90%% VaR: %8.4f%s\n'  ,  VaR(1), '%')
fprintf('     Simulated 95%% VaR: %8.4f%s\n'  ,  VaR(2), '%')
fprintf('     Simulated 99%% VaR: %8.4f%s\n\n',  VaR(3), '%')

figure
h = cdfplot(cumulativeReturns);
set(h, 'Color', 'Red');
xlabel('Logarithmic Return')
ylabel('Probability')
title ('Simulated One-Month Global Portfolio Returns CDF')