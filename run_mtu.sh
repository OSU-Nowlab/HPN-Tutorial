#!/bin/bash
if [[ $SLURM_NODEID != 0 ]]; then
    exit;
fi

mtus="$@"
if [ -z "$1" ] ; then
    echo "Using default MTUs (256, 4096)"
    mtus="256 4096"
fi

hostfile=hosts-$SLURM_JOBID

hosts=()
for i in `scontrol show hostnames $SLURM_NODELIST`; do
  hosts+=($i);
done

bench=ib_read_bw
for mtu in $mtus
do
  echo -e "\n\nIB Read Bandwidth Test using MTU=$mtu"
  echo -e "Executing '/usr/bin/$bench -d mlx5_0 -a -m $mtu ' on the server"
  ssh ${hosts[0]}    "/usr/bin/$bench -d mlx5_0 -a -m $mtu > /dev/null 2>&1 &"
  echo -e "Executing '/usr/bin/$bench -d mlx5_0 -a -m $mtu ${hosts[0]}' on the client"
  ssh ${hosts[1]}    "/usr/bin/$bench -d mlx5_0 -a -m $mtu ${hosts[0]}"
done

