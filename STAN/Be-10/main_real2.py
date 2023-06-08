# main module to build the STAN model
# and perform sampling given the timeseries

# import libraries

import numpy as np
import pandas as pd
import nest_asyncio
nest_asyncio.apply()

import stan

import matplotlib.pyplot as plt
plt.rcParams['axes.labelsize'] = 18
plt.rcParams['axes.titlesize'] = 18
plt.rcParams['legend.fontsize'] = 10
plt.rcParams['xtick.labelsize'] = 8
plt.rcParams['ytick.labelsize'] = 8

from statsmodels.graphics.tsaplots import plot_acf
from scipy.signal import welch

from Be-10 import stan_code_real2
from Be-10 import vars_real2

from datetime import datetime


def infer(file_name):
	
	frequencies_fix = vars_real2.frequencies[0:5]
	err_frequencies_fix = vars_real2.err_frequencies[0:5]
	frequencies_inf = vars_real2.frequencies[5:]
	err_frequencies_inf = vars_real2.err_frequencies[5:]
	amplitudes = vars_real2.amplitudes
	err_amplitudes = vars_real2.err_amplitudes
	phases = vars_real2.phases
	err_phases = vars_real2.err_phases

	N_fix = len(frequencies_fix)
	N_inf = 3       #number of frequencies to infer

	dt = vars_real2.dt	

	# sample from the model
	n_chains = vars_real2.n_chains
	n_warmup = vars_real2.n_warmup
	n_sample = vars_real2.n_sample
	
	code = stan_code_real2.code

	
	#import data
	data_load = np.loadtxt(file_name)
	
	year  = data_load[:,0]
	cycle = data_load[:,1]
	
	# move the observed signal to have 0 mean
	# on the entire dataset to match the given amplitudes
	cycle = cycle - np.mean(data_load[:,1])
	
	df_sim = pd.DataFrame(data = {'t':year, 'y':cycle})
	
	# assign the data to the dictionary
	data = {'n':len(year), 'y_obs':df_sim['y'].values, 'freq_fix':frequencies_fix, 'dt':dt, 
			'N_fix':N_fix, 'N_inf':N_inf, 'N_waves':N_fix+N_inf, 'freq_init':frequencies_inf, 'err_freq_init':err_frequencies_inf, 
			'A_init':amplitudes, 'err_A_init':err_amplitudes, 'phi_init':phases, 'err_phi_init':err_phases}

	# build the model
	posterior = stan.build(code, data=data, random_seed=12345)
	

	fit = posterior.sample(num_chains=n_chains, num_samples=n_sample, num_warmup=n_warmup,
	                       init=[{'A':vars_real2.amplitudes, 'phi':vars_real2.phases,
	                              't':df_sim['t'].values}]*n_chains)

	#return also vector with fixed and inferred frequencies altogether
	frequencies = np.append(frequencies_fix, np.mean(fit["freq_inf"], axis=1))

	##### save fit to dataframe and write to csv file ######

	DateTime = datetime.now().strftime("%d_%m_%H_%M")

	name = 'fit_df_Be_' + DateTime + '_' + str(n_sample) + 'iter_mac'

	fit.to_frame().to_csv(name)

	#### to import use 
	# df_new = pd.read_csv(name, index_col='draws')
	

	return fit, year, cycle, frequencies
