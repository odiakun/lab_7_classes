# Instruction lab 7 - CUDA Graphs

### Clone the repository 

Familiarize yourself with the [NPB-GPU repository](https://github.com/GMAP/NPB-GPU). Check which benchmarks are available. Pay special attention to the concept of **classes**.

Also, clone the repository [NPB-GPU-CUDA-Graphs](https://github.com/odiakun/NPB-GPU-CUDA-Graphs).

### Run the benchmarks

Review the instructions on how to compile the benchmark files for a given **class**.

It is recommended to compile and run the following benchmarks: `LU, CG, and EP`, for classes `W` and `A`, using `nsys` for profiling.

Use the following command structure:

```
nsys profile --stats=true --trace=cuda -o <prolining data name> <binary file>
```

Pay attention to:
- The __total execution time__
- The __number of kernel launches__

### Core task

Create a comparison between:
- Execution time
- Number of kernel launches

for each benchmark (LU, CG, EP) run with and without CUDA Graphs.

> What differences do you observe?


