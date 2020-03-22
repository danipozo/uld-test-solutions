#include <iostream>
#include <random>
#include <cmath>
#include <algorithm>
#include <vector>


/* Includes needed to use VolEsti primitives.
 */
// Eigen
#include "Core"
#include "cartesian_geom/cartesian_kernel.h"

typedef point<Cartesian<double>> Point;

/* Difference between two points.
 *
 * This is a quick fix needed because not all variants
 * of the operator- that are needed are implemented in point.
 */
Point diff(Point x, Point y) {
  Point ret(x.dimension());
  for(size_t i = 0; i < x.dimension(); i++) {
    ret.set_coord(i, x[i] - y[i]);
  }

  return ret;
}

/* Gradient descent with Barzilai-Borwein step.
 */
template<class F>
Point barzilai_borwein(F grad_f, Point initial_point, double initial_step = 0.01, size_t max_steps = 100) {
  
  // Initialize variables, performing the initial
  // step of gradient descent
  Point gradient_last = grad_f(initial_point);
  Point point_last = initial_point;
  Point point = diff(initial_point, initial_step*gradient_last);
  Point gradient = grad_f(point);

  Point s_last = point - point_last;
  Point y_last = gradient - gradient_last;

  Point zero(gradient.dimension());
  for(size_t i = 0; i < max_steps; i++) {
    if(gradient == zero) {
      break;
    }

    // Barzilai-Borwein step
    double bb_step = s_last.dot(s_last) / y_last.dot(s_last);

    // Update variables
    point_last = point;
    gradient_last = gradient;

    point = diff(point, bb_step*gradient);
    gradient = grad_f(point);

    s_last = point - point_last;
    y_last = gradient - gradient_last;
  }

  return point;
}

// Gradient of example function to minimize
Point oracle(const Point& x) {
  Point ret(2);

  ret.set_coord(0, 2*(x[0]*exp(x[1]) - 2*x[1]*exp(-x[0]))*(exp(x[1]) + 2*x[1]*exp(x[0])));
  ret.set_coord(1, 2*(x[0]*exp(x[1]) -2*x[1]*exp(-x[0]))*(x[0]*x[1]*exp(x[1]) - 2*exp(-x[0])));

  return ret;
}

// Example function to minimize
double f(const Point& x) {
  return std::pow(x[0]*exp(x[1]) - 2*x[1]*exp(-x[0]), 2);
}

int main() {
  Point initial(2);
  initial.set_coord(0, 3.1416);
  initial.set_coord(1, 3.1416);
  Point minimum = barzilai_borwein(oracle, initial);

  std::cout << "Minimum: " << minimum[0] << ", " << minimum[1] << std::endl;
  std::cout << "Value:   " << f(minimum) << std::endl;
}
