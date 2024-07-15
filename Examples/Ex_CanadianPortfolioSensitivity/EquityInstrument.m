classdef EquityInstrument < InstrumentClass
    % Mortgage Instrument
    %   This class defines a single mortgage style instrument with the
    %   following methods for estimating CashFlows & DollarDuration
    %
    %   setMortgageProperties(obj,Balance,AnnualCouponRate,AmortizationPeriod_inMonths,SettleDate,MaturityDate,LQR,PPR)
    %   estimateCashFlows(obj)
    %   estimateDiscountedCashFlows(obj,IRDC)
    %   estimateDollarDuration(obj,IRDC,ShiftValue)
    
    properties (SetAccess = 'public', GetAccess = 'public', Hidden = false)
        Mortgage_Balance
        Mortgage_AnnualCouponRate
        Mortgage_AmortizationPeriod_inMonths
        Mortgage_SettleDate
        Mortgage_MaturityDate
        Mortgage_LQR
        Mortgage_PPR
        Mortgage_DollarDuration
%         Description
        CashFlow_Dates
        CashFlow_Principal
        CashFlow_Interest
        CashFlow_Balance
        CashFlow_Payment
        CashFlow_Amounts_NotDiscounted
        CashFlow_Amounts_PresentValueAfterDiscounting
    end
    
    methods
        function obj = add(obj, x)
            obj = obj.Mortgage_Balance + x;
        end
        %% Method: sets properties of Mortgage style instrument
        function obj = setMortgageProperties(obj,Balance,AnnualCouponRate,AmortizationPeriod_inMonths,SettleDate,MaturityDate,LQR,PPR)
            obj.Mortgage_Balance                     = Balance;
            obj.Mortgage_AnnualCouponRate            = AnnualCouponRate;
            obj.Mortgage_AmortizationPeriod_inMonths = AmortizationPeriod_inMonths;
            obj.Mortgage_SettleDate                  = SettleDate;
            obj.Mortgage_MaturityDate                = MaturityDate;
            obj.Mortgage_LQR                         = LQR;
            obj.Mortgage_PPR                         = PPR;
            obj.Description                          = ['Balance' cur2str(obj.Mortgage_Balance) '_Coupon' num2str(AnnualCouponRate*100,'%10.2f') '%_ContractDaysLeft' num2str(MaturityDate - SettleDate,'%10.0f')];
            obj.CashFlow_Dates                       = cfdates(obj.Mortgage_SettleDate,obj.Mortgage_MaturityDate,12);
        end
        
        %% Method: estimates cashflows of instruments in portfolio
        function obj = estimateCashFlows(obj)
            numOfCashflowDates = length(obj.CashFlow_Dates);
            [obj.CashFlow_Principal, obj.CashFlow_Interest, obj.CashFlow_Balance, obj.CashFlow_Payment] = amortize((1+obj.Mortgage_AnnualCouponRate/2).^(1/6)-1,obj.Mortgage_AmortizationPeriod_inMonths, obj.Mortgage_Balance);

            if obj.Mortgage_PPR == 0
                obj.CashFlow_Amounts_NotDiscounted      = obj.CashFlow_Principal(1:numOfCashflowDates)' + obj.CashFlow_Interest(1:numOfCashflowDates)';
                obj.CashFlow_Amounts_NotDiscounted(end) = obj.CashFlow_Amounts_NotDiscounted(end) + obj.CashFlow_Balance(numOfCashflowDates);
            else
                LQR_Rate = 1 - (1 - obj.Mortgage_LQR).^(1/12);
                PPR_Rate = 1 - (1 - obj.Mortgage_PPR).^(1/12);
                PMT      = [obj.CashFlow_Payment obj.CashFlow_Payment*((1-LQR_Rate).^(1:numOfCashflowDates-1))]';
                
                tmpBalance                         = zeros(1,numOfCashflowDates+1);
                tmpBalance(1)                      = obj.Mortgage_Balance;
                obj.CashFlow_Amounts_NotDiscounted = zeros(numOfCashflowDates,1);
                
                for payidx=1:numOfCashflowDates
                    Intrest = tmpBalance(payidx)*((1+obj.Mortgage_AnnualCouponRate/2).^(1/6)-1);
                    SchPrinPay = PMT(payidx) - Intrest;
                    LQR = LQR_Rate*(tmpBalance(payidx) - SchPrinPay);
                    PPR = PPR_Rate*(tmpBalance(payidx) - SchPrinPay - LQR);
                    tmpBalance(payidx+1) = tmpBalance(payidx) - LQR - PPR - SchPrinPay;
                    obj.CashFlow_Amounts_NotDiscounted(payidx) = PMT(payidx) + LQR + PPR;
                end
                
                obj.CashFlow_Amounts_NotDiscounted(end) = PMT(end) + tmpBalance(end-1) - SchPrinPay;
            end
        end
        
        %% Method: estimates discounted cashflows based on the Interest Data Curve Object from the Financial Instrument Toolbox
        function obj = estimateDiscountedCashFlows(obj,IRDC)
            obj.CashFlow_Amounts_PresentValueAfterDiscounting = obj.CashFlow_Amounts_NotDiscounted.*IRDC.getDiscountFactors(obj.CashFlow_Dates);
        end
        
        %% Method: estimates dollar duration based on Portfolio & shifted Interest Rate Data Curve from the Financial Instruments Toolbox
        function [obj,DollarDuration,PV_Up,PV_Down] = estimateDollarDuration(obj,IRDC,ShiftValue)
            if nargin < 3
                ShiftValue = 2;
            end
            IRDC_down = IRDataCurve('zero',obj.Mortgage_SettleDate,IRDC.Dates,IRDC.Data-ShiftValue/10000);            
            IRDC_up = IRDataCurve('zero',obj.Mortgage_SettleDate,IRDC.Dates,IRDC.Data+ShiftValue/10000);
            PV_Down = obj.CashFlow_Amounts_NotDiscounted'*IRDC_down.getDiscountFactors(obj.CashFlow_Dates);
            PV_Up = obj.CashFlow_Amounts_NotDiscounted'*IRDC_up.getDiscountFactors(obj.CashFlow_Dates);
            DollarDuration = (PV_Down - PV_Up)/(2*ShiftValue)*10000;
            obj.Mortgage_DollarDuration = DollarDuration;
        end
        
        %% Method: estimates 
        function obj = valueInstrument(obj,InterestRateObject)
            % Step #1: Estimate Cashflows
            obj = obj.estimateCashFlows();

            if isa(InterestRateObject,'IRDataCurve')
                % Step #2: Estimate Discounted Cashflows
                obj = obj.estimateDiscountedCashFlows(InterestRateObject);

                % Step #3: Estimate
                obj = obj.estimateDollarDuration(InterestRateObject,2);
            else
                disp('Please ensure you are using the IRDataCurve from the Financial Instruments Toolbox: [>> doc IRDataCurve]')
            end
        end
    end
    
end

