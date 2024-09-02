#!/bin/bash

# JOB NAME
#SBATCH --job-name=vcf_rename
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
#SBATCH --time=1:00:00

# User definitions
VCF_INPUT_FILE=
ID_CONVERSION_LIST=
VCF_OUTPUT_FILE=

# Prepare environment
set -o errexit
set -o nounset
module --quiet purge

# Load modules
module load BCFtools/1.18-GCC-12.3.0
module list

# Work start
bcftools reheader --samples ${ID_CONVERSION_LIST} --output ${VCF_OUTPUT_FILE} ${VCF_INPUT_FILE}

# Work end
