%% Carried Interest Calculation

%% Import Data
Data = importWaterfallData('Demo Theoretical Waterfall_v1.xlsm','Waterfall Model');

%% Simple Accounting Calculation
T  = table();
T.Investor = Data.Investor;
T.TN = Data.CapitalContributions + Data.AccumulatedEarnings;
T.AccumulatedEarnings  = Data.AccumulatedEarnings;
T.CapitalContribution = min(Data.CapitalContributions,Data.TheoreticalNAV);

%% Write Excel
writetable(T,'Output.xlsx')