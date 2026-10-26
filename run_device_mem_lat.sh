#!/bin/bash
if [[ $SLURM_NODEID != 0 ]]; then
    exit;
fi

hosts=()
for i in `scontrol show hostnames $SLURM_NODELIST`; do
  hosts+=($i);
done

#for bench in ib_send_lat ib_write_lat ib_read_lat
#do
bench=ibv_rc_pingpong
niters=20000
mtu=4096
msg=4096
echo -e "\n\nExecuting '/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg' on the server (No device memory)"
ssh ${hosts[0]}        "/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg > /dev/null 2>&1 &"
echo -e "Executing     '/usr/bin/$bench -d mlx5_0 -m $mtu -s $msg ${hosts[0]}' on the client"
ssh ${hosts[1]}        "/usr/bin/$bench -d mlx5_0 -m $mtu -s $msg  ${hosts[0]} | tail -n 2 "

echo -e "\n\nExecuting '/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg' on the server (With device memory)"
ssh ${hosts[0]}        "/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg > /dev/null 2>&1 &"
echo -e "Executing     '/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg ${hosts[0]}' on the client"
ssh ${hosts[1]}        "/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg  ${hosts[0]} | tail -n 2"

msg=8192
echo -e "\n\nExecuting '/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg' on the server (No device memory)"
ssh ${hosts[0]}        "/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg > /dev/null 2>&1 &"
echo -e "Executing     '/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg ${hosts[0]}' on the client"
ssh ${hosts[1]}        "/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg  ${hosts[0]} | tail -n 2"

echo -e "\n\nExecuting '/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg' on the server (With device memory)"
ssh ${hosts[0]}        "/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg > /dev/null 2>&1 &"
echo -e "Executing     '/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg ${hosts[0]}' on the client"
ssh ${hosts[1]}        "/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg  ${hosts[0]} | tail -n 2"


msg=16384
echo -e "\n\nExecuting '/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg' on the server (No device memory)"
ssh ${hosts[0]}        "/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg > /dev/null 2>&1 &"
echo -e "Executing     '/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg ${hosts[0]}' on the client"
ssh ${hosts[1]}        "/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg  ${hosts[0]} | tail -n 2"

echo -e "\n\nExecuting '/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg' on the server (With device memory)"
ssh ${hosts[0]}        "/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg > /dev/null 2>&1 &"
echo -e "Executing     '/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg ${hosts[0]}' on the client"
ssh ${hosts[1]}        "/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg  ${hosts[0]} | tail -n 2"

msg=32768
echo -e "\n\nExecuting '/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg' on the server (No device memory)"
ssh ${hosts[0]}        "/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg > /dev/null 2>&1 &"
echo -e "Executing     '/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg ${hosts[0]}' on the client"
ssh ${hosts[1]}        "/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg  ${hosts[0]} | tail -n 2"

echo -e "\n\nExecuting '/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg' on the server (With device memory)"
ssh ${hosts[0]}        "/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg > /dev/null 2>&1 &"
echo -e "Executing     '/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg ${hosts[0]}' on the client"
ssh ${hosts[1]}        "/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg  ${hosts[0]} | tail -n 2"

msg=65536
echo -e "\n\nExecuting '/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg' on the server (No device memory)"
ssh ${hosts[0]}        "/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg > /dev/null 2>&1 &"
echo -e "Executing     '/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg ${hosts[0]}' on the client"
ssh ${hosts[1]}        "/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg  ${hosts[0]} | tail -n 2"

echo -e "\n\nExecuting '/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg' on the server (With device memory)"
ssh ${hosts[0]}        "/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg > /dev/null 2>&1 &"
echo -e "Executing     '/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg ${hosts[0]}' on the client"
ssh ${hosts[1]}        "/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg  ${hosts[0]} | tail -n 2"

msg=131072
echo -e "\n\nExecuting '/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg' on the server (No device memory)"
ssh ${hosts[0]}        "/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg > /dev/null 2>&1 &"
echo -e "Executing     '/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg ${hosts[0]}' on the client"
ssh ${hosts[1]}        "/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg  ${hosts[0]} | tail -n 2"

echo -e "\n\nExecuting '/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg' on the server (With device memory)"
ssh ${hosts[0]}        "/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg > /dev/null 2>&1 &"
echo -e "Executing     '/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg ${hosts[0]}' on the client"
ssh ${hosts[1]}        "/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg  ${hosts[0]} | tail -n 2"

msg=262144
echo -e "\n\nExecuting '/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg' on the server (No device memory)"
ssh ${hosts[0]}        "/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg > /dev/null 2>&1 &"
echo -e "Executing     '/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg ${hosts[0]}' on the client"
ssh ${hosts[1]}        "/usr/bin/$bench -d mlx5_0 -m $mtu -n $niters -s $msg  ${hosts[0]} | tail -n 2"

echo -e "\n\nExecuting '/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg' on the server (With device memory)"
ssh ${hosts[0]}        "/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg > /dev/null 2>&1 &"
echo -e "Executing     '/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg ${hosts[0]}' on the client"
ssh ${hosts[1]}        "/usr/bin/$bench -d mlx5_0 -j -m $mtu -n $niters -s $msg  ${hosts[0]} | tail -n 2"


#done

