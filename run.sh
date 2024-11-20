export MASTER_ADDR="10.200.205.136" # Master node's IP
export MASTER_PORT="12345" # Port for communication

python distributed.py --rank 0 --world_size 2 --backend nccl