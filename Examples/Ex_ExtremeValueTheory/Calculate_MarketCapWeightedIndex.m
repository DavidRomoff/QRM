function MarketIndex = Calculate_MarketCapWeightedIndex(Prices,MarketCap)

Weights = MarketCap/sum(MarketCap);