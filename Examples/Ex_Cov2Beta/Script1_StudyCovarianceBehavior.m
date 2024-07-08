%% Setup Covariance Matrix from Correlatin
R = [1.00 0.25 0.90; ...
     0.25 1.00 0.50; ...
     0.90 0.50 1.00];
 
% standard deviations of each variable
c = [1  4  9];
D = diag(c);
 
K = D*R*D; %% covariance matrix

%% Setup Multivariate Normal
m  = 1000;
mu = [2 3 0];
X = mvnrnd(mu,K,m);

%% Convert RVs into Copula Scale
% Transform the data to the copula scale (unit square) using a kernel
% estimator of the cumulative distribution function.
U = [];
for i = 1:size(X,2)
    U(:,i) = ksdensity(X(:,i),X(:,i),'function','cdf');
end

%% Copulafit Model
[Rho,nu] = copulafit('t',U,'Method','ApproximateML');

%% Convert back into Random Variables
Xnew = [];
for i = 1:size(X,2)
    Xnew(:,i) = ksdensity(X(:,i),U(:,i),'function','icdf'); 
end