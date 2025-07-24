#!/bin/bash
if [[ $SLURM_NODEID != 0 ]]; then
    exit;
fi

hosts=()
for i in `scontrol show hostnames $SLURM_NODELIST`; do
  hosts+=($i);
done

for bench in ib_send_bw ib_write_bw ib_read_bw
do
  echo -e "\n\nExecuting '/usr/bin/$bench -d mlx5_0 -a' on the server"
  ssh ${hosts[0]}        "/usr/bin/$bench -d mlx5_0 -a > /dev/null 2>&1 &"
  echo -e "Executing     '/usr/bin/$bench -d mlx5_0 -a ${hosts[0]}' on the client"
  ssh ${hosts[1]}        "/usr/bin/$bench -d mlx5_0 -a ${hosts[0]}"
done

