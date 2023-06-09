# define the program code for stan
code = """
data {

    int<lower=1> n;
    vector[n] y_obs;
    
    real<lower=0> dt;
    
    real<lower=0> freq;
}

parameters {

    ordered[n] t;

    real<lower=0> mean;
    real<lower=0> sd;
    real<lower=0, upper=200> tau;

    real<lower=0	> sigma_y;

    real<lower=0> A;
    real phi;
    
}


model {
/*
    mean ~ normal(1, 0.15);
    sd ~ uniform(0, 0.4);
    tau ~ uniform(2, 200);
    sigma_y ~ uniform(0, 10);
    
    A ~ normal(10, 2);
    phi ~ normal(2, 1);
*/  

    mean ~ normal(1, 0.1);
    sd ~ gamma(1, 0.01); //normal(0.1, 0.05);
    tau ~ uniform(0, 200);
    sigma_y ~ gamma(1, 1);
    
    A ~ normal(10, 2);
    phi ~ normal(2, 1);
    
   
    t[1] ~ normal(1, 0.00001);
    t[2] ~ normal(t[1] + mean, sd);

    for (i in 1:n-2) {

      t[i+2] ~ normal(mean*(dt/tau) + (2 - dt/tau) * t[i+1] - (1 - dt/tau) * t[i], sd*sqrt(2*dt/tau));
    }

    vector[n] mean_y;

    for(i in 1:n) {
    
        mean_y[i] = A*cos(2*pi()*freq * t[i] + phi);
        
        y_obs[i] ~ normal(mean_y[i], sigma_y);
    }

}
"""
