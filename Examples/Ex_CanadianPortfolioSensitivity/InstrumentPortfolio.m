classdef InstrumentPortfolio
    % Portfolio Class
    %   The portfolio class allows
    
    properties
        Instrument_ContractDetails      = {};
        Instrument_Type                 = {};
        Instrument_CounterParty         = {};
        Instrument_Equity               = [];
        Instrument_Margin               = [];
        Portfolio_Name                  = {};
        Portfolio_Style                 = {};
        Portfolio_RiskBenchmarkTickers  = {};
        Portfolio_RiskBenchmarkWeights  = {};
        Portfolio_RiskBenchmarkPrices   = {};
        Portfolio_RiskBenchmarkReturns  = {};
    end
    
    methods
        function obj = setInstrumentsInPortfolio(obj,Instrument2Add)
            
            if  isa(Instrument2Add,'MortgageInstrument')
                    obj.Instrument_ContractDetails{end+1} = Instrument2Add;                    
                    obj.Instrument_Type(end+1)            = {'Mortgage'};
            else
                disp('Currently this instrument is not supported.')
            end
        end
        
        function obj = valueInstruments(obj,InterestRateObject)
            for i = 1:length(obj.Instrument_ContractDetails)
                Instrument = obj.Instrument_ContractDetails{i};
                disp([num2str(i) ') Valuing Instrument: ' Instrument.Description])
                obj.Instrument_ContractDetails{i} = valueInstrument(Instrument,InterestRateObject);
            end
        end
        
        function generateReport(obj,ReportType)
            ContractData = {'Balance','Coupon','AmortizationPeriod_inMonths','SettleDate','MaturityDate','LQR','PPR','DollarDuration'};
            switch ReportType
                case {'Position'}
                    for idxInstrument = 1:length(obj.Instrument_ContractDetails)
                        ContractData = ...
                        [ContractData; ... 
                         {obj.Instrument_ContractDetails{idxInstrument}.Mortgage_Balance} ...
                         {obj.Instrument_ContractDetails{idxInstrument}.Mortgage_AnnualCouponRate} ...
                         {obj.Instrument_ContractDetails{idxInstrument}.Mortgage_AmortizationPeriod_inMonths} ...
                         {datestr(obj.Instrument_ContractDetails{idxInstrument}.Mortgage_SettleDate,'mmm-dd-yyyy')} ...
                         {datestr(obj.Instrument_ContractDetails{idxInstrument}.Mortgage_MaturityDate,'mmm-dd-yyyy')} ...
                         {obj.Instrument_ContractDetails{idxInstrument}.Mortgage_LQR} ...
                         {obj.Instrument_ContractDetails{idxInstrument}.Mortgage_PPR} ...
                         {obj.Instrument_ContractDetails{idxInstrument}.Mortgage_DollarDuration}];
                    end
                    
                    FileName = ['PositionReport_' datestr(now,'yyyy_mm_dd') '.xlsx'];
                    
                    try
                        copyfile('PositionReport_Template.xlsx',FileName)
                        xlswrite(FileName,ContractData,'Position')
                        winopen(FileName)
                    catch
                        errordlg('RiskPortfolio Report Generation Error: Please ensure that the file is closed on write')
                    end
                        
                case {'CashFlow'}
                    
                otherwise
                    
            end
        end        
    end

    
end

