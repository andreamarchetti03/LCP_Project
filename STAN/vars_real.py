import numpy as np

#crea arrays con periodi, ampiezze e fasi
#leggendoli da Insu_cycles.txt
file_name = "LCP_Project/Data/Insu_cycles.txt"

data_load = np.loadtxt(file_name)

print(data_load)

periods  = data_load[:,0]
amplitudes = data_load[:,1]
phases = data_load[:,2]

dt = 10

# sample from the model
n_chains = 1
n_warmup = 1
n_sample = 1
