

# Plot functions


#Plot original data

plot_obs <- function(data){
    
    options(repr.plot.width = 15, repr.plot.height = 5)

    plot(data$t, data$y_obs, main = "Observed data: Series 1", 
         xlab = "t", ylab =  expression(y[obs]), 
         xlim = c(0, n), ylim = c(-12, 12),
         type = 'n', lty = 1, lwd = 2, col = col_blue,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
    grid(nx = NULL, ny = NULL,
         lty = 2, col = col_grey, lwd = 2)
	lines(data$t, data$y_obs, type = "l", lty = 1, lwd = 4, col = col_blue)
    
    return()
}


# Plot inferred data on top of original observed data
plot_inf <- function(data){
    
    options(repr.plot.width = 15, repr.plot.height = 5)
    par(mar = c(5.1, 6.1, 4.1, 2.1))
    plot(data$t, data$y_obs, main = "Observed and Inferred times", 
         xlab = "t", ylab = expression(y[obs]), 
         xlim = c(0, 500), ylim = c(-12, 12),
         type = 'n', lty = 1, lwd = 2, col = col_blue,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
	grid(nx = NULL, ny = NULL,
         lty = 2, col = col_grey, lwd = 1)
	lines(data$t, data$y_obs, type = "l", lty = 1, lwd = 4, col = col_blue)	
    lines(data$t_inf, data$y_obs,   
         type = 'l', lty = 1, lwd = 2, col = col_red,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
	
		 
	plot(data$t, data$y_obs, main = "Denoised data", 
         xlab = "t", ylab = expression(y[obs]), 
         xlim = c(0, 500), ylim = c(-12, 12),
         type = 'n', lty = 1, lwd = 2, col = col_blue,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
	grid(nx = NULL, ny = NULL,
         lty = 2, col = col_grey, lwd = 1)
	lines(data$t, data$y_obs, type = "l", lty = 1, lwd = 4, col = col_blue)	 
	lines(data$t_inf, data$y_d,   
         type = 'l', lty = 1, lwd = 4, col = col_red,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
 
    return()
}


#Plot time difference and xi_inf
plot_diff <- function(data){
    
    options(repr.plot.width = 15, repr.plot.height = 5)
    par(mar = c(5.1, 6.1, 4.1, 2.1))

    plot(data$t, data$t_diff, main = "Time difference", 
         xlab = "t", ylab = "Diff", 
         xlim = c(0, 500),
         type = 'n', lty = 1, lwd = 2, col = col_blue,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
	grid(nx = NULL, ny = NULL,
         lty = 2, col = col_grey, lwd = 1)
	lines(data$t, data$t_diff, type = "l", lty = 1, lwd = 4, col = col_blue)


    options(repr.plot.width = 15, repr.plot.height = 5)
    par(mar = c(5.1, 6.1, 4.1, 2.1))
    plot(data$t, data$xi_inf, main = expression(bold(symbol(x)[i] ~inferred)), 
         xlab = "t", ylab = expression(symbol(x)[i]), 
         xlim = c(0, 500),type = "l" ,
          lty = 1, lwd = 4, col = col_blue,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)  
	grid(nx = NULL, ny = NULL,
         lty = 2, col = col_grey, lwd = 1)
	lines(data$t, data$xi_inf, type = "l", lty = 1, lwd = 4, col = col_blue)
    
    return()
}

plot_chain<-function(par_inf){

	l <-length(par_inf)
	x_chain<-seq(1,l,1)
	x_chain <- x_chain * 10
	
    par(mar = c(5.1, 6.1, 4.1, 2.1))
	options(repr.plot.width = 21, repr.plot.height = 5)
	plot(x_chain,par_inf,xlab = "Chain", ylab = "par", main = "Markov Chain" ,
         xlim = c(0, 850), pch=19,
          col = col_blue,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5, type = "n")	
	grid(nx = NULL, ny = NULL,
         lty = 2, col = col_grey, lwd = 1)
	lines(x_chain,par_inf, type = "l", lty = 1, lwd = 4, col = col_blue)
}

plot_hist<-function(par_inf){
    options(repr.plot.width = 15, repr.plot.height = 10)
    par(mar = c(5.1, 6.1, 4.1, 2.1))
    par(mfrow=c(3,3))
    name_par_inf=c("xi mean","xi_gamma", "xi_sd", "A", "ph", "sigma_y")
	
    x <- seq(0.5, 1.5, by = 0.001)
    y <- dnorm(x, mean = 1, sd = 0.1)
	hist(par_inf$xi_mean,xlab=name_par_inf[[1]],ylab="counts",main=paste0("Histogram of ", name_par_inf[[1]]),
         col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
    lines(x,y,lwd=3,col=col_green)
    
    
    
     x <- seq(-0.1,0.3, by = 0.001)
     y <- dnorm(x, mean = 0.1, sd = 0.05)
    hist(par_inf$xi_gamma,xlab=name_par_inf[[2]],ylab="counts",main=paste0("Histogram of ", name_par_inf[[2]]),
         col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
    lines(x,y,lwd=3,col=col_green)
    
    x <- seq(0,0.05, by = 0.001)
    y <- dunif(x, min =0, max = 1)
    hist(par_inf$xi_sd,xlab=name_par_inf[[3]],ylab="counts",main=paste0("Histogram of ", name_par_inf[[3]]),
         col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
    lines(x,y,lwd=3,col=col_green)
    
    
    x <- seq(7,13, by = 0.001)
    y <- dnorm(x, 10, 1)
    hist(par_inf$A,xlab=name_par_inf[[4]],ylab="counts",main=paste0("Histogram of ", name_par_inf[[4]]),
         col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
    lines(x,y,lwd=3,col=col_green)
    
    x <- seq(1.5,2.5, by = 0.001)
    y <- dnorm(x, 2, 0.1)
    hist(par_inf$ph,xlab=name_par_inf[[5]],ylab="counts",main=paste0("Histogram of ", name_par_inf[[5]]),
         col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
    lines(x,y,lwd=3,col=col_green)
    
    
    hist(par_inf$sigma_y,xlab=name_par_inf[[6]],ylab="counts",main=paste0("Histogram of ", name_par_inf[[6]]),
         col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
}


plot_chain_acf <- function(data_inf){

	options(repr.plot.width = 15, repr.plot.height = 5)
    par(mar = c(5.1, 6.1, 4.1, 2.1))
    name_inf = c("xi_mean","xi_gamma", "xi_sd", "sigma_y", "A", "ph")

	l <-length(data_inf$xi_mean)
	x_chain <- seq(1,l,1) 
	x_chain <- x_chain * 10	
	
    for (i in 1:length(name_inf)){
		par(mfrow = c(1,2))
		plot(x_chain,data_inf[[name_inf[i]]],main=paste0("Markov chain of", " ", name_inf[[i]]),
             col=col_blue, type = "n", lwd = 2)
		grid(nx = NULL, ny = NULL,
			 lty = 2, col = col_grey, lwd = 1)
		lines(x_chain,data_inf[[name_inf[i]]], type = "l", lty = 1, lwd = 4, col = col_blue)
        abline(h = median(data_inf[[name_inf[i]]]), col = col_green, lty = 2, lwd = 2)
		
				
		# autocorrelation
		acf(data_inf[[name_inf[i]]], lag = length(data_inf[[name_inf[i]]]) - 1,
			main = 'Autocorrelation', xlab = 'lag', ylab = 'acf value', col = col_blue)
		grid(nx = NULL, ny = NULL,
             lty = 2, col = col_grey, lwd = 1)
	}
}