# Dash Programming Language STDLIB

Official repository of the Dash Programming Language standard libraries.

This repository provides all CLI standard libraries in both static (`.o`) and dynamic (`.so`) formats.

Most of the codebase is written in Dash.  
The `c_impl` module is deprecated and no longer used directly (only used at os module but implemented using Dash), but is still linked in static builds.

## Platform

- Linux only

## Build

Each module contains its own `dbuild.sh` script:

```bash
./dbuild.sh static
./dbuild.sh dynamic
./dbuild.sh static send
./dbuild.sh dynamic send