
#Variables

# set colors 
col_red <- '#E21B1B'   #red
col_blue <- '#1769E6'  #blue
col_green <- '#00D10A' #green
col_grey <- '#C8CED0'  #gray

freq <- 1/11
dt <- 1

n <- 500
n_main <- 4149
n_cycle <- 20
n_fix <- 7


# read cycle parameters
df_cycle <- read.csv('Data/Insu_cycles.txt', header = T, sep = '\t')
df_cycle = df_cycle[1:n_cycle,]

n_cycle <- length(df_cycle$Period)

#frequencies
freq_c <- 1/df_cycle$Period



# timedeppar settings 
n_iter <- 10000
n_interval <- 50
n_adapt <- 2000


