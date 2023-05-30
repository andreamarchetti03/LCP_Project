

# Plot functions

#Plot original data

plot_obs <- function(data){
    
    options(repr.plot.width = 15, repr.plot.height = 7)
	par(mar = c(5.1, 6.1, 4.1, 2.1))
    plot(data$t, data$y_obs, main = "Observed data", 
         xlab = "Time [y]", ylab =  expression(Be[meas]), 
         xlim = c(200, 9300), ylim = c(-0.8, 1.85),
         type = 'n', lty = 1, lwd = 2, col = col_blue,
         cex.main = 2, cex.lab = 1.5, cex.axis = 1.5)

    grid(nx = NULL, ny = NULL,
         lty = 2, col = col_grey, lwd = 1)
	lines(data$t, data$y_obs, type = "l", lty = 1, lwd = 4, col = col_blue)
    
    return()
}



# Plot inferred data on top of original observed data
plot_inf <- function(data){
    
    options(repr.plot.width = 15, repr.plot.height = 10)
    par(mar = c(5.1, 6.1, 4.1, 2.1))
    plot(data$t, data$y_obs, main = "Observed and Inferred times", 
         xlab = "t", ylab = expression(Be[meas]), 
         xlim = c(200, 9300), ylim = c(-0.8, 1.85),
         type = 'n', lty = 1, lwd = 2, col = col_blue,
         cex.main = 2, cex.lab = 1.3, cex.axis = 1.5)
	grid(nx = NULL, ny = NULL,
            lty = 2, col = col_grey, lwd = 1)		
	lines(data$t, data$y_obs, type = "l", lty = 1, lwd = 4, col = col_blue)

    lines(data$t_inf, data$y_obs,   
         type = 'l', lty = 1, lwd = 2, col = col_red,
         cex.main = 2, cex.lab = 1.3, cex.axis = 1.5)

		 
	plot((data$t), data$y_obs, main = "Denoised data", 
         xlab = "t", ylab = expression(y[obs]), 
         xlim = c(200, 9300), ylim = c(-0.8, 1.85),
         type = 'n', lty = 1, lwd = 2, col = col_blue,
         cex.main = 2, cex.lab = 1.3, cex.axis = 1.5)		 
	grid(nx = NULL, ny = NULL,
            lty = 2, col = col_grey, lwd = 2)
	lines(data$t, data$y_obs, type = "l", lty = 1, lwd = 4, col = col_blue)
    lines(df_hulk$t_inf, df_hulk$y_d,   
         type = 'l', lty = 1, lwd = 2, col = "black",
         cex.main = 2, cex.lab = 1.3, cex.axis = 1.5)
		 
	lines(((data$t)), data$y_or,   
         type = 'l', lty = 1, lwd = 3, col = col_green,
         cex.main = 2, cex.lab = 1.3, cex.axis = 1.5)
		 
	lines(data$t_inf, data$y_d,   
         type = 'l', lty = 1, lwd = 4, col = col_red,
         cex.main = 2, cex.lab = 1.3, cex.axis = 1.5)

      
    return()
}


#Plot time difference and xi_inf
plot_diff <- function(data){
    
   options(repr.plot.width = 15, repr.plot.height = 10)
   par(mar = c(5.1, 6.1, 4.1, 2.1))

    plot(data$t, data$t_diff, main = "Time difference", 
         xlab = "t", ylab = "Diff", 
         xlim = c(0, 9500),
         type = 'n', lty = 1, lwd = 2, col = col_blue,
         cex.main = 2, cex.lab = 1.3, cex.axis = 1.5)
	grid(nx = NULL, ny = NULL,
         lty = 2, col = col_grey, lwd = 1)
	lines(data$t, data$t_diff, type = "l", lty = 1, lwd = 4, col = col_blue)

    options(repr.plot.width = 15, repr.plot.height = 5)
    par(mar = c(5.1, 6.1, 4.1, 2.1))
    plot(data$t, data$xi_inf, main = expression(bold(symbol(x)[i] ~inferred)), 
         xlab = "t", ylab = expression(symbol(x)[i]), 
         xlim = c(0, 9500),type = "n" ,
          lty = 1, lwd = 4, col = col_blue,
         cex.main = 2, cex.lab = 1.3, cex.axis = 1.5)
	grid(nx = NULL, ny = NULL,
         lty = 2, col = col_grey, lwd = 1)
	lines(data$t, data$xi_inf, type = "l", lty = 1, lwd = 4, col = col_blue)
    
    return()
}

plot_chain<-function(par_inf){

	
	l <-length(par_inf)
	x_chain<-seq(1,l,1)
	x_chain <- x_chain * 50


	options(repr.plot.width = 15, repr.plot.height = 5)
	plot(x_chain,par_inf)
	
	grid(nx = NULL, ny = NULL,
         lty = 2, col = col_grey, lwd = 1)
	
	
}
plot_multi_chain<-function(par_inf){
    options(repr.plot.width = 15, repr.plot.height = 10)
    par(mar = c(5.1, 6.1, 4.1, 2.1))
    par(mfrow=c(3,3))
    name_par_inf=c("xi mean","xi_gamma", "xi_sd", "A.1", "ph.1", "freq.8")
	l <-length(par_inf$xi_mean)
    print(l)
	x_chain<-seq(1,l,1)
	x_chain <- x_chain * 50
	
	plot(x_chain,par_inf$xi_mean,main=paste0("chain of", " ", name_par_inf[[1]]),
         col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
    plot(x_chain,par_inf$xi_gamma,main=paste0("chain of", " ", name_par_inf[[2]]),
         col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
	plot(x_chain,par_inf$xi_sd,main=paste0("chain of", " ", name_par_inf[[3]]),
         col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
    plot(x_chain,par_inf$A.1,main=paste0("chain of", " ", name_par_inf[[4]]),
         col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
	plot(x_chain,par_inf$ph.1,main=paste0("chain of", " ", name_par_inf[[5]]),
         col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
    plot(x_chain,par_inf$freq.8,main=paste0("chain of", " ", name_par_inf[[6]]),
         col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
}


plot_hist<-function(par_inf){
    options(repr.plot.width = 15, repr.plot.height = 10)
    par(mar = c(5.1, 6.1, 4.1, 2.1))
    par(mfrow=c(3,3))
    name_par_inf=c("xi mean","xi_gamma", "xi_sd", "A.1", "ph.1", "freq.8")

    hist(par_inf$xi_mean,xlab=name_par_inf[[1]],ylab="counts",main=paste0("Histogram of ", name_par_inf[[1]]),
         col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
    
    hist(par_inf$xi_gamma,xlab=name_par_inf[[2]],ylab="counts",main=paste0("Histogram of ", name_par_inf[[2]]),
         col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
    
    hist(par_inf$xi_sd,xlab=name_par_inf[[3]],ylab="counts",main=paste0("Histogram of ", name_par_inf[[3]]),
         col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
    
    hist(par_inf$A.1,xlab=name_par_inf[[4]],ylab="counts",main=paste0("Histogram of ", name_par_inf[[4]]),
         col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
    
    hist(par_inf$ph.1,xlab=name_par_inf[[5]],ylab="counts",main=paste0("Histogram of ", name_par_inf[[5]]),
         col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
    
    hist(par_inf$freq.8,xlab=name_par_inf[[6]],ylab="counts",main=paste0("Histogram of ", name_par_inf[[6]]),
         col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
		 
	
}


plot_chain_acf <- function(data_inf){

	options(repr.plot.width = 15, repr.plot.height = 5)
    par(mar = c(5.1, 6.1, 4.1, 2.1))
    name_inf = c("xi_mean","xi_gamma", "xi_sd", "sigma_y", "A.1", "ph.1", "freq.8")

	l <-length(data_inf$xi_mean)
	x_chain<-seq(1,l,1) 
	x_chain <- x_chain * 50	
	
    for (i in 1:length(name_inf)){
		par(mfrow = c(1,2))
		plot(x_chain,data_inf[[name_inf[i]]],main=paste0("chain of", " ", name_inf[[i]]),
             col=col_blue, type = "n", lwd = 2, cex.lab = 1.3)
		grid(nx = NULL, ny = NULL,
            lty = 2, col = col_grey, lwd = 1)
		lines(x_chain,data_inf[[name_inf[i]]], type = "l", lty = 1, lwd = 4, col = col_blue)
        abline(h = median(data_inf[[name_inf[i]]]), col = col_green, lty = 2, lwd = 2)
		
		 
				
		# autocorrelation
		acf(data_inf[[name_inf[i]]], lag = length(data_inf[[name_inf[i]]]) - 1,
			main = 'Autocorrelation', xlab = 'lag', ylab = name_inf[[i]], col = col_blue, cex.lab = 1.3)
		grid(nx = NULL, ny = NULL,
            lty = 2, col = col_grey, lwd = 1) 
	}
}



plot_chain_all <- function(data_inf){

	options(repr.plot.width = 15, repr.plot.height = 5)
    par(mar = c(5.1, 6.1, 4.1, 2.1))
    name_inf = names(data_inf)

	l <-length(data_inf$xi_mean)
	x_chain<-seq(1,l,1) 
	x_chain <- x_chain * 50
	
    for (i in 1:24){
		par(mfrow = c(1,2))
		plot(x_chain,data_inf[[name_inf[i]]],main=paste0("Markov chain of", " ", name_inf[[i]]),
             col=col_blue, type = "n", lwd = 2, cex.lab = 1.3)
		grid(nx = NULL, ny = NULL,
            lty = 2, col = col_grey, lwd = 1)
		lines(x_chain,data_inf[[name_inf[i]]], type = "l", lty = 1, lwd = 4, col = col_blue)
        abline(h = median(data_inf[[name_inf[i]]]), col = col_green, lty = 2, lwd = 2)

				
		# autocorrelation
		acf(data_inf[[name_inf[i]]], lag = length(data_inf[[name_inf[i]]]) - 1,
<<<<<<< HEAD
			main = 'Autocorrelation', xlab = 'lag', ylab = name_inf[[i]], col = col_blue, cex.lab = 1.3)
			
		grid(nx = NULL, ny = NULL,
            lty = 2, col = col_grey, lwd = 1) 
	}	
=======
			main = 'Autocorrelation', xlab = 'lag', ylab = name_inf[[i]], col = col_blue)
	}
>>>>>>> 0ab1a3f9cd8d71e4e2df0099fe60880dff5b7dad
}


plot_freq<-function(data_inf){
    options(repr.plot.width = 15, repr.plot.height = 5)
    par(mar = c(5.1, 6.1, 4.1, 2.1))
    name_inf = c("freq.6","freq.7")

	l <-length(data_inf$xi_mean)
	x_chain<-seq(1,l,1) 
	x_chain <- x_chain * 50
	
    for (i in 1:2){
        
		par(mfrow = c(1,2))
		plot(x_chain,data_inf[[name_inf[i]]],main=paste0("Markov chain of", " ", name_inf[[i]]),
             col=col_blue, type = "n", lwd = 2, cex.lab = 1.3, ylab = "Inf freq [1/y]", xlab = "# Iterations")
		grid(nx = NULL, ny = NULL,
            lty = 2, col = col_grey, lwd = 1)
		lines(x_chain,data_inf[[name_inf[i]]], type = "l", lty = 1, lwd = 4, col = col_blue)
        abline(h = median(data_inf[[name_inf[i]]]), col = "orange", lty = 1, lwd = 3)
        abline(h = freq_hulk[11+i], col = col_green, lty = 2, lwd = 4, )
        abline(h = freq_i[i+5], col = "red", lty = 2, lwd = 3)
		 
		
	    legend(x = 'bottomleft',
			col = c(col_blue, "orange",col_green,"red"),
			lty = c(1,1,2,2),
			lwd = c(2,3,4,3),
			cex=1.2,
			xpd = TRUE,  # Enable plotting outside the plot region
            inset = c(0, 0.05),  # Adjust the legend position using inset coordinates
			bty="n",
			legend = c('Markov chain ', 'Mean value ', 'Correct freq.', "Initial freq."))
        
				
		# autocorrelation
		acf(data_inf[[name_inf[i]]], lag = length(data_inf[[name_inf[i]]]) - 1,
			main = 'Autocorrelation', xlab = 'lag', ylab = 'acf value', col = col_blue, cex.lab = 1.3)
		grid(nx = NULL, ny = NULL,
            lty = 2, col = col_grey, lwd = 1) 
        
       
	}
}

