import matplotlib.pyplot as plt
import numpy as np

W0 = 80
Wd = 4
pa1 = 1
pb1 = 2.5
pablimit = 15
pc1limit = 25
pc2limit = 72

def main():
  cores = np.arange(1,37)
  Wn = W0 + cores * Wd
  pna = np.minimum(cores*pa1,pablimit)
  ena = Wn/pna
  pnb = np.minimum(cores*pb1,pablimit)
  enb = Wn/pnb
  pnc1 = np.minimum(cores*pb1, pc1limit)
  enc1 = Wn/pnc1
  pnc2 = np.minimum(cores*pb1, pc2limit)
  enc2 = Wn/pnc2
  # Plotting
  plt.figure()

  # Plot ena vs pna and enb vs pnb on the same graph
  plt.plot(pna, ena, label='P(1)=1 $s^{-1}$, $P_{limit}$=15 $s^{-1}$', color='blue', marker='o')
  plt.plot(pnb, enb, label='P(1)=2.5 $s^{-1}$, $P_{limit}$=15 $s^{-1}$', color='red', marker='x')
  plt.plot(pnc1, enc2, label='P(1)=2.5 $s^{-1}$, $P_{limit}$=25 $s^{-1}$', color='green', marker='*')
  plt.plot(pnc2, enc2, label='P(1)=2.5 $s^{-1}$, $P_{limit}$=72 $s^{-1}$', color='black', marker='^')
    
  # Labels and title
  plt.xlabel('performance [$s^{-1}$]')
  plt.xscale('log')
  plt.ylabel('Energy [J]')
  plt.title('Z-plot ')

  plt.grid(True)
  plt.legend()

  # Save the plot as a file
  plt.tight_layout()
  plt.savefig('zplotab.png')

# Run the main function
main()