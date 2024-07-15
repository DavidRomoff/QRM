%% Canadian Mortgage Example
% This example shows how to model and analyze Canadian mortgage cash flows
% in MATLAB.

%% Read in Data
[~,Settle] = xlsread('Mortgage Loan CF v1.0.xlsm','Market Yields','C1');
Settle = datenum(Settle);

CurveTable = readtable('Mortgage Loan CF v1.0.xlsm','Sheet',...
    'ZeroCurve','Range','B4:K3658');

CurveTable.Date = datenum(CurveTable.Date);

ShiftValue = xlsread('Mortgage Loan CF v1.0.xlsm','ZeroCurve','I3');

MortTable = readtable('Mortgage Loan CF v1.0.xlsm','Sheet',...
    'Mortgage Input','Range','B4:N13');

%% Generate cash flows for mortgages
DollarDuration = zeros(size(MortTable,1),1);
for mortidx=1:size(MortTable,1)
    [Principal, Interest, Balance, Payment] = amortize((1+MortTable.Rate(mortidx)/2).^(1/6)-1,...
        MortTable.Amortization_mos_(mortidx), MortTable.Balance(mortidx));
    
    CFDates = cfdates(Settle,MortTable.Maturity(mortidx),12);
    
    if MortTable.PPR(mortidx) == 0
        CF = Principal(1:length(CFDates))' + Interest(1:length(CFDates))';
        CF(end) = CF(end) + Balance(length(CFDates));
    else
        LQR_Rate = 1 - (1 - MortTable.LQR(mortidx)).^(1/12);
        PPR_Rate = 1 - (1 - MortTable.PPR(mortidx)).^(1/12);
        PMT = [Payment Payment*((1-LQR_Rate).^(1:length(CFDates)-1))]';
        
        tmpBalance = zeros(1,length(CFDates)+1);
        tmpBalance(1) = MortTable.Balance(mortidx);
        CF = zeros(length(CFDates),1);
        
        for payidx=1:length(CFDates)
            Int = tmpBalance(payidx)*((1+MortTable.Rate(mortidx)/2).^(1/6)-1);
            SchPrinPay = PMT(payidx) - Int;
            LQR = LQR_Rate*(tmpBalance(payidx) - SchPrinPay);
            PPR = PPR_Rate*(tmpBalance(payidx) - SchPrinPay - LQR);
            tmpBalance(payidx+1) = tmpBalance(payidx) - LQR - PPR - SchPrinPay;
            CF(payidx) = PMT(payidx) + LQR + PPR;
        end
        
        CF(end) = PMT(end) + tmpBalance(end-1) - SchPrinPay;
    end
    
    ZeroRates = interp1(CurveTable.Date,CurveTable.Zero,CFDates)/100;
    
    DF = (1 + ZeroRates/2).^(-2*daysdif(Settle,CFDates)/365.25);
    DF_Down = (1 + (ZeroRates - ShiftValue/10000)/2).^(-2*daysdif(Settle,CFDates)/365.25);
    DF_Up = (1 + (ZeroRates + ShiftValue/10000)/2).^(-2*daysdif(Settle,CFDates)/365.25);
    
    PV = CF'*DF';
    PV_Down = CF'*DF_Down';
    PV_Up = CF'*DF_Up';
    
    DollarDuration(mortidx) = (PV_Down - PV_Up)/(2*ShiftValue)*10000;
end

disp(DollarDuration)