#!/bin/bash

# JOB NAME
#SBATCH --job-name=vcf_concatenate
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
VCF_FULL_PATH_LIST=
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
echo "Concatenating VCFs listed in:" ${VCF_FULL_PATH_LIST} "..."
echo "To folder:" ${OUTPUT_DIR}
echo "With name:" ${OUTPUT_NAME}.vcf.gz

cd ${OUTPUT_DIR}
echo "Working in:" $PWD

mkdir vcf_cat

VCF_CONCATENATED=vcf_cat/${OUTPUT_NAME}.vcf.gz
VCF_CONCATENATED_NORMALISED=vcf_cat/${OUTPUT_NAME}_norm.vcf.gz

bcftools concat --file-list ${VCF_FULL_PATH_LIST} --naive --threads 8 --output-type z --output $VCF_CONCATENATED
bcftools index $VCF_CONCATENATED
bcftools norm --rm-dup none --output-type z --output $VCF_CONCATENATED_NORMALISED $VCF_CONCATENATED
bcftools index $VCF_CONCATENATED_NORMALISED

# Work end
