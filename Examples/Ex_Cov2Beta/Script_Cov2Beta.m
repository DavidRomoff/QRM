%% Create y & X Data
N = 1000;
NumOfFactors = 5;
% rng('default');
X                   = randn(N,NumOfFactors);
Beta                = rand(1,NumOfFactors);
Beta                = Beta/sum(Beta);
ErrorVarianceActual = 0.05;
y                   = X*Beta' + ErrorVarianceActual*randn(N,1);
figure;
plot(y)
disp(Beta)

%% OLS
LM   = fitlm(X,y,'Intercept',false);
yEst = predict(LM,X);
ErrorVarianceEstimated = std(yEst - y);
figure
plot(y,yEst,'ko')
T                 = table();
T.BetaActual      = Beta(:);
T.BetaEstimatedLM = LM.Coefficients.Estimate;

E = table();
E.ErrorVarianceActual    = ErrorVarianceActual;
E.ErrorVarianceEstimated = ErrorVarianceEstimated;

%% Estimate Beta from Covariance
C = cov([y X]);
d = diag(C);
d = d(2:end);
T.BetaEstimatedCov = (C(1,2:end)./d')';
yEstCov = X*T.BetaEstimatedCov;
figure
plot(y,yEstCov,'ko')
xlabel('Actual')
ylabel('Predicted')

%% Estimate Beta from QR Decomposition
C = cov([y X]);
[Q,R] = qr(C);
d = diag(C);
d = d(2:end);
T.BetaEstimatedCov = (C(1,2:end)./d')';
yEstCov = X*T.BetaEstimatedCov;
figure
plot(y,yEstCov,'ko')
xlabel('Actual')
ylabel('Predicted')
