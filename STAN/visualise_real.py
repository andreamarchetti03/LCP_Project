import matplotlib.pyplot as plt
import numpy as np
from scipy.signal import welch

from LCP_Project.STAN import vars_real

# retrieve the necessary variables separately
def init(inference):

	# calculate the array of inferred times
	t = inference[0]["t"]
	t_mean = np.mean(t,axis=1)

	return inference[0], inference[1], t_mean, inference[2]

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
	
###############################################################################�

# main function	
def visualise(inference, from_, to_, sparam):

	signal(inference, from_, to_)
	time_diff(inference, from_, to_)
	PSD(inference)
	marginal(inference)
	chains(inference, sparam)
	

def signal(inference, from_, to_):
	
    fit, year, t_mean, cycle = init(inference)
	
    A=np.mean(fit["A"], axis=1)
    phi=np.mean(fit["phi"], axis=1)
    
    # number of data points
    Nsteps = len(t_mean)
	
	# number of waves
    Nwaves = len(A)

    freq = 1/(vars_real.periods)
    y = np.zeros(Nsteps)
	
    for i in range(1,Nwaves): y = A[i] * np.cos(2*np.pi * freq[i] * t_mean + phi[i])
    	
	# denoised signal
    plt.plot(t_mean[from_:to_],y[from_:to_],color="red", label="denoised")

    # original signal
    plt.plot(year[from_:to_],cycle[from_:to_],color="blue", label="original")

    plt.title("Signal")
    plt.xlabel("Year")
    plt.ylabel("Quantity")
    plt.legend()
    plt.show()
	

def time_diff(inference, from_, to_):

	fit, year, t_mean, cycle = init(inference)
	
	dif  = year - t_mean

	xi = t_mean[:-1] - t_mean[1:]

	fig, ax = plt.subplots(1,2, figsize=(15,5))
	
	ax[0].scatter(year, dif)
	ax[0].set_title("Original Time - Inferred Time")
	ax[0].set_xlabel("Year")
	ax[0].set_ylabel("Delta t")
	
	ax[1].scatter(year[:-1], xi)
	ax[1].set_title("Inferred Xi's")
	ax[1].set_xlabel("Year")
	ax[1].set_ylabel("Delta t")
		

def PSD(inference):

	fit, year, t_mean, cycle = init(inference)
	
	A=np.mean(fit["A"])
	phi=np.mean(fit["phi"])
	
	# denoised signal
	y = A*np.cos(2*np.pi*vars.freq*t_mean + phi)
	
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

	
def marginal(inference):

	fit, year, t_mean, cycle = init(inference)

	mean = fit["mean"][0]
	sd   = fit["sd"][0]
	tau  = fit["tau"][0]
	A    = fit["A"][0]
	phi  = fit["phi"][0]
	sigma_y = fit["sigma_y"][0]
	
	#plt.scatter(np.arange(0, len(mean[0])), mean[0])
	
	fig, ax = plt.subplots(2, 3, figsize=(15, 8))
	
	ax[0][0].hist(mean); ax[0][0].set_title("mean")
	ax[0][1].hist(sd); ax[0][1].set_title("sd")
	ax[0][2].hist(tau); ax[0][2].set_title("tau")
	
	ax[1][0].hist(A); ax[1][0].set_title("A")
	ax[1][1].hist(phi); ax[1][1].set_title("phi")
	ax[1][2].hist(sigma_y); ax[1][2].set_title("sigma_y")
	
	
def chains(inference, sparam):

	fit, year, t_mean, cycle = init(inference)
	
	param = fit[sparam][0]

	param_chains = split(param, vars.n_chains)
	
	fig, ax = plt.subplots(1,1, figsize=(6,4))
	
	ax.set_title(sparam)
	ax.set_xlabel("Iteration")
	ax.set_ylabel("Value")
	
	for i in range(0,vars.n_chains):
	    
	    ax.scatter(np.arange(0,vars.n_sample), param_chains[i])
	    