import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors

# Load CSV file
csv_file = 'data.csv'
df = pd.read_csv(csv_file)

# Normalize data
data = df.to_numpy()
min_val = np.min(data)
max_val = np.max(data)
normalized_data = (data - min_val) / (max_val - min_val)

# Create a colormap
cmap = plt.get_cmap('viridis')

# Create the image
fig, ax = plt.subplots()
cax = ax.matshow(normalized_data, cmap=cmap)

# Add colorbar
fig.colorbar(cax)

# Save the image
output_image = 'output_image.png'
plt.savefig(output_image)
plt.show()
