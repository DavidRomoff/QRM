function Plot_ParetoAndNormalFit(ParetoTailsDist,NormalDist,Returns,tailFraction)

minProbability = ParetoTailsDist.cdf((min(Returns)));