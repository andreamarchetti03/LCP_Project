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

from Synthetic import stan_code
from Synthetic import vars

from datetime import datetime


def infer(file_name):

	freq = vars.freq
	dt = vars.dt
	
	# sample from the model
	n_chains = vars.n_chains
	n_warmup = vars.n_warmup
	n_sample = vars.n_sample
	
	code = stan_code.code
	
	#import data
	data_load = np.loadtxt(file_name)
	
	year  = data_load[:,0]
	cycle = data_load[:,1]
	
	df_sim = pd.DataFrame(data = {'t':year, 'y':cycle})
	
	# assign the data to the dictionary
	data = {'n':len(year), 'y_obs':df_sim['y'].values, 'freq':freq, 'dt':dt}
	
	# build the model
	posterior = stan.build(code, data=data, random_seed=12345)
	
	fit = posterior.sample(num_chains=n_chains, num_samples=n_sample, num_warmup=n_warmup,
	                       init=[{'A':vars.A_init, 'phi':vars.phi_init,
	                              't':df_sim['t'].values}]*n_chains)

	##### save fit to dataframe and write to csv file ######

	DateTime = datetime.now().strftime("%d_%m_%H_%M")

	name = 'fit_df_Syn' + DateTime + '_' + str(n_sample) + 'iter'

	fit.to_frame().to_csv(name)

	#### to import use 
	# df_new = pd.read_csv(name, index_col='draws')

	return fit, year, cycle
