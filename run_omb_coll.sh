#!/bin/bash
#SBATCH -p batch-bdw-v100
#SBATCH --reservation="ibtutorial"
#SBATCH -J "Pt2pt-with-MVAPICH-Plus-4.1"
#SBAtCH -o "%j-Coll-MVP-4.1.out"
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

ppn=$1

if [ -z $ppn ] ; then
    ppn=2
fi
np=$(($SLURM_NNODES*$ppn))

MPI=$top_dir

for coll in recursive_doubling ring
do
    echo "Running osu_allgather at $SLURM_NNODES nodes/$ppn ppn with algorithm $coll..."
    set -x

    $MPI/bin/mpirun -np $np -ppn $ppn -genv UCX_NET_DEVICES=mlx5_0:1 \
        -genv MVP_ALLGATHER_INTRA_ALGORITHM=$coll \
        $MPI/libexec/osu-micro-benchmarks/mpi/collective/osu_allgather -m 1:$((256*1024)) \
        -x 200 -i 1000

    { set +x; } 2>/dev/null
done

