%% Canadian Mortgage Example
% This example shows how to model and analyze Canadian mortgage cash flows
% in MATLAB.

%% Read in Data
[~,Settle] = xlsread('Mortgage Loan CF v1.0.xlsm','Market Yields','C1');
Settle = datenum(Settle);

ShiftValue = xlsread('Mortgage Loan CF v1.0.xlsm','ZeroCurve','I3');

MortTable = readtable('Mortgage Loan CF v1.0.xlsm','Sheet',...
    'Mortgage Input','Range','B4:N13');

%% Read in Zero Curve Data
MarketQuotes = xlsread('Mortgage Loan CF v1.0.xlsm','Market Yields','C4:C20')/100;
MarketMat = daysadd(Settle,[1 30*[1 2 3 6 9 12 18] 360*(2:10)],1);

irdc = IRDataCurve.bootstrap('zero',Settle,...
                             [repmat({'deposit'},7,1);repmat({'swap'},10,1)],...
                             [repmat(Settle,17,1) MarketMat MarketQuotes]);

irdc_up = IRDataCurve('zero',Settle,irdc.Dates,irdc.Data+ShiftValue/10000);
irdc_down = IRDataCurve('zero',Settle,irdc.Dates,irdc.Data-ShiftValue/10000);

%% Generate cash flows for basic mortgages
DollarDuration = zeros(size(MortTable,1),1);
for mortidx=1:size(MortTable,1)
    [Principal, Interest, Balance, Payment] = amortize((1+MortTable.Rate(mortidx)/2).^(1/6)-1,MortTable.Amortization_mos_(mortidx), MortTable.Balance(mortidx));
    
    CFDates = cfdates(Settle,MortTable.Maturity(mortidx),12);
    
    if MortTable.PPR(mortix) == 0
        CF = Principal(1:ledngth(CFDates))' + Interest(1:length(CFDates))';
        CF(end) = CF(end) + Balance(length(CFDates));
    else
        LQR_Rate = 1 - (1 - MortTable.LQR(mortidx)).^(1/12);
        PPR_Rate = 1 - (1 - MortTable.PPR(mortidx)).^(1/12);
        PMT      = [Payment Payment*((1-LQR_Rate).^(1:length(CFDates)-1))]';
        
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
    
    PV = CF'*irdc.getDiscountFactors(CFDates);
    PV_Down = CF'*irdc_down.getDiscountFactors(CFDates);
    PV_Up = CF'*irdc_up.getDiscountFactors(CFDates);
    
    DollarDuration(mortidx) = (PV_Down - PV_Up)/(2*ShiftValue)*10000;
end

disp(DollarDuration)