library(volesti)
library(ggplot2)

ball_walk <- function (f, polytope, steps = 100) {
    points <- sample_points(polytope, steps, 'uniform', walk_step = 200)

    # Initial point
    x <- points[,1]

    # Samples used for filter
    epsilon <- runif(steps)
    
    for (i in 2:steps) {
        y <- points[,i]

        # Quotient of densities of induced
        # log-concave distribution
        p <- exp(f(x) - f(y))
        
        if (p >= 1) {
            x <- y
            next
        }

        if (epsilon[i] < p) {
            x <- y
        }
    }

    x
}

# This should give rise to a 2-dimensional normal
variance = 0.1
oracle <- function(x) {
     (1/2)*(x[1]^2 + x[2]^2)/variance
}

polytope <- GenCube(2, 'H')

n_samples = 10000

# I'm sure there's a more elegant way to do this
samples <- array(1:2*n_samples, c(n_samples,2))

for (i in 1:n_samples) {
    samples[i,] <- ball_walk(oracle, polytope, steps = 200)
}

samples <- data.frame(samples)
ggplot(samples, aes(x = X1, y = X2)) + stat_density2d(aes(fill = ..density..), contour = F, geom = 'tile')
