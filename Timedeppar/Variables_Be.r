
#Variables

# set colors 
col_red <- '#E21B1B'   #red
col_blue <- '#1769E6'  #blue
col_green <- '#00D10A' #green
col_grey <- '#C8CED0'  #gray

n_main <- 1849

# read cycle parameters
df_cycle <- read.csv('LCP_Project/Timedeppar/Data/Be_cycles.txt', header = T, sep = '\t')
corr_cycle <- read.csv('LCP_Project/Timedeppar/Data/corr_cycle.txt', header = T, sep = '\t')


df_corr<-read.csv('LCP_Project/Timedeppar/Data/Becorr.txt', header = T, sep = '\t')
df_corr$y_corr <- df_corr$y_corr-mean(df_corr$y_corr)


#Estimate denoised corrected data
y_corr_d = rep(0, 1802)
for(i in 1:13){
	y_corr_d <- y_corr_d + corr_cycle$A[i]*cos(2*pi*corr_cycle$freq[i]*df_corr$t_inf + corr_cycle$ph[i])
}
df_corr$y_corr_d <- y_corr_d	

n_cycle <- length(df_cycle$freq)
df_cycle = df_cycle[1:n_cycle,]
n_fix <- 6

#frequencies
freq_i <- df_cycle$freq
freq_corr <- corr_cycle$freq



# timedeppar settings 




n_iter <- 400000
n_interval <- 20
n_adapt <- 200000
n_adapt_cov <- 500


