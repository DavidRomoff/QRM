function plot3FactorReturns(returnsMarket,returnsSMB,returnsHML)

%% Calculate Correlation
C = corrcoef([returnsMarket returnsSMB returnsHML]);

%% Visualize Results
figure
h1 = subplot(1,3,1);
plot(returnsMarket,returnsSMB,'ko','MarkerFaceColor',"blue");
xlabel('Market Returns')
ylabel('Small minus big portfolio')
title(['Market vs. SMB Returns \rho = ' num2str(C(1,2),'%10.2f')])
fit_ellipse( returnsMarket,returnsSMB,h1);

h2 = subplot(1,3,2);
plot(returnsMarket,returnsHML,'ko','MarkerFaceColor',"red");
xlabel('Market Returns')
ylabel('High minus low portfolio')
title(['Market vs. HML Returns \rho = ' num2str(C(1,3),'%10.2f')])
fit_ellipse(returnsMarket,returnsHML,h2);

h3 = subplot(1,3,3);
plot(returnsSMB,returnsHML,'ko','MarkerFaceColor',"green");
xlabel('Small minus big portfolio')
ylabel('High minus low portfolio' )
title(['SMB vs. HML Returns \rho = ' num2str(C(2,3),'%10.2f')])
fit_ellipse(returnsSMB,returnsHML,h3);