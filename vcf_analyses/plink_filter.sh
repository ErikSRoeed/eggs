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
PLINK_DIR=
INPUT_BFILES_NAME=
INPUT_BFILES_N_CHROMOSOMES=30
FILTER_VARIANTS_WHERE_MAF_IS_BELOW=0.05
FILTER_VARIANTS_WHERE_MISSING_CALL_RATE_EXCEEDS=0.1
OPTIONAL_OUTPUT_SUFFIX=""

# Prepare environment
set -o errexit
set -o nounset
module --quiet purge

# Load modules
module load PLINK/1.9b_6.13-x86_64
module list

# Work start
echo "User definitions ..."
echo "Input dataset name:" $INPUT_BFILES_NAME
echo "Input datasets chromosome count:" $INPUT_BFILES_N_CHROMOSOMES
echo "Variant MAF filter:" $FILTER_VARIANTS_WHERE_MAF_IS_BELOW
echo "Variant call rate filter:" $FILTER_VARIANTS_WHERE_MISSING_CALL_RATE_EXCEEDS

cd $PLINK_DIR
echo "Working in:" $PWD

OUTPUT_BFILES_BASENAME=${INPUT_BFILES_NAME}${OPTIONAL_OUTPUT_SUFFIX}
echo "Output binary file set name:" ${OUTPUT_BFILES_BASENAME}

plink --bfile ${INPUT_BFILES_NAME} --out ${OUTPUT_BFILES_BASENAME} --make-bed \
--geno ${FILTER_VARIANTS_WHERE_MISSING_CALL_RATE_EXCEEDS} \
--maf ${FILTER_VARIANTS_WHERE_MAF_IS_BELOW} \
--double-id --set-missing-var-ids @:# \
--allow-extra-chr --chr-set $INPUT_BFILES_N_CHROMOSOMES

# Work end
