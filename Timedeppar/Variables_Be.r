
#Variables

# set colors 
col_red <- '#E21B1B'   #red
col_blue <- '#1769E6'  #blue
col_green <- '#00D10A' #green
col_grey <- '#C8CED0'  #gray

n_main <- 1849

# read cycle parameters
df_cycle <- read.csv('Data/Be_cycles.txt', header = T, sep = '\t')


n_cycle <- length(df_cycle$freq)
df_cycle = df_cycle[1:n_cycle,]
n_fix <- 6

#frequencies
freq_i <- df_cycle$freq



# timedeppar settings 
<<<<<<< Updated upstream
n_iter <- 200000
n_interval <- 20
n_adapt <- floor(0.2*n_iter)
n_adapt_cov <- 500

=======
n_iter <- 100000
n_interval <- 450
n_adapt <- 20000
n_adapt_cov <- 0
>>>>>>> Stashed changes
