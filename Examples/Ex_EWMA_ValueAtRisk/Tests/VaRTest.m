classdef VaRTest < matlab.unittest.TestCase
    
    properties
        RatioThreshold = 1.5;
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
        
        function testSizeClassNormal(testCase)

            Confidence = 95;
            EstimationWindowSize = 250;
            NormVar = calculateNormalVar(testCase.Returns, testCase.DateReturns, Confidence,...
                'EstimationWindowSize',EstimationWindowSize,'Plot','Off');
            testCase.verifyClass(NormVar, 'double')
            testCase.verifySize(NormVar, ...
                [length(testCase.Returns)-EstimationWindowSize, length(Confidence)])
        end
        
        
        function testSizeClassHistorical(testCase)

            Confidence = 95;
            EstimationWindowSize = 250;
            HistVar = calculateHistVar(testCase.Returns, testCase.DateReturns, Confidence,...
                'EstimationWindowSize',EstimationWindowSize,'Plot','Off');
            testCase.verifyClass(HistVar, 'double')
            testCase.verifySize(HistVar, ...
                [length(testCase.Returns)-EstimationWindowSize, length(Confidence)])
        end
        
        
        function testSizeClassEWMA(testCase)

            Confidence = 95;
            EstimationWindowSize = 250;
            EWMAVar = calculateEWMAVar(testCase.Returns, testCase.DateReturns, Confidence,'Plot','Off');
            testCase.verifyClass(EWMAVar, 'double')
            testCase.verifySize(EWMAVar, ...
                [length(testCase.Returns)-EstimationWindowSize, length(Confidence)])
        end
        
        function testCorrectnessNormal(testCase)

            Confidence = [95 99];
            EstimationWindowSize = 250;
            NormVar = calculateNormalVar(testCase.Returns, testCase.DateReturns, Confidence,...
                'EstimationWindowSize',EstimationWindowSize,'Plot','Off');
            
            % VaR Backtest Framework
            vbt = varbacktest(testCase.Returns(EstimationWindowSize+1:end),...
                NormVar,'PortfolioID','S&P','VaRID',...
                "Normal" + Confidence,'VaRLevel',Confidence/100);
            t = summary(vbt);
            
            % Check ratio of actual to expected failures
            testCase.verifyLessThan(t.Ratio,testCase.RatioThreshold)
            
        end
        
        function testCorrectnessHistorical(testCase)

            Confidence = [95 99];
            EstimationWindowSize = 250;
            HistVar = calculateHistVar(testCase.Returns, testCase.DateReturns, Confidence,...
                'EstimationWindowSize',EstimationWindowSize,'Plot','Off');
            
            % VaR Backtest Framework
            vbt = varbacktest(testCase.Returns(EstimationWindowSize+1:end),...
                HistVar,'PortfolioID','S&P','VaRID',...
                "Historical" + Confidence,'VaRLevel',Confidence/100);
            t = summary(vbt);
            
            % Check ratio of actual to expected failures
            testCase.verifyLessThan(t.Ratio,testCase.RatioThreshold)
            
        end
        
        function testCorrectnessEWMA(testCase)

            Confidence = [95 99];
            EstimationWindowSize = 250;
            EWMAVar = calculateEWMAVar(testCase.Returns, testCase.DateReturns, Confidence,'Plot','Off');
            
            % VaR Backtest Framework
            vbt = varbacktest(testCase.Returns(EstimationWindowSize+1:end),...
                EWMAVar,'PortfolioID','S&P','VaRID',...
                "EWMA" + Confidence,'VaRLevel',Confidence/100);
            t = summary(vbt);
            
            % Check ratio of actual to expected failures
            testCase.verifyLessThan(t.Ratio,testCase.RatioThreshold)
            
        end
    end
end

