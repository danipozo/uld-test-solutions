INCLUDE=-Ivolesti/external/boost -Ivolesti/external/Eigen -Ivolesti/external/LPsolve_src/run_headers -Ivolesti/external/minimum_ellipsoid -Ivolesti/include -Ivolesti/include/volume -Ivolesti/include/generators -Ivolesti/include/samplers -Ivolesti/include/annealing -Ivolesti/include/convex_bodies -Ivolesti/include/lp_oracles -Ivolesti/include/misc

CXXFLAGS=$(INCLUDE) -std=c++11 -O3

TARGETS=medium hard

medium: c++/medium.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

hard: c++/hard.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
