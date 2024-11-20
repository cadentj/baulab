import torch
import torch.distributed as dist
import argparse

def setup_distributed(rank, world_size, backend='nccl'):
    """
    Initialize the distributed environment.
    Args:
        rank (int): The rank of the current process.
        world_size (int): Total number of processes (nodes x gpus per node).
        backend (str): Backend to use ('nccl', 'gloo', or 'mpi').
    """
    # dist.init_process_group(
    #     backend=backend,
    #     init_method='env://',  # Environment variable initialization
    #     rank=rank,
    #     world_size=world_size,
    # )
    print(f"Rank {rank}/{world_size} initialized.")

def cleanup_distributed():
    """Clean up the distributed environment."""
    # dist.destroy_process_group()
    pass

def main():
    parser = argparse.ArgumentParser(description="PyTorch Distributed Template")
    parser.add_argument("--rank", type=int, required=True, help="Rank of the current process")
    parser.add_argument("--world_size", type=int, required=True, help="Total number of processes")
    parser.add_argument("--backend", type=str, default="nccl", help="Backend to use for distributed training")
    args = parser.parse_args()

    # Set up the distributed environment
    setup_distributed(args.rank, args.world_size, args.backend)

    # Insert your training code here

    # Clean up the distributed environment
    cleanup_distributed()

if __name__ == "__main__":
    main()
