#!/bin/bash

# ADMIN
#SBATCH --job-name=plink_prune
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
INPUT_BFILES_SEX_CHROMOSOME="chrZ"

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
echo "Input files set sex chromosome:" $INPUT_BFILES_SEX_CHROMOSOME

cd $PLINK_DIR
echo "Working in:" $PWD

plink --bfile ${INPUT_BFILES_NAME} --out ${INPUT_BFILES_NAME} --indep-pairwise 50 10 0.1 \
--allow-extra-chr --chr-set $N_CHROMOSOMES

grep -v ${INPUT_BFILES_SEX_CHROMOSOME} ${INPUT_BFILESET_NAME}.prune.in > ${INPUT_BFILESET_NAME}_auto.prune.in
grep ${INPUT_BFILES_SEX_CHROMOSOME} ${INPUT_BFILESET_NAME}.prune.in > ${INPUT_BFILESET_NAME}_${INPUT_BFILES_SEX_CHROMOSOME}.prune.in
mv ${INPUT_BFILESET_NAME}.prune.in ${INPUT_BFILESET_NAME}_geno.prune.in
mv ${INPUT_BFILESET_NAME}.prune.out ${INPUT_BFILESET_NAME}_geno.prune.out

# Work end
