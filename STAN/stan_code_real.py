# define the program code for stan
code = """
data {

    int<lower=1> n;
    vector[n] y_obs;
    int<lower=1> N_waves; //number of frequencies
    
    real<lower=0> dt;
    
    vector[N_waves] freq; //vector of frequencies
}

parameters {

    ordered[n] t;

    real<lower=0> mean;
    real<lower=0, upper=10> sd;
    real<lower=0, upper=200> tau;

    real<lower=0, upper=10> sigma_y;

    vector[N_waves] A; //vector of amplitudes
    vector[N_waves] phi; //vector of phases
    //add constraints if uniforms
    
}


model {
    // try with normal
    mean ~ normal(1,0.1);
    sd ~ uniform(0, 10);
    tau ~ uniform(1, 200);
    sigma_y ~ uniform(0, 10);
    
    //add priors for A and phi (one for each component)
   
    t[1] ~ normal(1, 0.01);
    t[2] ~ normal(t[1] + mean, sd);

    for (i in 1:n-2) {

      t[i+2] ~ normal(mean*(dt/tau) + (2 - dt/tau) * t[i+1] - (1 - dt/tau) * t[i], sd*sqrt(2*dt/tau));
    }

    vector[n] mean_y;

    for(i in 1:n) {
    
        for (j in 1:N_waves) {

            mean_y[i] = A[j]*cos(2*pi()*freq[j] * t[i] + phi[j]);
        }

        y_obs[i] ~ normal(mean_y[i], sigma_y);
    }

}
"""
