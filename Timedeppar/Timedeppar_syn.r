
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
    A <- param$A
    ph<-param$ph
    
    xi<-param$xi
    
    if ( is.matrix(xi) | is.data.frame(xi) ) {
        xi <- approx(x = xi[,1], y = xi[,2], xout = data[['t']])$y
    }

    # corrupted time 
    t_corr <- rep(0, n)
    t_corr[1] <- 1
    for (i in 2:n) {
            t_corr[i] <- t_corr[i-1] + xi[i]
    }

    # corrupted model
    y_corr <- rep(0, length(t_corr)) 
    y_corr <- y_corr + A*cos(2*pi*freq_syn*t_corr + ph)

    # calculate likelihood
    log_likelihood_y <- sum(dnorm(data[['y_obs']], mean = y_corr, sd = sigma_y, log = T))

    # return result
    return(log_likelihood_y)  
}

# define priors for Orstein-Uhlenbeck parameters
logprior_ou <- function(param_ou) {

    # calculate log priors for the given parameters
    log_prior_mean <- dnorm(param_ou[['xi_mean']], mean = 1, sd = 0.1, log = T)
    log_prior_sd <- dgamma(param_ou[['xi_sd']], shape = 1, rate = 100, log = T)
    log_prior_gamma <- dunif(param_ou[['xi_gamma']], min = 0, max = 20, log = T)

    # return result
    return(log_prior_mean + log_prior_sd + log_prior_gamma)

}

# define priors for constant parameters
logprior_const <- function(param_const) {

    # calculate priors
    log_prior_sigma_y <- dgamma(param_const[['sigma_y']], shape = 1, rate = 1, log = T)
	log_prior_A <- dnorm(param_const[['A']], mean = 10, sd = 1, log = T)
	log_prior_ph <- dnorm(param_const[['ph']], mean = 2, sd = 0.1, log = T)

    # return result
    return(log_prior_sigma_y + log_prior_A + log_prior_ph)
}

#Inference
inference <- function(name, dname_df){
    
    #Read data
    file <- paste(name,'.txt', sep='')
	file_str <- paste('Data/',file,sep='')
    df <- read.csv(file_str, header = T, sep = '\t')
    df = df[1:n,]
    
    #Inizialization of parameters
    df$init <- rep(1, length(df$t))
    'xi' = df[,c('t','init')]       #It could also be a randOU sequence..
    param_init <- list( 'xi' = xi ,'sigma_y' = 1, 'A'= 10, 'ph'= 2)
    
    #Define range of parameters
    param_range <- list('sigma_y' = c(0,1), 'A' = c(0,20), 'ph' = c(0,2*pi))
    
    param_range <- c(param_range)
    
    # choose model parameters:
    xi_mean <- 1
    xi_sd <- 0.01
    xi_gamma <- 1
    
    
    #Perform Timedapper inference
    inf <- NULL
    inf <- infer.timedeppar(loglikeli = loglikeli, 
                            param.ini = param_init,
                            param.range = param_range,
                            param.logprior = logprior_const,
                            param.ou.ini = c(xi_mean = xi_mean, xi_sd = xi_sd, xi_gamma = xi_gamma),
                            param.ou.logprior = logprior_ou,
                            n.iter = n_iter,
                            control = list(n.interval = n_interval, n.adapt = n_adapt),
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
    names(df_inf_xi) <- paste0(rep('xi.', n), as.character(seq(1, n)))
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
    
    #Ingferred cinstant parameters

    A_inf = infer_par(list("A"), df_inf)

    sigma_y_inf = infer_par(list("sigma_y"), df_inf)

    ph_inf = infer_par(list("ph"), df_inf)
	
	# xi parameters
    xi_inf = infer_par(names(df_inf_xi), df_inf)
    
    #xi mean
    xi_mean_inf=infer_par(list("xi_mean"),df_inf)
	
	#xi sd
    xi_sd_inf=infer_par(list("xi_sd"),df_inf)
	
	#xi gamma
    xi_gamma_inf=infer_par(list("xi_gamma"),df_inf)
	
	#sigma_y
    sigma_y_inf=infer_par(list("sigma_y"),df_inf)
	
	par_inf<- c(A_inf,ph_inf,xi_inf, xi_mean_inf,xi_sd_inf,xi_gamma_inf,sigma_y_inf)

	#Inferred times
    t_inf <- rep(1,500)

    t_inf[1]=xi_inf[1]

    for (i in 2:500)
        t_inf[i]=t_inf[i-1]+xi_inf[i]
    
    df$xi_inf <- xi_inf
    names(df$xi_inf)= 'xi_inf'
    
    df$t_inf <- t_inf
    names(df$t_inf)= 't_inf'
	
	#Estimates y denoised
	y_d = rep(0, n)

	y_d <- y_d + A_inf*cos(2*pi* freq_syn* t_inf + ph_inf)
		
	df$y_d <- y_d
    df$t_diff <- df$t - df$t_inf
	
	plot_inf(df)
    
    # Combine the results into a list
    return_list <- list(df = df, df_inf = df_inf, par_inf = par_inf)
	
	write.table(df, paste(dname_df,".txt"), sep='\t', row.names=FALSE, quote = FALSE)
    write.table(df_inf, paste(dname_df,"_inf.txt"), sep='\t', row.names=FALSE, quote = FALSE)
	write.table(par_inf, paste(dname_df,"_par.txt"), sep='\t', row.names=FALSE, quote = FALSE)
      
    return(return_list)
    
}

backup<-function(dname){

	#Read data
    file <- paste(dname,'.txt')
	file_inf <- paste(dname,'_inf.txt')
	
	
    df <- read.csv(file, header = T, sep = '\t')
    df = df[1:n,]
	
	df_inf <- read.csv(file_inf, header = T, sep = '\t')

	plot_inf(df)

	return_list <- list(df = df, df_inf = df_inf)
	return(return_list)
}