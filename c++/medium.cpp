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
#include <chrono>
#include <boost/random.hpp>
#include <boost/random/uniform_int.hpp>
#include <boost/random/normal_distribution.hpp>
#include <boost/random/uniform_real_distribution.hpp>
#include "hpolytope.h"
#include "samplers.h"

typedef point<Cartesian<double>> Point;


/* Ball walk for log-concave target distribution given by f.
 * 
 */
template<class F, class Polytope>
Point ball_walk(F f, const Polytope& poly, double delta, const Point& start, size_t steps = 100) {
  // Random number generation
  std::random_device rd;
  std::mt19937 gen(rd());
  std::uniform_real_distribution<double> dis(0, 1);
  
  Point x = start;
  for(size_t i = 0; i < steps; i++) {
    Point y = get_point_in_Dsphere<std::mt19937, Point>(x.dimension(), delta) + x;

    double prob = std::exp(f(x) - f(y));
    if(dis(gen) < prob && poly.is_in(y) == -1) {
      x = y;
    }
  }

  return x;
}

/* Strongly convex oracle for a gaussian
 * with mean 0 and variance 0.1*I.
 */
double variance = 0.1;
double oracle(const Point& x) {
  return (1/2.0)*(x[0]*x[0] + x[1]*x[1])/variance;
}



size_t n_samples = 1000;
int main() {
  // 2-dimensional unit cube
  HPolytope<Point> poly(2);

  std::vector<Point> samples(n_samples);
  for(size_t i = 0; i < n_samples; i++) {
    samples[i] = ball_walk(oracle, poly, 0.01, Point(2), 200);
  }

  // Print samples for plotting
  for(auto& s : samples) {
    std::cout << s[0] << " " << s[1] << std::endl;
  }
}
