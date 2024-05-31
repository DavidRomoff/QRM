function [Datest,Alphat,BetaMarket,BetaSMB,BetaHML] = fitRolling3FactorModel(secReturns,StepSize,WindowSize,Dates,LIBOR,returnsMarket,returnsSMB,returnsHML)

%% Input Checking
if nargin == 0
    StepSize    = 3;
    WindowSize  = 50;    
end

%%
% secReturns = E.largeReturns.AIG;
iterWindows = 1:StepSize:length(returnsMarket)-WindowSize;
Datest      = NaT(length(iterWindows),1);
Alphat      = nan(length(iterWindows),1);
BetaMarket  = nan(length(iterWindows),1);
BetaSMB     = nan(length(iterWindows),1);
BetaHML     = nan(length(iterWindows),1);
L           = LIBOR(2:end,:);
iter        = 0;
for i = 1:StepSize:length(returnsMarket)-WindowSize   
    iWindow = i:i+WindowSize;
    LIBORi = L(i:i+WindowSize+1,:);
    Rmi    = returnsMarket(iWindow);
    Rsmbi  = returnsSMB(iWindow);
    Rhmli  = returnsHML(iWindow);
    secRi  = secReturns(iWindow);
    Mdl = fitFF3FactorModel(LIBORi,Rmi,Rsmbi,Rhmli,secRi);
    iter = iter+1;
    Datest(iter)     = Dates(i+1);
    Alphat(iter)     = Mdl.Coefficients.Estimate(1);
    BetaMarket(iter) = Mdl.Coefficients.Estimate(2);
    BetaSMB(iter)    = Mdl.Coefficients.Estimate(3);
    BetaHML(iter)    = Mdl.Coefficients.Estimate(4);
end

%% Show Visual
if nargout == 0
    figure
    h1 = subplot(4,1,1);
    plot(h1,Datest,Alphat); hold(h1,'on');
    plot(h1,Datest,repmat(mean(Alphat),length(Datest),1),'r-.')
    grid('on')
    title(['Alpha from FF3 (\alpha = ' num2str(mean(Alphat),'%10.2f') ')'])
    h2 = subplot(4,1,2);
    plot(h2,Datest,BetaMarket); hold(h2,'on');
    plot(h2,Datest,ones(length(Datest),1),'blue-')
    plot(h2,Datest,ones(length(Datest),1),'r-.')
    grid('on')
    title(['Market Beta (\beta = ' num2str(mean(BetaMarket),'%10.2f') ')'])
    h3 = subplot(4,1,3);
    plot(h3,Datest,BetaSMB); hold(h3,'on');
    plot(h3,Datest,repmat(mean(BetaSMB),length(Datest),1),'r-.')
    plot(h3,Datest,ones(length(Datest),1),'blue-')
    grid('on')
    title(['SMB Beta (\beta = ' num2str(mean(BetaSMB),'%10.2f') ')'])
    h4 = subplot(4,1,4);
    plot(h4,Datest,BetaHML); hold(h4,'on');
    plot(h4,Datest,repmat(mean(BetaHML),length(Datest),1),'r-.')
    plot(h4,Datest,ones(length(Datest),1),'blue-')
    grid('on')
    title(['HML Beta (\beta = ' num2str(mean(BetaHML),'%10.2f') ')'])
end