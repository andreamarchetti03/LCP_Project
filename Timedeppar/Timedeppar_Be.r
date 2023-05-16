
#Timedeppar functions and inference

# import packages
install.packages('timedeppar')
install.packages('invgamma')
library(timedeppar)
library(invgamma)
seed = 12345



# define observational likelihood
loglikeli <- function(param, data) {

    # get parameter xi at time points of observations
	
    sigma_y <- param$sigma_y
	
    xi<-param$xi
    

    if ( is.matrix(xi) | is.data.frame(xi) ) {
        xi <- approx(x = xi[,1], y = xi[,2], xout = data[['t']])$y
    }

    # corrupted time
    
    t_corr <- rep(0, n_main)
    t_corr[1] <- 2
    for (i in 2:n_main) {
            t_corr[i] <- t_corr[i-1] + xi[i]
    }

    # corrupted model
    y_corr <- rep(0, length(t_corr))
	
    #for (j in 1:n_cycle){
	#	y_corr <- y_corr + param[[paste0('A.',j)]]*cos(2*pi*freq[j]*t_corr + param[[paste0('ph.',j)]])
	#}	
		
	
	#	New version
	for (j in 1:(n_fix-1)){
		y_corr <- y_corr + param[[paste0('A.',j)]]*cos(2*pi*freq_i[j]*t_corr + param[[paste0('ph.',j)]])
	}	
	
	for (j in n_fix:n_cycle){
		y_corr <- y_corr + param[[paste0('A.',j)]]*cos(2*pi*param[[paste0('freq.',j)]]*t_corr + param[[paste0('ph.',j)]])
		
	}


    # calculate likelihood
    log_likelihood_y <- sum(dnorm(data[['y_obs']], mean = y_corr, sd = sigma_y, log = T))

    # return result
    return(log_likelihood_y)
    
}

# define priors for Orstein-Uhlenbeck parameters

logprior_ou <- function(param_ou) {

    # calculate log priors for the given parameters
    log_prior_mean <- dnorm(param_ou[['xi_mean']], mean = 10, sd = 0.5, log = T)
    log_prior_sd <- dunif(param_ou[['xi_sd']], min = 0.001, max = 3, log = T)
    log_prior_gamma <- dunif(param_ou[['xi_gamma']], min = 0.000001, max = 1, log = T)

    # return result
    return(log_prior_mean + log_prior_sd + log_prior_gamma)

}

# define priors for constant parameters
logprior_const <- function(param_const) {
	
    # calculate priors
    log_prior_sigma_y <- dunif(param_const[['sigma_y']], min = 0.001, max = 1, log = T)
	
	log_prior_A <- 0
	for (k in 1:n_cycle){
		log_prior_A <- log_prior_A + dnorm(param_const[[paste0('A.',k)]], mean = df_cycle[['A']][k], sd = df_cycle[['sigma_A']][k], log = T)
	}

	
	log_prior_ph <- 0
	for (k in 1:n_cycle){
		log_prior_ph <- log_prior_ph + dnorm(param_const[[paste0('ph.',k)]], mean = df_cycle[['ph']][k] , sd = df_cycle[['sigma_ph']][k], log = T)
	}
	
	
	
	log_prior_freq <- 0
	for (k in n_fix:n_cycle){
		log_prior_freq <- log_prior_freq + dnorm(param_const[[paste0('freq.',k)]], mean = df_cycle[['freq']][k], sd = df_cycle[['sigma_f']][k], log = T)
	}
	

    # return result
    return(log_prior_sigma_y + log_prior_A + log_prior_ph + log_prior_freq)
	#return(log_prior_sigma_y)
}



#Inference

inference <- function(name){
    
    #Read data
	
    file <- paste(name,'.txt', sep='')
	file_str <- paste('Data/',file,sep='')
    df <- read.csv(file_str, header = T, sep = '\t')
	
    df = df[1:n_main,]
	
	#Shift data around 0 
	mean_y = mean(df$y_obs)
	df$y_obs = df$y_obs - mean_y
	
	#Times also...
	df$t = df$t - (df$t[1] - 2)
	
    
    #Inizialization of xi parameters
	
	xi_init <- NULL
	xi_init <- append(xi_init, df$t[1])
	for (i in 2:n_main){
		param <- df$t[i]-df$t[i-1]
		xi_init <- append(xi_init, param)
	}
    df$init <- xi_init
    xi = df[,c('t','init')]       #It could also be a randOU sequence..
    
    
	
	# A parameters
	A <- NULL
	for (i in 1:n_cycle) {
		param <- df_cycle[['A']][i]
		names(param) <- paste0('A.',i)
		A <- append(A, param) 
	}

	# ph parameters
	ph <- NULL
	for (i in 1:n_cycle) {
		param <- df_cycle[['ph']][i]
		names(param) <- paste0('ph.',i)
		ph <- append(ph, param) 
	}
	
	
	# f parameters
	freq <- NULL
	for (i in n_fix:n_cycle) {
		param <- freq_i[i]
		names(param) <- paste0('freq.',i)
		freq <- append(freq, param) 
	}
	
	
	param_init <- list( 'xi' = xi ,'sigma_y' = 0.5)
	param_init <- c(param_init, A, ph, freq)
	
	
    # ranges of constant parameters
	param_range <- list('sigma_y' = c(0,1))

	# A parameters range
	A_range <- NULL
	for (i in 1:n_cycle) {
		par_range <-  list(c(0,0.5))
		names(par_range) <- paste0('A.',i)
		A_range <- append(A_range, par_range) 
	}

	# ph parameters range
	ph_range <- NULL
	for (i in 1:n_cycle) {
		par_range <- list(c(0,2*pi))
		names(par_range) <- paste0('ph.',i)
		ph_range <- append(ph_range, par_range) 
	}
	
	
	# freq parameters range
	freq_range <- NULL
	for (i in n_fix:n_cycle) {
		par_range <- list(c(0,0.02))
		names(par_range) <- paste0('freq.',i)
		freq_range <- append(freq_range, par_range) 
	}
	

	param_range <- c(param_range, A_range, ph_range, freq_range)
    
    # choose model parameters:
    xi_mean <- 2
    xi_sd <- 0.2
    xi_gamma <- 1/200
    
    
    #Perform Timedapper inference
    inf <- NULL
    inf <- infer.timedeppar(loglikeli = loglikeli, 
                            param.ini = param_init,
                            param.range = param_range,
                            param.logprior = logprior_const,
                            param.ou.ini = c(xi_mean = xi_mean, xi_sd = xi_sd, xi_gamma = xi_gamma),
                            param.ou.logprior = logprior_ou,
                            n.iter = n_iter,
                            control = list(n.interval = n_interval, n.adapt = n_adapt, n.adapt.cov = n_adapt_cov),
                            file.save = name,
                            data = df) 
    
    #Extract inferred data
    
    # remove burn in and apply thinning
    start <- 1 + n_adapt + 1
    end <- n_iter + 1
    th <- 10
    
    # collect parameters
    df_inf_ou <- as.data.frame(inf$sample.param.ou[seq(start, end, th),])
    df_inf_const <- as.data.frame(inf$sample.param.const[seq(start, end, th),])
    df_inf_xi <- as.data.frame(inf$sample.param.timedep[[1]][seq(start+1, end+1, th),])
	
	
    #Name xi sequence
    names(df_inf_xi) <- paste0(rep('xi.', n_main), as.character(seq(1, n_main)))
    df_inf <- cbind(df_inf_ou, df_inf_const, df_inf_xi)
    
    
    #Function to infer mean of parameters from results file

    infer_par <- function(names, data) {
	
		par_inf <- NULL

		for (name in names) {
			param <- quantile(data[[name]], probs = 0.5)
			names(param) <- name
			par_inf <- append(par_inf, param)
		}

		return(par_inf)


    }
    
    #Inferred parameters

    # A inferred parameters
	A_inf = infer_par(names(A), df_inf)

	# ph inferred parameters
	ph_inf = infer_par(names(ph), df_inf)

	
	# freq inferred parameters
	freq_inf = infer_par(names(freq), df_inf)

	# xi parameters
	
    xi_inf = infer_par(names(df_inf_xi), df_inf)
    
    #xi mean
    xi_mean_inf=infer_par(list("xi_mean"),df_inf)
	
	#xi sd
    xi_sd_inf=infer_par(list("xi_sd"),df_inf)
	
	#xi gamma
    xi_gamma_inf=infer_par(list("xi_gamma"),df_inf)

    t_inf <- rep(1,n_main)

    t_inf[1]=xi_inf[1]

    for (i in 2:n_main) {
        t_inf[i]=t_inf[i-1]+xi_inf[i]
	}
    
    df$xi_inf <- xi_inf
    names(df$xi_inf)= 'xi_inf'
    
    df$t_inf <- t_inf
    names(df$t_inf)= 't_inf'
	
	#Estimates y_fit
	
	y_d = rep(0, n_main)

	#for (j in 1:n_cycle) {
	#	y_d = y_d + A_inf[j]*cos(2*pi*freq[j]*t_inf + ph_inf[j])
	#}
	
	#New version
	for (j in 1:(n_fix-1)){
		y_d <- y_d + A_inf[j]*cos(2*pi*freq_i[j]*t_inf + ph_inf[j])
	}

	
	for (j in n_fix:n_cycle){
		y_d <- y_d + A_inf[j]*cos(2*pi*freq_inf[j-(n_fix-1)]*t_inf + ph_inf[j])
	}	
	
	df$y_d <- y_d
	
	
	#Estimates difference between original and inferred times

    df$t_diff <- df$t - df$t_inf
	
    
    # Combine the results into a list


    return_list <- list(df = df, df_inf = df_inf, A_inf = A_inf, ph_inf= ph_inf, inf = inf, freq_inf = freq_inf , xi_mean_inf = xi_mean_inf, xi_sd_inf = xi_sd_inf, xi_gamma_inf = xi_gamma_inf) #sigma_y left to infer

      
    return(return_list)
    
}