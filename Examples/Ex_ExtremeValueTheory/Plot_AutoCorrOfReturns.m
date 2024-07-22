function Plot_AutoCorrOfReturns(Returns,Names)% Copyright 2014 The MathWorks, Inc.

%% Visualize the Sample Autocorrelation of the Returns & Returns^2figurefor i = 1:size(Returns,2)    subplot(4,3,i)    autocorr(Returns(:,i))    title(['\bf ACF of Returns: ' Names{i}])        subplot(4,3,i+6)    autocorr(Returns(:,i).^2)    title(['\bf ACF of Returns^2: ' Names{i}])end