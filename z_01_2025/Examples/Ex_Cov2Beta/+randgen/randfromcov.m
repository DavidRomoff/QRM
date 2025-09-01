function X = randfromcov(K,m,n)

%% Input Checking
if nargin == 0
    K = [ 1    0.7  ; ...
          0.7   1   ];
    m = 10000;
    n = 2;      
end

%% Generate Random Numbers
X = randn(m, n) * chol(K);