# Recipe Overview

- `recipe_single_pkg` - a single package recipe with a `host` requirement (`libpng`) which has a `run_exports` value set. Therefore, the final `libcudf` package from this recipe will have a runtime dependency on `libpng`
- `recipe_outputs_top_level` - a multi-output recipe that uses `build.sh` to do a single top level build (with `build.sh`) of all the CMake components and then uses the relevant `script`s to install the components that were built with `build.sh`. The issue with this approach is that the `libpng` runtime dependency (from `run_exports`) is no longer added to the `libcudf` package.
- `recipe_outputs` - a multi-output recipe that removes the top-level `build.sh` in favor of `script`s that do both the build _and_ install steps for each output package. This way `host` requirements are available during the build step for each package _and_ the necessary `run_exports` are added. The downside of this approach is that the `script_env` values must be copied to each output package, but YAML anchors can be used to prevent the need to duplicate the key/value pairs.

## Validation

- Run `conda-build recipe_single_pkg recipe_outputs recipe_outputs_top_level` to build all the packages.
- Examine the `index/info.json` file in each of the `libcudf` conda package tarballs to see the final computed `runtime` dependencies.
  - **Expected results:**
    - `libcudf-2.0.0-0.tar.bz2` does _not_ have the expected `libpng` runtime dependency
    - `libcudf-1.0.0-0.tar.bz2` and `libcudf-3.0.0-0.tar.bz2` _do_ have the expected `libpng` runtime dependency

## Summary

The top-level build approach is convenient because it lets you define the `script_env` values in one place. However, it also requires that all `host` requirements are moved to the top-level `requirements` section so that they can be properly linked against during the build. This has the unintended side-effect of also removing the `runtime` dependencies that are added to child packages via dependencies containing `run_exports`. To fix this, we can _remove_ the top-level `build.sh` and perform the build/install all at once for the packages in the `Outputs` section of the recipe. This ensures that the `host` requirements are available for linking during the build _and_ that they add any necessary `runtime` dependencies. The downside to this approach is that the `script_env` values must be added to each `Outputs` package since they contain variables that effect the CMake build. However, this can be easily accomplished without duplicating any code by using YAML anchors.

## Misc. Links

- Subpackage `run_exports` issue - https://github.com/conda/conda-build/issues/3478
