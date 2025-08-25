#!/bin/bash
if [[ $SLURM_NODEID != 0 ]]; then
    exit;
fi

module load gcc/11.2.0 cuda/12.6
module load mvapich-plus/4.1rc
module li
top_dir=/opt/mvapich-plus/4.1rc
omb_dir=$top_dir/libexec/osu-micro-benchmarks/mpi/collective


inlines="$@"
if [ -z "$1" ] ; then
    echo "Using default (0, 128)"
    inlines="0 128"
fi


#UCX_IB_TX_MIN_INLINE
hosts=()
for i in `scontrol show hostnames $SLURM_NODELIST`; do
  hosts+=($i);
done

for inl in $inlines
do
  echo -e "\n\nMPI Send/Recv Latency using Inline=$inl on hosts ${hosts[0]} and ${hosts[1]}"
  set -x

  $top_dir/bin/mpirun -np 2 -ppn 1 \
      -genv UCX_IB_TX_MIN_INLINE=$inl \
      -genv UCX_IB_RX_INLINE=$inl \
      -genv UCX_IB_TX_INLINE_RESP=$inl \
      -genv UCX_NET_DEVICES=mlx5_0:1 \
      -genv UCX_AM_BCOPY_INLINE_MAX_SIZE=$inl \
      -genv UCX_TLS=rc \
      $omb_dir/../pt2pt/osu_latency -x 300 -i 1000 \
      -m 1:1048576

    

 # /opt/mvapich2/mvapich2-2.3.7/bin/mpirun_rsh -np 2 \
 #     ${hosts[0]} ${hosts[1]} \
 #     MV2_HOMOGENEOUS_CLUSTER=1 MV2_MAX_INLINE_SIZE=$inl MV2_IBA_HCA=mlx5_0 \
 #     /opt/mvapich2/mvapich2-2.3.7/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency

{ set +x; } 2>/dev/null
done

