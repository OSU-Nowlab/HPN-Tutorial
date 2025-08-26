#!/bin/bash
#SBATCH -N4
#SBATCH -p thor
#SBATCH -t 15:00
#SBATCH -J "Ialltoall demo"
#SBATCH -o "%j-ialltoall-output.txt"
#SBATCH -w thor[017-018],thorbf3a[017,018]
##SBATCH
if [[ $SLURM_NODEID != 0 ]]; then
    exit;
fi

SUB="bf"
ppn=16
hosts=()
hostfile="$HOME/hosts-$SLURM_JOBID"
dpufile="$HOME/dpu-$SLURM_JOBID"
for i in `scontrol show hostname`; do
    if [[ "$i" == *"$SUB"* ]] ; then
        echo "$i" >> $dpufile
        export MV2_IBA_HCA=mlx5_0
    else
        hosts+=($i);
        for j in `seq 1 $ppn`; do
            echo $i>>$hostfile
        done
        export MV2_IBA_HCA=mlx5_0
    fi
done

np=`cat $hostfile | wc -l`

names=(
"No-DPU"
"With-DPU"
)

envs=(
"MV2_USE_DPU=0"
"MV2_USE_DPU=1 MV2_USE_DPU_IALLGATHER=1 MV2_USE_DPU_IBCAST=1 MV2_HYBRID_ENABLE_THRESHOLD=16384 MV2_ON_DEMAND_THRESHOLD=32768"
)

len=${#names[@]}

#cat $hostfile
#cat $dpufile


MPI=/global/scratch/users/subramoni/Ben/tutorial-things/MV2-DPU-build

for (( i=0; i<$len; i++ ))
do
    env=${envs[$i]}
    name=${names[$i]}
    echo -e "\n\nRunning MPI_Ialltoall with $np processes with $name"
    set -x

    $MPI/bin/mpirun_rsh --export-all -np $np -hostfile $hostfile -dpufile $dpufile -bf3 $env \
        $MPI/libexec/osu-micro-benchmarks/mpi/collective/osu_ialltoall \
        -f -m 16384:$((1*1024*1024)) 2>/dev/null

    { set +x; } 2>/dev/null
done


rm $hostfile
rm $dpufile
exit 0
