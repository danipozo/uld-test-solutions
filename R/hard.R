barzilai_borwein <- function(grad_f, initial_point, initial_step = 0.01, max_steps = 100) {
    # First step: standard gradient descent
    gradient_last = grad_f(initial_point)
    point_last = initial_point
    point = initial_point - initial_step*gradient_last
    gradient = grad_f(point)

    s_last = point - point_last
    y_last = gradient - gradient_last

    for(i in 1:max_steps) {
        if(all(gradient == 0)) {
            break
        }
        
        # Barzilai-Borwen step
        bb_step = (s_last %*% s_last) / (y_last %*% s_last)

        point_last = point
        gradient_last = gradient

        point = point - c(bb_step)*gradient
        gradient = grad_f(point)

        s_last = point - point_last
        y_last = gradient - gradient_last
    }

    point
}

# Minimize an example function
oracle <- function(x) {
    c(2*(x[1]*exp(x[2]) - 2*x[2]*exp(-x[1]))*(exp(x[2]) + 2*x[2]*exp(x[1])),
      2*(x[1]*exp(x[2]) -2*x[2]*exp(-x[1]))*(x[1]*x[2]*exp(x[2]) - 2*exp(-x[1])))
}

f <- function(x) {
    (x[1]*exp(x[2]) - 2*x[2]*exp(-x[1]))^2
}

minimum <- barzilai_borwein(oracle, c(pi, pi))
print(minimum)
print(f(minimum))
