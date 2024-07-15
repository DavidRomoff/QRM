%% Canadian Mortgage Example
% This example shows how to model and analyze Canadian mortgage cash flows
% in MATLAB.

%% Read in Data
[~,Settle] = xlsread('Mortgage Loan CF v1.0.xlsm','Market Yields','C1');
Settle = datenum(Settle);

ShiftValue = xlsread('Mortgage Loan CF v1.0.xlsm','ZeroCurve','I3');

MortTable = readtable('Mortgage Loan CF v1.0.xlsm','Sheet','Mortgage Input','Range','B4:N13');
MortTable.Maturity = datenum(MortTable.Maturity,'mm/dd/yyyy');
clc

%% Read in Zero Curve Data
MarketQuotes = xlsread('Mortgage Loan CF v1.0.xlsm','Market Yields','C4:C20')/100;
MarketMat = daysadd(Settle,[1 30*[1 2 3 6 9 12 18] 360*(2:10)],1);

irdc = IRDataCurve.bootstrap('zero',Settle,...
                             [repmat({'deposit'},7,1);repmat({'swap'},10,1)],...
                             [repmat(Settle,17,1) MarketMat MarketQuotes]);

%% Setup Single Mortgage Portfolio
idxMort = 1;
M = MortgageInstrument;
M = M.setMortgageProperties(MortTable.Balance(idxMort),MortTable.Rate(idxMort),MortTable.Amortization_mos_(idxMort),Settle,MortTable.Maturity(idxMort),MortTable.LQR(idxMort),MortTable.PPR(idxMort));

%% Step #1: Estimate Cashflows
M = M.estimateCashFlows();

%% Step #2: Estimate Discounted Cashflows
M = M.estimateDiscountedCashFlows(irdc);

%% Step #3: Estimate 
M = M.estimateDollarDuration(irdc,2);

