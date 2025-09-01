function MarketIndex = Calculate_MarketCapWeightedIndex(Prices,MarketCap)% Copyright 2014 The MathWorks, Inc.

Weights = MarketCap/sum(MarketCap);MarketIndex = table2array(Prices)*Weights;