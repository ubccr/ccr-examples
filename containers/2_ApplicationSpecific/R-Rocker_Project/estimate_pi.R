#
# Estimating Pi Using Monte Carlo Simulation in R
# by Andrea Gustafsen
#
# https://rpubs.com/andrea_gustafsen/839901
#
estimate_pi <- function(seed = 28, iterations = 1000){
    # set seed for reproducibility
    set.seed(seed)
    
    # generate the (x, y) points
    x <- runif(n = iterations, min = 0, max = 1)
    y <- runif(n = iterations, min = 0, max = 1)
    
    # calculate 
    sum_sq_xy <- sqrt(x^2 + y^2) 
    
    # see how many points are within circle
    index_within_circle <- which(sum_sq_xy <= 1)
    points_within_circle = length(index_within_circle)
    
    # estimate pi
    pi_est <- 4 * points_within_circle / iterations
    return(pi_est)
}
no_of_iterations <- c(10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000)
res <- sapply(no_of_iterations, function(n)estimate_pi(iterations = n))
names(res) <- no_of_iterations
res

