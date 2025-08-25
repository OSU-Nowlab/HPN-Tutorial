#!/bin/bash
#SBATCH -p batch-bdw-v100
#SBATCH -J "Pt2pt-with-MVAPICH-Plus-4.1"
#SBAtCH -o "%j-Pt2pt-MVP-4.1.out"
#SBATCH -t 30:00


module load gcc/11.2.0 cuda/12.6
module load mvapich-plus/4.1rc
module li
top_dir=/opt/mvapich-plus/4.1rc
omb_dir=$top_dir/libexec/osu-micro-benchmarks/mpi/collective
if [[ $SLURM_NODEID != 0 ]]; then
    exit;
fi

hosts=()
for i in `scontrol show hostnames $SLURM_NODELIST`; do
  hosts+=($i);
done

MPI=$top_dir

for bench in osu_latency osu_bw osu_bibw
do
    set -x

    $MPI/bin/mpirun -np 2 -ppn 1 -genv UCX_NET_DEVICES=mlx5_0:1 $MPI/libexec/osu-micro-benchmarks/mpi/pt2pt/$bench

    { set +x; } 2>/dev/null
done

