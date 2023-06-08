import matplotlib.pyplot as plt
import numpy as np
import scipy as sp
from scipy.signal import welch
from statsmodels.graphics.tsaplots import plot_acf

from LCP_Project.STAN import vars

# set colors 
col_red = '#E21B1B'   #red
col_blue = '#1769E6'  #blue
col_green = '#00D10A' #green
col_orange = '#FFA500'  #orange

cols = [col_red, col_blue, col_green, col_orange]

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

    # move the observed signal to have 0 mean
	# as done in inference
	cycle = cycle - np.mean(cycle)

	return df_inference, year, t_mean, cycle


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
def visualise(data, inference, from_, to_): #, sparam):

	signal(data, inference, from_, to_)
	time_diff(data, inference, from_, to_)
	marginal(data, inference)
	#chains(data, inference, sparam)
	

def signal(data, inference, from_, to_):
	
	fit, year, t_mean, cycle = init(data, inference)
	
	A= fit["A"].mean()
	phi= fit["phi"].mean()
	
	y = A*np.cos(2*np.pi * vars.freq * t_mean + phi)
	
	# denoised signal
	plt.plot(t_mean[from_:to_],y[from_:to_],color="red", label="denoised")
	
	# original signal
	plt.plot(year[from_:to_],cycle[from_:to_],color="blue", label="original")
	
	plt.title("Signal", fontsize=14)
	plt.xlabel("Time [y]", fontsize=14)
	plt.ylabel("$y_{sim}$", fontsize=14)
	plt.legend()
	plt.show()
	

def time_diff(data, inference, from_, to_):

	fit, year, t_mean, cycle = init(data, inference)
	
	dif  = year - t_mean

	xi = t_mean[1:] - t_mean[:-1]

	fig, ax = plt.subplots(1,2, figsize=(15,5))

	default_params_1 = {
    'marker': '.',
    's': 15,
    #'lw': 1
    }
	
	ax[0].scatter(year, dif, **default_params_1)
	ax[0].set_title("Time difference", fontsize=14)
	ax[0].set_xlabel("Time [y]", fontsize=14)
	ax[0].set_ylabel("$t - t_{inf}$", fontsize=14)
	ax[0].grid(linewidth=0.5)

	
	ax[1].scatter(year[:-1], xi, **default_params_1)
	ax[1].set_title(r"$\xi_i$", fontsize=14)
	ax[1].set_xlabel("Index", fontsize=14)
	ax[1].set_ylabel(r"$\xi_i$", fontsize=14)
	ax[1].grid(linewidth=0.5)


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

	
def marginal(data, inference):

	fit, year, t_mean, cycle = init(data, inference)

	mean = fit["mean"]
	sd   = fit["sd"]
	tau  = fit["tau"]
	A    = fit["A"]
	phi  = fit["phi"]
	sigma_y = fit["sigma_y"]

	common_params = {
    'edgecolor': 'black',
    'alpha': 0.7,
	'bins' : 20,
	'color' : col_blue,
	'density' : True,
	}

	fig, ax = plt.subplots(2, 3, figsize=(15, 8))
	
	ax[0][0].hist(mean, **common_params); ax[0][0].set_title(r"$\mu$")
	ax[0][1].hist(sd, **common_params); ax[0][1].set_title(r"$\sigma$")
	ax[0][2].hist(tau, **common_params); ax[0][2].set_title(r"$\tau$")
	
	ax[1][0].hist(A, **common_params); ax[1][0].set_title("A")
	ax[1][1].hist(phi, **common_params); ax[1][1].set_title(r"$\Phi$")
	ax[1][2].hist(sigma_y, **common_params); ax[1][2].set_title(r"$\sigma_y$")

###### SUPERIMPOSE THE PRIORS ######
	# NB: these priors are for the 2nd and 3rd series
	# for the first, adjust accordingly
	
	common_params_2 = {
    'color' : col_green,
	'lw' : 2
	}

	# not a brilliant way for sure

	# mu
	x_min, x_max = ax[0][0].get_xlim()
	x = np.linspace(x_min, x_max, 1000)
	ax[0][0].plot(x, sp.stats.norm.pdf(x, loc=1, scale=0.1), **common_params_2)

	# sd
	x_min, x_max = ax[0][1].get_xlim()
	x = np.linspace(x_min, x_max, 1000)
	ax[0][1].plot(x, sp.stats.gamma.pdf(x, 1, scale=0.1), **common_params_2)

	# tau
	x_min, x_max = ax[0][2].get_xlim()
	x = np.linspace(x_min, x_max, 1000)
	ax[0][2].plot(x, sp.stats.uniform.pdf(x, 0, 200), **common_params_2)

	# A
	x_min, x_max = ax[1][0].get_xlim()
	x = np.linspace(x_min, x_max, 1000)
	ax[1][0].plot(x, sp.stats.norm.pdf(x, loc=10, scale=2), **common_params_2)

	# phi
	x_min, x_max = ax[1][1].get_xlim()
	x = np.linspace(x_min, x_max, 1000)
	ax[1][1].plot(x, sp.stats.norm.pdf(x, loc=2, scale=1), **common_params_2)

	# sigma_y
	x_min, x_max = ax[1][2].get_xlim()
	x = np.linspace(x_min, x_max, 1000)
	ax[1][2].plot(x, sp.stats.gamma.pdf(x, 1, scale=1), **common_params_2)




def chains(data, inference, sparam):

    fit, year, t_mean, cycle = init(data, inference)
    n = vars.n_chains

    param = fit[sparam]
    param_chains = split(param, n)
    
    fig, ax = plt.subplots(1,2, figsize=(15,5))


###### PLOT THE CHAINS #####

    default_params_1 = {
    'x' : np.arange(0,vars.n_sample),
    'marker': '.',
    's': 5,
    }

    # modify the ax
    ax[0].set(title=f'{sparam} chain', xlabel='Iteration', ylabel='Value')
    ax[0].grid(linewidth=0.5)

    for i in range(0,n):
        ax[0].scatter(y = param_chains[i], **default_params_1, color=cols[i])
        
        
###### PLOT THE AUTOCORRELATION ######

    default_params_2 = {
        'ax': ax[1],
        'lags': len(param_chains[0]) - 1,
        'alpha': None,
        'use_vlines': False,
        'bartlett_confint': False,
        'marker': '.',
        'markersize': 2
    }

    for i in range(0,n):
        plot_acf(param_chains[i], **default_params_2, color=cols[i])

    # modify the ax 
    ax[1].set(title=f'{sparam} autocorrelation', xlabel='lags', ylabel='ACF Value', ylim=(-0.2, 0.2))
    ax[1].grid(linewidth=0.5)
    
    # Add legend
    legend_labels = [f'ACF chain {i+1}' for i in range(n)]
    ax[1].legend(legend_labels, prop={'size': 12})
