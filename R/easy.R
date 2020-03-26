library(volesti)
library(ggplot2)

# Create the 100-dimensional unit cube
polytope <- GenCube(100, 'H')

# Sample points uniformly from the cube using different random walks and walk lengths
label <- function(x) {
    c('CDHR', 'RDHR', 'Ball walk')[x+1]
}

for (step in c(1, 10, 100, 200, 400, 800)) {
    cdhr_walk <- t(sample_points(polytope, 100, 'uniform', 'CDHR', walk_step = step))
    rdhr_walk <- t(sample_points(polytope, 100, 'uniform', 'RDHR', walk_step = step))
    ball_walk <- t(sample_points(polytope, 100, 'uniform', 'BW', walk_step = step))
    
    # Project points onto the plane and bind points together for plotting
    walks <- data.frame(rbind(cbind(cdhr_walk[,1:2], 0),
                              cbind(rdhr_walk[,1:2], 1),
                              cbind(ball_walk[,1:2], 2)))
    walks <- data.frame(transform(walks, X3 = label(X3)))
    
    # Plot the projections
    p <- ggplot(walks, aes(X1, X2, colour=X3)) + geom_point() +
        scale_colour_manual("Random walks", values = c("blue", "red", "green")) +
        ggtitle("Walk length:", step)
    print(p)
}
