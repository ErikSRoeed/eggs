#!/bin/bash

# JOB NAME
#SBATCH --job-name=vcf_remove
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
VCF_INPUT_FILE=
EXCLUDE_SAMPLES_LIST=
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
echo "Input VCF:" ${VCF_INPUT_FILE} "..."
echo "Output to folder:" ${OUTPUT_DIR}
echo "With filename:" ${OUTPUT_NAME}.vcf.gz
echo "Removing following samples (if present):"
cat $EXCLUDE_SAMPLES_LIST

cd ${OUTPUT_DIR}

bcftools view --force-samples --output-type z --sample-list ^$EXCLUDE_SAMPLES_LIST $VCF_INPUT_FILE > ${OUTPUT_NAME}.vcf.gz
bcftools index ${OUTPUT_NAME}.vcf.gz

# Work end
