#!/bin/bash

# ADMIN
#SBATCH --job-name=plink_to_vcf
#SBATCH --output=SLURM-%j-%x.out
#SBATCH --error=SLURM-%j-%x.err
#SBATCH --account=nn10082k
#
# RESOURCE ALLOCATION
#SBATCH --nodes=1
#SBATCH --tasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=4G
#SBATCH --time=01:00:00

# User definitions
PLINK_DIR=
INPUT_BFILES_NAME=
INPUT_BFILES_N_CHROMOSOMES=30

# Prepare environment
set -o errexit
set -o nounset
module --quiet purge

# Load modules
module load PLINK/1.9b_6.13-x86_64
module list

# Work start
echo "User definitions ..."
echo "Directory containing PLINK files:" $PLINK_DIR
echo "Name of PLINK b-file set:" $INPUT_BFILES_NAME

cd ${PLINK_DIR}
echo "Working in:" $PWD

plink --bfile ${INPUT_BFILES_NAME} --recode vcf-iid bgz --out ${INPUT_BFILES_NAME} \
--allow-extra-chr --chr-set $INPUT_BFILES_N_CHROMOSOMES

# Work end
