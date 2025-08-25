#!/bin/bash
#SBATCH -p batch-bdw-v100
#SBATCH -J "RC-UD demo"
#SBATCH -t 40:00
#SBATCH -o "%j-rc-ud-cpu.txt"

if [[ $SLURM_NODEID != 0 ]]; then
    exit;
fi

module load gcc/11.2.0 cuda/12.6
module load mvapich-plus/4.1rc
module li
top_dir=/opt/mvapich-plus/4.1rc
omb_dir=$top_dir/libexec/osu-micro-benchmarks/mpi/collective

which mpirun
ppn=28
hosts=()
hostfile="$HOME/hosts-$SLURM_JOBID"

for i in `scontrol show hostnames $SLURM_NODELIST`; do
  hosts+=($i);
  for j in `seq 1 $ppn`; do
    echo $i>>$hostfile
  done
done

np=`cat $hostfile | wc -l`

names=(
"RC"
"UD"
)

envs=(
"-genv UCX_NET_DEVICES=mlx5_0:1 -genv UCX_TLS=^ud,ud:aux"
"-genv UCX_NET_DEVICES=mlx5_0:1 -genv UCX_TLS=ud"
#"MV2_HOMOGENEOUS_CLUSTER=1 MV2_IBA_HCA=mlx5_0 MV2_USE_ONLY_UD=0"
#"MV2_HOMOGENEOUS_CLUSTER=1 MV2_IBA_HCA=mlx5_0 MV2_USE_ONLY_UD=1 MV2_UD_MAX_RECV_WQE=512 MV2_UD_MAX_SEND_WQE=512"
)

len=${#names[@]}

MPI=$top_dir

for (( i=0; i<$len; i++ ))
do
    env=${envs[$i]}
    name=${names[$i]}
    echo -e "\n\nRunning MPI_Alltoallv with $np processes with $name"
    set -x

    $MPI/bin/mpirun -np $np -ppn $ppn $env $MPI/libexec/osu-micro-benchmarks/mpi/collective/osu_alltoallv -m 1:4096

    { set +x; } 2>/dev/null
done

rm $hostfile
