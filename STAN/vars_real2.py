import numpy as np

#crea arrays con periodi, ampiezze e fasi
#leggendoli da Insu_cycles_final.txt
file_name = "LCP_Project/Data/Be_cycles.txt"

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

#### con 40+80 iterazioni 1 catena funziona in circa 10 min ####
#### anche con 240 interazioni ####

N_fix = 6
N_inf = 14
