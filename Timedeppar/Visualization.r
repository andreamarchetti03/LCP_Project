

# Plot functions


#Plot original data

plot_obs <- function(data){
    
    options(repr.plot.width = 15, repr.plot.height = 5)

    plot(data$t, data$y_obs, main = "Observed data: Series 1", 
         xlab = "t", ylab = "y_obs", 
         xlim = c(0, n), ylim = c(-12, 12),
         type = 'l', lty = 1, lwd = 2, col = col_blue,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)

    grid(nx = NULL, ny = NULL,
            lty = 2, col = col_grey, lwd = 2)
    
    return()
}



# Plot inferred data on top of original observed data
plot_inf <- function(data){
    
    options(repr.plot.width = 15, repr.plot.height = 5)

    plot(df$t, df$y_obs, main = "Observed and Inferred data", 
         xlab = "t", ylab = "y_obs", 
         xlim = c(0, 500), ylim = c(-12, 12),
         type = 'l', lty = 1, lwd = 2, col = col_blue,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)

    lines(df$t_inf, df$y_obs,   
         type = 'l', lty = 1, lwd = 2, col = col_red,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)

    grid(nx = NULL, ny = NULL,
            lty = 2, col = col_grey, lwd = 2)
    
    return()
}


#Plot time difference and xi_inf
plot_diff <- function(data){
    
   options(repr.plot.width = 15, repr.plot.height = 5)

    plot(df$t, df$t_diff, main = "Time difference", 
         xlab = "t", ylab = "Diff", 
         xlim = c(0, 500),
         type = 'o', lty = 1, lwd = 2, col = col_blue,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)

    options(repr.plot.width = 15, repr.plot.height = 5)

    plot(df$t, df$xi_inf, main = "Xi_inf", 
         xlab = "t", ylab = "Xi", 
         xlim = c(0, 500),
         type = 'o', lty = 1, lwd = 2, col = col_blue,
         cex.main = 2, cex.lab = 1.7, cex.axis = 1.5)  
    
    return()
}