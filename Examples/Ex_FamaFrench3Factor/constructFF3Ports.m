function Ports = constructFF3Ports(FinData,Prices,Returns)

%% Setup Small vs. Large
Ismall = FinData.MarketCap <= median(FinData.MarketCap);
Ilarge = FinData.MarketCap > median(FinData.MarketCap);
FinData.FF3TypeSmallLarge = repmat("",height(FinData),1);
FinData.FF3TypeSmallLarge(Ismall) = "Small";
FinData.FF3TypeSmallLarge(Ilarge) = "Large";

%% Setup logical splits
Ismallvalue   = FinData.FF3TypeSmallLarge == "Small" & FinData.FF3TypeValueNeutralGrowth == "Value";
Ismallneutral = FinData.FF3TypeSmallLarge == "Small" & FinData.FF3TypeValueNeutralGrowth == "Neutral";
Ismallgrowth  = FinData.FF3TypeSmallLarge == "Small" & FinData.FF3TypeValueNeutralGrowth == "Growth";
Ibigvalue   = FinData.FF3TypeSmallLarge == "Large" & FinData.FF3TypeValueNeutralGrowth == "Value";
Ibigneutral = FinData.FF3TypeSmallLarge == "Large" & FinData.FF3TypeValueNeutralGrowth == "Neutral";
Ibiggrowth  = FinData.FF3TypeSmallLarge == "Large" & FinData.FF3TypeValueNeutralGrowth == "Growth";

%% Setup Portfolios based on logical splits
Ports.smallvalueFinData     = FinData(Ismallvalue,:);
Ports.smallvaluePrices      = Prices(:,Ismallvalue);
Ports.smallvalueReturns     = Returns(:,Ismallvalue);
wSmallValue                 = Ports.smallvalueFinData.MarketCap/sum(Ports.smallvalueFinData.MarketCap);
Ports.smallvaluePortReturns = Ports.smallvalueReturns{:,:}*wSmallValue;

Ports.smallneutralFinData   = FinData(Ismallneutral,:);
Ports.smallneutralPrices    = Prices(:,Ismallneutral);
Ports.smallneutralReturns   = Returns(:,Ismallneutral);
wSmallNeutral               = Ports.smallneutralFinData.MarketCap/sum(Ports.smallneutralFinData.MarketCap);
Ports.smallneutralPortReturns = Ports.smallneutralReturns{:,:}*wSmallNeutral;

Ports.smallgrowthFinData    = FinData(Ismallgrowth,:);
Ports.smallgrowthPrices     = Prices(:,Ismallgrowth);
Ports.smallgrowthReturns    = Returns(:,Ismallgrowth);
wSmallGrowth                = Ports.smallgrowthFinData.MarketCap/sum(Ports.smallgrowthFinData.MarketCap);
Ports.smallgrowthPortReturns = Ports.smallgrowthReturns{:,:}*wSmallGrowth;

Ports.bigvalueFinData       = FinData(Ibigvalue,:);
Ports.bigvaluePrices        = Prices(:,Ibigvalue);
Ports.bigvalueReturns       = Returns(:,Ibigvalue);
wBigValue                   = Ports.bigvalueFinData.MarketCap/sum(Ports.bigvalueFinData.MarketCap);
Ports.bigvaluePortReturns = Ports.bigvalueReturns{:,:}*wBigValue;

Ports.bigneutralFinData     = FinData(Ibigneutral,:);
Ports.bigneutralPrices      = Prices(:,Ibigneutral);
Ports.bigneutralReturns     = Returns(:,Ibigneutral);
wBigNeutral                 = Ports.bigneutralFinData.MarketCap/sum(Ports.bigneutralFinData.MarketCap);
Ports.bigneutralPortReturns = Ports.bigneutralReturns{:,:}*wBigNeutral;

Ports.biggrowthFinData      = FinData(Ibiggrowth,:);
Ports.biggrowthPrices       = Prices(:,Ibiggrowth);
Ports.biggrowthReturns      = Returns(:,Ibiggrowth);
wBigGrowth                  = Ports.biggrowthFinData.MarketCap/sum(Ports.biggrowthFinData.MarketCap);
Ports.biggrowthPortReturns = Ports.biggrowthReturns{:,:}*wBigGrowth;