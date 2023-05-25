
#Variables

# set colors 
col_red <- '#E21B1B'   #red
col_blue <- '#1769E6'  #blue
col_green <- '#00D10A' #green
col_grey <- '#C8CED0'  #gray

n_main <- 1849

# read cycle parameters
df_cycle <- read.csv('LCP_Project/Timedeppar/Data/Be_cycles.txt', header = T, sep = '\t')
df_hulk<-read.csv('LCP_Project/Timedeppar/Data/Becorr.txt', header = T, sep = '\t')
df_hulk$y_d<-df_hulk$y_d-mean(df_hulk$y_d)
df_hulk$t_inf <-df_hulk$t_inf - (df_hulk$t_inf[1] - 2)


# read cycle parameters
#df_hulk <- read.csv('Data/Be_corr.txt', header = T, sep = '\t')


n_cycle <- length(df_cycle$freq)
df_cycle = df_cycle[1:n_cycle,]
n_fix <- 6

#frequencies
freq_i <- df_cycle$freq



# timedeppar settings 




n_iter <- 400000
n_interval <- 20
n_adapt <- 200000
n_adapt_cov <- 1000


