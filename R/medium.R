library(volesti)
library(ggplot2)

# Sample a point uniformly distributed on
# the unit (d-1)-dimensional sphere.
get_direction <- function (d) {
    p <- rnorm(d)
    p / norm(p, type="2")
}

# Sample a point uniformly distributed on
# the unit d-dimensional ball.
uniform_ball <- function(d, delta) {
    r <- delta*runif(1)
    r*get_direction(d)
}

# Ball walk for a log-concave distribution given a strongly
# convex function. polytope needs to be an Hpolytope.
ball_walk <- function (f, polytope, start, delta = 0.01, steps = 100) {
    # Initial point
    x <- start

    # Uniform samples from [0,1] used to jump to next point
    # with a certain probability.
    epsilon <- runif(steps)
    
    for (i in 2:steps) {
        # Uniformly sample a point from the ball
        # of radius delta around x.
        y <- x + uniform_ball(length(x), delta)

        # Quotient of densities of induced
        # log-concave distribution.
        p <- exp(f(x) - f(y))

        y_in_poly <- polytope$A %*% y <= polytope$b
        if (epsilon[i] < p && y_in_poly) {
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

n_samples = 1000

samples <- array(1:2*n_samples, c(n_samples,2))

# Sample points using ball walk and plot them
for (i in 1:n_samples) {
    samples[i,] <- ball_walk(oracle, polytope, c(0, 0), steps = 200)
}

samples <- data.frame(samples)
ggplot(samples, aes(x = X1, y = X2)) + stat_density2d(aes(fill = ..density..), contour = F, geom = 'tile')
