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
    cores = np.arange(1, 37)
    Wn = W0 + cores * Wd
    pna = np.minimum(cores * pa1, pablimit)
    ena = Wn / pna
    pnb = np.minimum(cores * pb1, pablimit)
    enb = Wn / pnb
    pnc1 = np.minimum(cores * pb1, pc1limit)
    enc1 = Wn / pnc1
    pnc2 = np.minimum(cores * pb1, pc2limit)
    enc2 = Wn / pnc2

    print(f"for a) the n_min in {np.argmin(ena)+1} cores and the E_min is {np.min(ena)}")
    print(f"for b) the n_min in {np.argmin(enb)+1} cores and the E_min is {np.min(enb)}")
    print(f"for c1) the n_min in {np.argmin(enc1)+1} cores and the E_min is {np.min(enc1)}")
    print(f"for c2) the n_min in {np.argmin(enc2)+1} cores and the E_min is {np.min(enc2)}")
    

    # Plot 1: pna and pnb
    plt.figure()
    plt.plot(pna, ena, label='P(1)=1 $s^{-1}$, $P_{limit}$=15 $s^{-1}$', color='blue', marker='o')
    plt.plot(pnb, enb, label='P(1)=2.5 $s^{-1}$, $P_{limit}$=15 $s^{-1}$', color='red', marker='x')
    plt.xlabel('Performance [$s^{-1}$]')
    plt.ylabel('Energy [J]')
    plt.title('Z-plot for 2a-b')
    plt.grid(True)
    plt.legend()
    plt.tight_layout()
    plt.savefig('zplot_AB.png')

    # Plot 2: pnc1 and pnc2
    plt.figure()
    plt.plot(pnc1, enc1, label='P(1)=2.5 $s^{-1}$, $P_{limit}$=25 $s^{-1}$', color='green', marker='*')
    plt.plot(pnc2, enc2, label='P(1)=2.5 $s^{-1}$, $P_{limit}$=72 $s^{-1}$', color='black', marker='^')
    plt.xlabel('Performance [$s^{-1}$]')
    plt.ylabel('Energy [J]')
    plt.title('Z-plot for 2c')
    plt.grid(True)
    plt.legend()
    plt.tight_layout()
    plt.savefig('zplot_C.png')

# Run the main function
main()
