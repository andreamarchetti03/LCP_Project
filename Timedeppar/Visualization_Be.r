

# Plot functions


#Plot original data

plot_obs <- function(data){
    
    options(repr.plot.width = 15, repr.plot.height = 5)

    plot(data$t, data$y_obs, main = "Observed data: Series 1", 
         xlab = "t", ylab =  expression(y[obs]), 
         xlim = c(0, 9500), ylim = c(-12, 12),
         type = 'l', lty = 1, lwd = 2, col = col_blue,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)

    grid(nx = NULL, ny = NULL,
            lty = 2, col = col_grey, lwd = 2)
    
    return()
}



# Plot inferred data on top of original observed data
plot_inf <- function(data){
    
    options(repr.plot.width = 15, repr.plot.height = 10)
    par(mar = c(5.1, 6.1, 4.1, 2.1))
    plot(data$t, data$y_obs, main = "Observed and Inferred times", 
         xlab = "t", ylab = expression(y[obs]), 
         xlim = c(0, 9500), ylim = c(-2, 2),
         type = 'l', lty = 1, lwd = 2, col = col_blue,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)

    lines(data$t_inf, data$y_obs,   
         type = 'l', lty = 1, lwd = 2, col = col_red,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
		 
	plot(data$t, data$y_obs, main = "Denoised data", 
         xlab = "t", ylab = expression(y[obs]), 
         xlim = c(0, 9500), ylim = c(-2, 2),
         type = 'l', lty = 1, lwd = 2, col = col_blue,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
		 
	lines(data$t_inf, data$y_d,   
         type = 'l', lty = 1, lwd = 4, col = col_red,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)

    grid(nx = NULL, ny = NULL,
            lty = 2, col = col_grey, lwd = 2)
    
    return()
}


#Plot time difference and xi_inf
plot_diff <- function(data){
    
   options(repr.plot.width = 15, repr.plot.height = 10)
   par(mar = c(5.1, 6.1, 4.1, 2.1))

    plot(data$t, data$t_diff, main = "Time difference", 
         xlab = "t", ylab = "Diff", 
         xlim = c(0, 9500),
         type = 'o', lty = 1, lwd = 2, col = col_blue,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)


    options(repr.plot.width = 15, repr.plot.height = 5)
    par(mar = c(5.1, 6.1, 4.1, 2.1))
    plot(data$t, data$xi_inf, main = expression(bold(symbol(x)[i] ~inferred)), 
         xlab = "t", ylab = expression(symbol(x)[i]), 
         xlim = c(0, 9500),type = "l" ,
          lty = 1, lwd = 4, col = col_blue,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)  
    
    return()
}

plot_chain<-function(par_inf){

	
	l <-length(par_inf)
	x_chain<-seq(1,l,1)


	options(repr.plot.width = 15, repr.plot.height = 5)
	plot(x_chain,par_inf)
	
	
}

plot_inst<-function(par_inf,name_par_inf){
    options(repr.plot.width = 15, repr.plot.height = 10)
    par(mar = c(5.1, 6.1, 4.1, 2.1))

    hist(par_inf,xlab=name_par_inf,ylab_="counts",main=paste0("Histogram of", " ", name_par_inf),col=col_blue,cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)
    
    
    }
#Commento