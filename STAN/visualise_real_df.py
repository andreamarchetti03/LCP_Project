# module to visualise things 
# afer importing the csv with inferred parameters as csv

import matplotlib.pyplot as plt
import numpy as np
from scipy.signal import welch

from LCP_Project.STAN import vars_real2

# retrieve the necessary variables separately
def init(data, df_inference):

	# calculate the array of inferred times
	t_mean = df_inference.loc[:, df_inference.columns.str.startswith('t.')].mean()

	#convert the resulting Series to a numpy array
	t_mean = t_mean.to_numpy()

	#reimport data to access year and cycle considered
	data_load = np.loadtxt(data)
	year  = data_load[:len(t_mean),0]
	cycle = data_load[:len(t_mean),1]

	frequencies_fix = vars_real2.frequencies[0:6]  

	#return also vector with fixed and inferred frequencies altogether
	frequencies = np.append(frequencies_fix, np.mean(df_inference["freq_inf"], axis=1))

	return df_inference, year, t_mean, cycle, frequencies

# split chains into different vectors	
def split(x, n_chains):
	
	# get the length of each chain
	n = len(x) / n_chains
	
	# create a vector with a single chain on each row
	chain = []
	
	# create the indeces: select, on the entire array, one element every 'chain' elements
	indeces = np.arange(0, len(x), n_chains)
	
	# fill the rows of 'chain'
	for i in range(0,n_chains):
		
		chain.append(x[indeces + i])
		
	return np.array(chain)

###############################################################################

# main function	
def visualise(data, inference, from_, to_, sparam):

	signal(data, inference, from_, to_)
	time_diff(data, inference, from_, to_)
	#PSD(inference)
	marginal(data, inference)
	chains(data, inference, sparam)
	

def signal(data, inference, from_, to_):
	
	fit, year, t_mean, cycle, freq = init(data, inference)
	
	A=np.mean(fit["A"], axis=1)
	phi=np.mean(fit["phi"], axis=1)

	# calculate the array of inferred A and phi
	A = inference.loc[:, inference.columns.str.startswith('A.')].mean()
	phi = inference.loc[:, inference.columns.str.startswith('phi.')].mean()
	
	#convert the resulting Series to a numpy array
	A = A.to_numpy()
	phi = phi.to_numpy()
   
	# number of data points
	Nsteps = len(t_mean)
	
	# number of waves
	Nwaves = len(A)


	y = np.zeros(Nsteps)
	print("Nwaves:", Nwaves)	

	for i in range(0,Nwaves): y = y + A[i] * np.cos(2*np.pi * freq[i] * t_mean + phi[i])
		
	# original signal
	plt.plot(year[from_:to_],cycle[from_:to_],color="blue", label="original")

	# denoised signal
	plt.plot(t_mean[from_:to_],y[from_:to_],color="red", label="denoised")

	plt.title("Signal")
	plt.xlabel("Year")
	plt.ylabel("Quantity")
	plt.legend()
	plt.show()
	

def time_diff(data, inference, from_, to_):

	fit, year, t_mean, cycle, freq = init(data, inference)
	
	dif  = year - t_mean

	xi = t_mean[1:] - t_mean[:-1]

	fig, ax = plt.subplots(1,2, figsize=(15,5))
	
	ax[0].scatter(year, dif)
	ax[0].set_title("Original Time - Inferred Time")
	ax[0].set_xlabel("Year")
	ax[0].set_ylabel("Delta t")
	
	ax[1].scatter(year[:-1], xi)
	ax[1].set_title("Inferred Xi's")
	ax[1].set_xlabel("Year")
	ax[1].set_ylabel("Delta t")
		

def PSD(data, inference):

	fit, year, t_mean, cycle, freq = init(data, inference)
	
	A=np.mean(fit["A"], axis=1)
	phi=np.mean(fit["phi"], axis=1)

	# calculate the array of inferred A and phi
	A = inference.loc[:, inference.columns.str.startswith('A.')].mean()
	phi = inference.loc[:, inference.columns.str.startswith('phi.')].mean()
	
	#convert the resulting Series to a numpy array
	A = A.to_numpy()
	phi = phi.to_numpy()

	Nwaves = len(freq)
	
	# denoised signal
	y = 0
	#adattare
	#for i in range(0,Nwaves): y = y + A[i] * np.cos(2*np.pi * freq[i] * t_mean + phi[i])
	
	sampling_freq = 1 / np.mean(np.diff(year))
	freqs_, pow_ = welch(cycle, fs=sampling_freq)#, nperseg=1024)
	
	sampling_freq = 1 / np.mean(np.diff(t_mean))
	freqs_corr, pow_corr = welch(y, fs=sampling_freq)#, nperseg=1024)
	
	# Plot the PSD
	fig, (ax1, ax2) = plt.subplots(1,2, figsize=(15,5))
	
	ax1.semilogy(freqs_, pow_)
	ax1.set_xlabel('Frequency [Hz]')
	ax1.set_ylabel('PSD [V**2/Hz]')
	ax1.set_title("Original")
	
	ax2.semilogy(freqs_corr, pow_corr)
	ax2.set_xlabel('Frequency [Hz]')
	ax2.set_ylabel('PSD [V**2/Hz]')
	ax2.set_title("Denoised")
	
	plt.show()


def marginal(data, inference):

	fit, year, t_mean, cycle, freq = init(data, inference)

	freq_inf = fit["freq_inf.0"]
	mean = fit["mean"]
	sd   = fit["sd"]
	tau  = fit["tau"]
	A    = fit["A.0"]
	phi  = fit["phi.0"]
	sigma_y = fit["sigma_y"][0]
		
	fig, ax = plt.subplots(3, 3, figsize=(15, 8))
	
	ax[0][0].hist(mean); ax[0][0].set_title("mean")
	ax[0][1].hist(sd); ax[0][1].set_title("sd")
	ax[0][2].hist(tau); ax[0][2].set_title("tau")
	
	ax[1][0].hist(A); ax[1][0].set_title("A")
	ax[1][1].hist(phi); ax[1][1].set_title("phi")
	ax[1][2].hist(sigma_y); ax[1][2].set_title("sigma_y")

	ax[2][0].hist(freq); ax[2][0].set_title("freq_inf")



	
	
def chains(data, inference, sparam):

	fit, year, t_mean, cycle, freq = init(data, inference)
	
	param = fit[sparam]

	param_chains = split(param, vars_real2.n_chains)
	
	fig, ax = plt.subplots(1,1, figsize=(6,4))
	
	ax.set_title(sparam)
	ax.set_xlabel("Iteration")
	ax.set_ylabel("Value")
	
	for i in range(0,vars_real2.n_chains):
		
		ax.scatter(np.arange(0,vars_real2.n_sample), param_chains[i])
		