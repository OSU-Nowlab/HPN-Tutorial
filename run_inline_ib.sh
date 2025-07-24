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

bench=ib_write_lat
for inl in $inlines
do
  echo -e "\n\nIB Write Latency using Inline=$inl"
  echo -e "Executing '/usr/bin/$bench -d mlx5_0 -a -I $inl ' on the server"
  ssh ${hosts[0]}    "/usr/bin/$bench -d mlx5_0 -a -I $inl > /dev/null 2>&1 &"
  echo -e "Executing '/usr/bin/$bench -d mlx5_0 -a -I $inl ${hosts[0]}' on the client"
  ssh ${hosts[1]}    "/usr/bin/$bench -d mlx5_0 -a -I $inl ${hosts[0]}"
done
