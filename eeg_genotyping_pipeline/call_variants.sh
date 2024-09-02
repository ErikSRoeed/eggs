#!/bin/bash

# ADMIN
#SBATCH --job-name=call_variants
#SBATCH --output=SLURM-%j-%x.out
#SBATCH --error=SLURM-%j-%x.err
#SBATCH --account=nn10082k
#
# RESOURCE ALLOCATION
#SBATCH --nodes=1
#SBATCH --tasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2G
#SBATCH --time=24:00:00

# User definitions
PIPELINE_REPOSITORY=
BAM_PATHS_LIST=

GENOME_PDOM=/cluster/projects/nn10082k/ref/house_sparrow_genome_assembly-18-11-14_masked.fa
GENOME_INDX=/cluster/projects/nn10082k/ref/house_sparrow_genome_assembly-18-11-14_masked.fa.fai
WINDOW_SIZE=10000000 # Ten million

# Prepare environment
set -o errexit
set -o nounset
module --quiet purge

# Load modules
module load Miniconda3/22.11.1-1
CONDA_PKGS_DIRS=/cluster/projects/nn10082k/conda_users/eriksro/package-cache
source ${EBROOTMINICONDA3}/bin/activate
conda activate /cluster/projects/nn10082k/conda_group/nextflow
module list

# Work start
cd ${PIPELINE_REPOSITORY}
echo "Working in:" $PWD

WINDOW_LIST=sparrow_genome_windows.list
bash 0_create_genome_windows.sh ${GENOME_INDX} ${WINDOW_SIZE} ${WINDOW_LIST}
nextflow run 2_call_variants.nf --bams ${BAM_PATHS_LIST} --windows ${WINDOW_LIST} --ref ${GENOME_PDOM}

# Work end
