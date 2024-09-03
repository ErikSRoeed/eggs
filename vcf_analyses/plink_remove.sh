#!/bin/bash

# ADMIN
#SBATCH --job-name=plink_remove
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
EXCLUDE_SAMPLES_LIST=
OUTPUT_BFILES_NAME=

# Prepare environment
set -o errexit
set -o nounset
module --quiet purge

# Load modules
module load PLINK/1.9b_6.13-x86_64
module list

# Work start
echo "User definitions ..."
echo "Input file set:" $INPUT_BFILES_NAME
echo "Input file set chromosome count:" $INPUT_BFILES_N_CHROMOSOMES
echo "Output file set:" $OUTPUT_BFILES_NAME
echo "Removing following samples (if present):"
cat $EXCLUDE_SAMPLES_LIST

cd ${PLINK_DIR}
echo "Working in:" $PWD

plink --bfile ${INPUT_BFILES_NAME} --out ${OUTPUT_BFILES_NAME} --make-bed \
--remove ${EXCLUDE_SAMPLES_LIST} \
--allow-extra-chr --chr-set $N_CHROMOSOMES

# Work end