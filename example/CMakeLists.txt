cmake_minimum_required(VERSION 3.31)
project(example CXX)
add_executable(example main.cpp)
target_compile_features(example PRIVATE cxx_std_23)
