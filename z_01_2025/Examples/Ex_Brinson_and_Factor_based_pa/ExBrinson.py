import numpy as np

# Sample data
weights_portfolio = np.array([0.40, 0.30, 0.30])
returns_portfolio = np.array([0.12, 0.08, 0.06])
weights_benchmark = np.array([0.30, 0.30, 0.40])
returns_benchmark = np.array([0.10, 0.06, 0.05])

# Total returns
return_portfolio = np.sum(weights_portfolio * returns_portfolio)
return_benchmark = np.sum(weights_benchmark * returns_benchmark)

# Allocation Effect
allocation_effect = (weights_portfolio - weights_benchmark) * (returns_benchmark - return_benchmark)

# Selection Effect
selection_effect = weights_benchmark * (returns_portfolio - returns_benchmark)

# Display results
print('Allocation Effect by Sector:', allocation_effect)
print('Selection Effect by Sector:', selection_effect)
print('Total Allocation Effect:', np.sum(allocation_effect))
print('Total Selection Effect:', np.sum(selection_effect))
print('Total Return of Portfolio:', return_portfolio)
print('Total Return of Benchmark:', return_benchmark)
