classdef ParametricVarTest < matlab.unittest.TestCase
    
    properties (TestParameter)
        Confidence = struct('Confidence99', 99, 'Confidence95', 95, 'Confidence90', 90);
        Lambda = struct('Lambda95', 0.95, 'Lambda90', 0.90, 'Lambda85', 0.85);
        EstimationWindowSize = struct('OneYear',250,'TwoYear',500);
    end
    
    properties
        RatioThreshold = 1.7;
        Returns
        DateReturns
    end
    
    methods(TestMethodSetup)
        function importData(testCase)
            % Load data from MAT file
            load('PortfolioReturns.mat','Returns','DateReturns')
            testCase.Returns = Returns; %#ok<PROP>
            testCase.DateReturns = DateReturns;  %#ok<PROP>
        end
    end
    
    methods (Test)
        
        function testNormalVar(testCase, Confidence, EstimationWindowSize)
            
            NormVar = calculateNormalVar(testCase.Returns, testCase.DateReturns, Confidence,...
                'EstimationWindowSize',EstimationWindowSize,'Plot','Off');
            
            vbt = varbacktest(testCase.Returns(EstimationWindowSize+1:end),NormVar,'PortfolioID','S&P','VaRID',...
                "Normal" + Confidence,'VaRLevel',Confidence/100);
            t = summary(vbt);
            
            % Check ratio of actual to expected failures
            testCase.verifyLessThan(t.Ratio,testCase.RatioThreshold)
        end
        
        function testHistoricalVar(testCase, Confidence, EstimationWindowSize)
            
            HistVar = calculateHistVar(testCase.Returns, testCase.DateReturns, Confidence,...
                'EstimationWindowSize',EstimationWindowSize,'Plot','Off');
            
            vbt = varbacktest(testCase.Returns(EstimationWindowSize+1:end),HistVar,'PortfolioID','S&P','VaRID',...
                "Historical" + Confidence,'VaRLevel',Confidence/100);
            t = summary(vbt);
            
            %             Check ratio of actual to expected failures
            testCase.verifyLessThan(t.Ratio,testCase.RatioThreshold)
        end
        
        function testEWMAVar(testCase, Confidence, Lambda)
            
            EstimationWindowSize = 250; %#ok<PROPLC>
            
            EWMAVar = calculateEWMAVar(testCase.Returns, testCase.DateReturns, Confidence,...
                'Lambda',Lambda,'Plot','Off');
            
            vbt = varbacktest(testCase.Returns(EstimationWindowSize+1:end),EWMAVar,'PortfolioID','S&P','VaRID',...
                "EWMA" + Confidence,'VaRLevel',Confidence/100); %#ok<PROPLC>
            t = summary(vbt);
            
            % Check ratio of actual to expected failures
            testCase.verifyLessThan(t.Ratio,testCase.RatioThreshold)
        end
        
    end
end

