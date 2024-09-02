#!/bin/bash

# ADMIN
#SBATCH --job-name=bash_header
#SBATCH --output=SLURM-%j-%x.out
#SBATCH --error=SLURM-%j-%x.err
#SBATCH --account=nn10082k
#
# RESOURCE ALLOCATION
#SBATCH --nodes=1
#SBATCH --tasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1G
#SBATCH --time=01:00:00

# User definitions

# Prepare environment
set -o errexit
set -o nounset
module --quiet purge

# Load modules
module list

# Work start
echo "Working in:" $PWD

# Work end
