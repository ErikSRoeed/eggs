#!/bin/bash

# ADMIN
#SBATCH --job-name=filter_variants
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
PIPELINE_REPOSITORY_DIR=

MISS=0.8          # Missing data threshold (default 0.8)
Q_SITE1=30        # Site Phred score for population structure vcf (d. 30)
Q_SITE2=30        # Site Phred score for genome scan vcf (d. 30)
MIN_DEPTH=5       # Min. mean depth across all samples for a variant (d. 5)
MAX_DEPTH=30      # Max. mean depth acorr all samples ... (d. 30)
MIN_GENO_DEPTH=5  # Min. genotype depth per sample to not set as missing data (d. 5)
MAX_GENO_DEPTH=30 # Max. genotype depth per sample ... (d. 30)

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

nextflow run 3_filter_variants.nf --miss ${MISS} \
--q_site1 ${Q_SITE1} --q_site2 ${Q_SITE2}\
--min_depth ${MIN_DEPTH} --max_depth ${MAX_DEPTH}\
--min_geno_depth ${MIN_GENO_DEPTH} --max_geno_depth ${MAX_GENO_DEPTH}

# Work end
