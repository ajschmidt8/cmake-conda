# Fireside

## First Section

- "Hello, world" in CMake
- Explore building with `make` and `cmake` commands

### Commands

- `cmake -S . -B build`
- `cmake --build build`

## Next Section

- Add `install` rules
- Add `cpack`
  - Packages installable targets using [generators](https://cmake.org/cmake/help/latest/manual/cpack-generators.7.html)
  - Used by DLFW
  - Packages targets in the following directories:
    - `bin` - location for binaries
    - `include` - location for header files
    - `lib` - location for libraries ()
- Install using different prefixes

### Commands

- `cmake -S . -B build`
- `cmake --build build --target package`
- `cmake --install build --prefix .`
- `sudo cmake --install build`

## Next Section

- Building a `conda` package

### Commands

- `conda activate fireside`
- `conda build recipe`
- `conda install --use-local helloworld`
