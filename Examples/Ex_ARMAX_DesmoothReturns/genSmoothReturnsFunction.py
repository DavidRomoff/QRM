import numpy as np
import pandas as pd
import sys
# import matplotlib.pyplot as plt

def smooth_returns(alpha):
    # Set seed for reproducibility
    np.random.seed(42)

    # Generate synthetic volatile returns
    n_months = 120  # 10 years of monthly data
    dates = pd.date_range(start='2010-01-01', periods=n_months, freq='M')
    true_returns = np.random.normal(loc=0.01, scale=0.07, size=n_months)

    # Apply return smoothing
    smoothed_returns = np.zeros(n_months)

    # Initialize the first smoothed return
    smoothed_returns[0] = true_returns[0]

    # Apply exponential smoothing
    for t in range(1, n_months):
        smoothed_returns[t] = alpha * true_returns[t] + (1 - alpha) * smoothed_returns[t-1]

    # Plot the results
    # plt.figure(figsize=(12, 6))
    # plt.plot(dates, true_returns, label='True Returns')
    # plt.plot(dates, smoothed_returns, label='Smoothed Returns')
    # plt.title(f'True vs. Smoothed Returns (alpha={alpha})')
    # plt.xlabel('Date')
    # plt.ylabel('Returns')
    # plt.legend()
    # plt.grid(True)
    # plt.show()

    return smoothed_returns, true_returns

# Example usage:
alpha = sys.argv[1]  # Example alpha value
smoothed_returns, true_returns = smooth_returns(alpha)
