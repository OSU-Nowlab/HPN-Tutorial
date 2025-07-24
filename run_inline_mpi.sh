#!/bin/bash
if [[ $SLURM_NODEID != 0 ]]; then
    exit;
fi

module load gcc/7.5.0

inlines="$@"
if [ -z "$1" ] ; then
    echo "Using default (0, 128)"
    inlines="0 128"
fi

hosts=()
for i in `scontrol show hostnames $SLURM_NODELIST`; do
  hosts+=($i);
done

for inl in $inlines
do
  echo -e "\n\nMPI Send/Recv Latency using Inline=$inl on hosts ${hosts[0]} and ${hosts[1]}"
  set -x

  /opt/mvapich2/mvapich2-2.3.7/bin/mpirun_rsh -np 2 \
      ${hosts[0]} ${hosts[1]} \
      MV2_HOMOGENEOUS_CLUSTER=1 MV2_MAX_INLINE_SIZE=$inl MV2_IBA_HCA=mlx5_0 \
      /opt/mvapich2/mvapich2-2.3.7/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency

{ set +x; } 2>/dev/null
done

