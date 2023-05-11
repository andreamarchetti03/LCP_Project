

#Variables

# set colors 
col_red <- '#E21B1B'   #red
col_blue <- '#1769E6'  #blue
col_green <- '#00D10A' #green
col_grey <- '#C8CED0'  #gray

n_main <- 4149

# read cycle parameters
df_cycle <- read.csv('Data/Insu_cycles_final.txt', header = T, sep = '\t')


n_cycle <- length(df_cycle$freq)
df_cycle = df_cycle[1:n_cycle,]
n_fix <- 7

#frequencies
freq <- df_cycle$freq



# timedeppar settings 
n_iter <- 10000
n_interval <- 50
n_adapt <- 2000