# Instruction lab 7 - CUDA vs CUDA Graphs

### 1. Clone the repository 

In separate directory clone [this repository](https://github.com/odiakun/lab_7_classes).

> This script runs benchmarks LU, CG, EP in both CUDA and CUDA Graphs versions and collects results.


### 2. Run the benchmarks

```bash
chmod +x run_all.sh
./run_all.sh
```

> Results, including timing and profiling data will be saved in the `$(pwd)/profiling_outputs/` directory. \
Profiling data itself will be saved to the `$(pwd)/nsys_reports/`.

### 3. Investigate the results

Compare __total execution time__ and __number of kernel launches__ for each benchmark(LU, CG, EP) between CUDA and CUDA Graphs.
You can extract this information from the `.txt` output or `nsys stats`.

> Which implementation is faster? \
> Which one has fewer kernel lauches?\
> Are the performance differences consistent accross benchmarks?

### To satisfy your curiosity

For more details about the implementation, benchmark evolution, and task descriptions, visit the [original NPB-GPU repository](https://github.com/GMAP/NPB-GPU).

