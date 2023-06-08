# module to import spectrum of data

import numpy as np

#import the data for initialization
file_name = "Data/Be_10/Be_cycles.txt"

data_load = np.loadtxt(file_name)

frequencies  = data_load[:,0]
err_frequencies = data_load[:,1]
amplitudes = data_load[:,2]
err_amplitudes = data_load[:,3]
phases = data_load[:,4]
err_phases = data_load[:,5]

# average dt from Be series
dt = 4.873

# sample from the model
n_chains = 4
n_warmup = 2000
n_sample = 4000