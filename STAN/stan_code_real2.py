# define the program code for stan
code = """
data {

    int<lower=1> n;
    vector[n] y_obs;
    int<lower=1> N_fix; //number of fixed frequencies
    int<lower=1> N_inf; //number of frequencies to infer
    
    real<lower=0> dt;
    
    vector[N_fix] freq_fix; //vector of fixed frequencies

    //total number of waves: sum of fixed and inferred
    //can not declare?
    int<lower=0> N_waves;

    //initial values of frequencies, amplitudes and phases
    //used for prior initialization
    vector[N_inf] freq_init;
    vector[N_waves] A_init; 
    vector[N_waves] phi_init;

    //errors for frequencies, amplitudes and phases
    //used for prior initialization
    vector[N_inf] err_freq_init;
    vector[N_waves] err_A_init;
    vector[N_waves] err_phi_init;

}

parameters {

    ordered[n] t;

    real<lower=0> mean;
    real<lower=0, upper=10> sd;
    real<lower=0, upper=200> tau;

    real<lower=0, upper=10> sigma_y;

    vector<lower=0>[N_inf] freq_inf; //vector of frequencies to infer
    vector<lower=0>[N_waves] A; //vector of amplitudes
    vector<lower=0, upper=2*pi()>[N_waves] phi; //vector of phases
    
}


model {

    // try with normal
    mean ~ normal(10,0.5);
    sd ~ uniform(0, 10);
    tau ~ uniform(1, 200);
    sigma_y ~ uniform(0, 10);
    
    //add priors for freq to infer
    for (j in 1:N_inf) {
        freq_inf[j] ~ normal(freq_init[j], err_freq_init[j]);
    }
    

    //add priors for A and phi (one for each component)
    for (j in 1:N_waves) {
        A[j] ~ normal(A_init[j], err_A_init[j]);
        phi[j] ~ normal(phi_init[j], err_phi_init[j]);
    }
    
    //print("log density before =", target());

   
    t[1] ~ normal(10, 1);
    t[2] ~ normal(t[1] + mean, sd);

    for (i in 1:n-2) {

      t[i+2] ~ normal(mean*(dt/tau) + (2 - dt/tau) * t[i+1] - (1 - dt/tau) * t[i], sd*sqrt(2*dt/tau));
    }

    //define a new freq vector with all the frequencies
    vector[N_waves] freq;

    //append the value of the two freq vectors
    for (i in 1:N_fix) {
        freq[i] = freq_fix[i];
    }
    for (i in 1:N_inf) {
        freq[N_fix + i] = freq_inf[i];
    }

    vector[n] mean_y;

    //initialize the mean_y values to zero
    for (i in 1:n) mean_y[i] = 0;

    for(i in 1:n) {
    
        for (j in 1:N_waves) {

            mean_y[i] += A[j]*cos(2*pi()*freq[j] * t[i] + phi[j]);
        }

        y_obs[i] ~ normal(mean_y[i], sigma_y);
    }

}
"""