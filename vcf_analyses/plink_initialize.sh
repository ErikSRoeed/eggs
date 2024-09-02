#!/bin/bash

# ADMIN
#SBATCH --job-name=plink_initialize
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
VCF_INPUT_FILE=
VCF_N_CHROMOSOMES=30
PLINK_PARENT_DIR=

# Prepare environment
set -o errexit
set -o nounset
module --quiet purge

# Load modules
module load PLINK/1.9b_6.13-x86_64
module list

# Work start
echo "User definitions ..."
echo "Input VCF:" $VCF_INPUT_FILE
echo "Unique chromosomes in VCF:" $VCF_N_CHROMOSOMES

cd ${PLINK_PARENT_DIR}
echo "Making and/or entering subdirectory plink under:" $PWD

if [ -e plink/ ]
then
    echo "Note: Writing files to existing plink directory."
else
    mkdir plink
fi

cd plink

BFILES_BASENAME=$(basename "$VCF_INPUT_FILE" | cut -d. -f1)
echo "Making binary file set with name:" ${BFILES_BASENAME}

plink --vcf ${VCF_INPUT_FILE} --out ${BFILES_BASENAME} --make-bed \
--double-id --set-missing-var-ids @:# \
--allow-extra-chr --chr-set $VCF_N_CHROMOSOMES

# Work end
