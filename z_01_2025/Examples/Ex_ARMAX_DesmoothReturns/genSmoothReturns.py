import numpy as np
import pandas as pd
# import matplotlib.pyplot as plt

# Set seed for reproducibility
np.random.seed(42)

# Generate synthetic volatile returns
n_months = 120  # 10 years of monthly data
dates = pd.date_range(start='2010-01-01', periods=n_months, freq='ME')
true_returns = np.random.normal(loc=0.01, scale=0.07, size=n_months)

# Create a DataFrame
data = pd.DataFrame({'Date': dates, 'True_Returns': true_returns})

# Apply return smoothing
smoothed_returns = np.zeros(n_months)
alpha = 0.6  # Smoothing parameter (higher value means more smoothing)

# Initialize the first smoothed return
smoothed_returns[0] = true_returns[0]

# Apply exponential smoothing
for t in range(1, n_months):
    smoothed_returns[t] = alpha * true_returns[t] + (1 - alpha) * smoothed_returns[t-1]

# Add smoothed returns to the DataFrame
data['Smoothed_Returns'] = smoothed_returns
