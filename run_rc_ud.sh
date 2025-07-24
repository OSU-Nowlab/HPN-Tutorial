#!/bin/bash
if [[ $SLURM_NODEID != 0 ]]; then
    exit;
fi

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
"MV2_HOMOGENEOUS_CLUSTER=1 MV2_IBA_HCA=mlx5_0 MV2_USE_ONLY_UD=0"
"MV2_HOMOGENEOUS_CLUSTER=1 MV2_IBA_HCA=mlx5_0 MV2_USE_ONLY_UD=1 MV2_UD_MAX_RECV_WQE=512 MV2_UD_MAX_SEND_WQE=512"
)

len=${#names[@]}

MPI=/opt/mvapich2/mvapich2-2.3.7

for (( i=0; i<$len; i++ ))
do
    env=${envs[$i]}
    name=${names[$i]}
    echo -e "\n\nRunning MPI_Alltoallv with $np processes with $name"
    set -x

    $MPI/bin/mpirun_rsh -np $np -hostfile $hostfile $env $MPI/libexec/osu-micro-benchmarks/mpi/collective/osu_alltoallv -m 2048

    { set +x; } 2>/dev/null
done

rm $hostfile
