function out = myRegressionObj(Betas,X,y)

out = sum((y - X*Betas).^2);