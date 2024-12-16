#!/bin/bash

# ADMIN
#SBATCH --job-name=trim_align
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
#SBATCH --time=99:00:00

# User definitions
PIPELINE_REPOSITORY_DIR=
SAMPLE_INFO_CSV=

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
cd ${PIPELINE_REPOSITORY_DIR}
echo "Working in:" $PWD

if [ -e work/ ]
then
	nextflow run 1_trim_and_align.nf --samples ${SAMPLE_INFO_CSV} -resume
else
	nextflow run 1_trim_and_align.nf --samples ${SAMPLE_INFO_CSV}
fi

# Work end
