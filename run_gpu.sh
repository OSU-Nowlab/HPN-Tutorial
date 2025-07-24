#!/bin/bash
#SBATCH -p batch-bdw-v100
#SBATCH -J "GPU-Aware-MPI demo"
#SBATCH -t 40:00
#SBATCH -o "%j-GPU-Aware-demo.txt"


module load gcc/11.2.0 cuda/12.6
module load mvapich-plus/4.1rc
module li
top_dir=/home/michalowicz.2/MVP-things/MVP-build
omb_dir=$top_dir/libexec/osu-micro-benchmarks/mpi/collective

ppn=1 # One GPU/node
np=$(($SLURM_NNODES*$ppn))
warmup=400
iter=400

min_msg=65536
max_msg=$((8*1024*1024))

for bench in osu_allreduce osu_reduce osu_reduce_scatter; do
    echo "Running benchmark $bench on $np procs ($ppn GPU/node)"
    echo "Running running for message sizes $min_msg to $max_msg"

    for i in 0 1; do 
        echo "Running with MVP_ENABLE_GPU=$i"

        set -x
        if [[ $i == 0 ]] ; then
            $top_dir/bin/mpirun -np $np -ppn $ppn -genv MVP_ENABLE_GPU=$i \
                -genv UCX_LOG_LEVEL=fatal \
                $omb_dir/$bench -x $warmup -i $iter \
                -m $min_msg:$max_msg -f
        else
            $top_dir/bin/mpirun -np $np -ppn $ppn -genv MVP_ENABLE_GPU=$i \
                -genv UCX_LOG_LEVEL=fatal \
                $omb_dir/$bench -x $warmup -i $iter \
                -m $min_msg:$max_msg -f -d cuda
        fi
        set +x
        echo "===================================================================="
    done
    echo ""
    echo ""
done

echo "Done. Have a nice day!"

