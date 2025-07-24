# Basic IB Tutorial #
=====================

1. Measure InfiniBand Latency
$  srun -N2 run_perftest_lat.sh

2. Measure InfiniBand Bandwidth
$  srun -N2 run_perftest_bw.sh

3. Benchmark MPI Performance
$  srun -N2 run_omb.sh



# Advanced IB Tutorial #
========================

1. Impact of changing MTU size
$  srun -N2 run_mtu.sh 256 4096

2. Impact of changing Inline threshold
$  srun -N2 run_inline.sh 0 128

3. MPI Collective performance with RC/UD
$  srun -N4 run_rc_ud.sh

