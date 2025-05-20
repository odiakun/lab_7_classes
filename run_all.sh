#!/bin/bash

set -e

BENCHMARKS=("lu" "cg" "ep")
CLASSES=("W" "A")

VERSIONS=("cuda" "graphs")
REPO_URLS=(
    "https://github.com/GMAP/NPB-GPU.git"
    "https://github.com/odiakun/NPB-GPU-CUDA-Graphs.git"
)
REPO_DIRS=(
    "NPB-GPU/CUDA"
    "NPB-GPU-CUDA-Graphs/CUDA-Graphs"
)

if [ ! -d "NPB-GPU" ]; then
    echo "Cloning NPB-GPU (CUDA only)..."
    git clone "${REPO_URLS[0]}"
fi

if [ ! -d "NPB-GPU-CUDA-Graphs" ]; then
    echo "Cloning NPB-GPU-CUDA-Graphs (CUDA Graphs)..."
    git clone "${REPO_URLS[1]}"
fi

CC_MAJOR=8
CC_MINOR=9
CC_COMPUTE="compute_${CC_MAJOR}${CC_MINOR}"
CC_CODE="sm_${CC_MAJOR}${CC_MINOR}"
CC_FLAGS="-gencode arch=${CC_COMPUTE},code=${CC_CODE}"

echo "Updating compute capability to ${CC_COMPUTE}/${CC_CODE} in make.def"

for def in "NPB-GPU/CUDA/config/make.def" "NPB-GPU-CUDA-Graphs/CUDA-Graphs/config/make.def"; do
    sed -i "s|^COMPUTE_CAPABILITY *=.*|COMPUTE_CAPABILITY = ${CC_FLAGS}|" "$def"
done


mkdir -p nsys_reports
mkdir -p profiling_outputs


for i in "${!VERSIONS[@]}"; do
    version="${VERSIONS[$i]}"
    src_dir="${REPO_DIRS[$i]}"

    echo "Compiling benchmarks for $version in $src_dir"
    pushd "$src_dir" > /dev/null

    for bench in "${BENCHMARKS[@]}"; do
        for cls in "${CLASSES[@]}"; do
            echo " - make $bench CLASS=$cls"
            make "$bench" CLASS="$cls" -j || { echo "Failed to build $bench CLASS=$cls in $src_dir"; exit 1; } 
        done
    done

    popd > /dev/null
done


for i in "${!VERSIONS[@]}"; do
    version="${VERSIONS[$i]}"
    bin_dir="${REPO_DIRS[$i]}/bin"

    for bench in "${BENCHMARKS[@]}"; do
        for cls in "${CLASSES[@]}"; do
            binary="./$bin_dir/./${bench}.${cls}"
            output="nsys_reports/${bench}_${cls}_${version}"
            profiling_output="profiling_outputs/${bench}_${cls}_${version}"

            if [ ! -f "$binary" ]; then
                echo "Binary not found: $binary"
                continue
            fi

            echo "Profiling $binary -> $output.nsys-rep -> $profiling_output.txt"
            nsys profile --stats=true --trace=cuda -o "$output" "$binary" > "${profiling_output}.txt" 2>&1
        done
    done
done


echo "All profiling complete. Results in ./nsys_reports/ and ./profiling_outputs/"
