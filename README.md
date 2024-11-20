# Distributed Training

This repository contains utils for distributed training runs on the Bau Lab cluster. In it, you'll find:

`/run` - A example of training Gemma 9b using DPO on Anthropic HH.
`monitor.sh` - A script for checking resources across all Baulab clusters.

## Setting up distributed training

First, you'll need to set up passwordless SSH login to machines on the baulab cluster. This is required for allowing torch to SSH in.

```bash
ssh-keygen # Generate an SSH key
ssh-copy-id user@remote_node # Copy key to remote node
ssh user@remote_node # Test connection
```

Then, configure the `run.sh` script to use your desired master node IP. You can find the master node IP by running `hostname -I`. This will return two addresses: the first points to the primary network address and the second to a docker bridge IP. Use the first value.

# Set up the monitoring script

Have you ever wanted to set up a training run across multiple Bau Lab cluster machines?

## Mac Installation

Tap [source](https://formulae.brew.sh/formula/sshpass)

brew install sshpass

Tap [source](https://formulae.brew.sh/formula/parallel)

brew install parallel

## (Optional) Adding the command to your shell profile

To install `bau`, add the following to your shell profile (e.g., `.bashrc`, `.zshrc`):

```bash
# ... existing shell config
export BAU=<absolute_path_to_repo>
source $BAU/monitor.sh
```

Make sure to `source` your shell profile:

```bash
source ~/.bashrc  # for bash users
# OR
source ~/.zshrc   # for zsh users
```

Then run:

```
bau
```

To check the status of all machines.