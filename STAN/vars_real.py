import numpy as np

#crea arrays con periodi, ampiezze e fasi
#leggendoli da Insu_cycles.txt
file_name = "LCP_Project/Data/Insu_cycles.txt"

data_load = np.loadtxt(file_name)

periods  = data_load[:,0]
amplitudes = data_load[:,1]
phases = data_load[:,2]

dt = 10

# sample from the model
n_chains = 4
n_warmup = 200
n_sample = 400
