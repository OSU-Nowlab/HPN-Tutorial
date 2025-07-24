#!/bin/bash

module load gcc/7.5.0

if [[ $SLURM_NODEID != 0 ]]; then
    exit;
fi

hosts=()
for i in `scontrol show hostnames $SLURM_NODELIST`; do
  hosts+=($i);
done

MPI=/opt/mvapich2/mvapich2-2.3.7

for bench in osu_latency osu_bw osu_bibw
do
    set -x

    $MPI/bin/mpirun_rsh -np 2 ${hosts[0]} ${hosts[1]} MV2_HOMOGENEOUS_CLUSTER=1 MV2_IBA_HCA=mlx5_0 $MPI/libexec/osu-micro-benchmarks/mpi/pt2pt/$bench

    { set +x; } 2>/dev/null
done

