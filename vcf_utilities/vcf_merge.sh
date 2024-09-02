#!/bin/bash

# JOB NAME
#SBATCH --job-name=vcf_merge
#SBATCH --output=SLURM-%j-%x.out
#SBATCH --error=SLURM-%j-%x.err
#SBATCH --account=nn10082k
#
# RESOURCE ALLOCATION
#SBATCH --nodes=1
#SBATCH --tasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=12G
#SBATCH --time=24:00:00

# User definitions
VCF_INPUT_LIST=
OUTPUT_DIR=
OUTPUT_NAME=

# Prepare environment
set -o errexit
set -o nounset
module --quiet purge

# Load modules
module load BCFtools/1.18-GCC-12.3.0
module list

# Work start
cd ${OUTPUT_DIR}
echo "Working in:" $PWD

bcftools merge --file-list ${VCF_INPUT_LIST} --threads 8 --output-type z --output ${OUTPUT_NAME}.vcf.gz
bcftools index ${OUTPUT_NAME}.vcf.gz

# Work end
