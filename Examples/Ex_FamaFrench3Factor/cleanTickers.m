function [Returns,Prices,FinData] = cleanTickers(Returns,Prices,FinData,Ibad)

Returns(:,Ibad) = [];
Prices(:,Ibad) = [];
FinData(Ibad,:) = [];