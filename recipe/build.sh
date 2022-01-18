#!/bin/bash
set -e

cmake --install-prefix=$CONDA_PREFIX -S . -B build
cmake --build build
cmake --install build
