#!/bin/bash
if [[ $SLURM_NODEID != 0 ]]; then
    exit;
fi

#libfabrics benchmarks can be found in libfabric/fabtests/benchmarks/
FAB_TEST_INSTALL="/opt/fabtest/libfabric/fabtests/install/bin"
hosts=()
for i in `scontrol show hostnames $SLURM_NODELIST`; do
  hosts+=($i);
done

for bench in fi_rdm_tagged_pingpong fi_dgram_pingpong
do
  echo -e "\n\nExecuting '$FAB_TEST_INSTALL/$bench -S all' on the server"
  ssh ${hosts[0]}        "$FAB_TEST_INSTALL/$bench   > /dev/null 2>&1 &"
  echo -e "Executing     '$FAB_TEST_INSTALL/$bench -S all ${hosts[0]}' on the client"
  ssh ${hosts[1]}        "$FAB_TEST_INSTALL/$bench   ${hosts[0]}"
done

