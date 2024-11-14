#!/bin/bash

# ADMIN
#SBATCH --job-name=admixture
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
PLINK_PARENT_DIR=
INPUT_BFILES_NAME=
K_MIN=
K_MAX=
CPUS_PER_TASK= # Remember to always set this equal to the number passed to SBATCH

# Prepare environment
set -o errexit
set -o nounset
module --quiet purge

# Load modules
module load ADMIXTURE/1.3.0
module load PLINK/1.9b_6.13-x86_64
module list

# Work start
echo "User definitions ..."
echo "Input file set:" $INPUT_BFILES_NAME
echo "K: from" $K_MIN "to" $K_MAX

cd ${PLINK_PARENT_DIR}
echo "Working in:" $PWD

echo "Making subdirectory admixture ..."
mkdir admixture
mkdir admixture/.admixture_tmp

echo "Parsing plink dataset and removing chromosomes names ..."
cp plink/${INPUT_BFILES_NAME}.bed admixture/.admixture_tmp/${INPUT_BFILES_NAME}.admixture.bed
cp plink/${INPUT_BFILES_NAME}.fam admixture/.admixture_tmp/${INPUT_BFILES_NAME}.admixture.fam
awk '{$1="0";print $0}' plink/${INPUT_BFILES_NAME}.bim > admixture/.admixture_tmp/${INPUT_BFILES_NAME}.admixture.bim

cd admixture

echo "Running admixture ..."
for K in $(seq ${K_MIN} ${K_MAX})
do
    admixture --cv -j$CPUS_PER_TASK .admixture_tmp/${INPUT_BFILES_NAME}.admixture.bed $K > ${INPUT_BFILES_NAME}_K${K}.out
done

echo "Collating CV errors ..."
grep "CV" *.out | awk '{print $3,$4}' | cut -c 4,7-20 > ${INPUT_BFILES_NAME}.admixture.cv

echo "Tidying up temporary files ..."
rm -v ${INPUT_BFILES_NAME}*.out
rm -rv .admixture_tmp

# Work end
