#!/bin/bash

# ADMIN
#SBATCH --job-name=triangulaR
#SBATCH --output=SLURM-%j-%x.out
#SBATCH --error=SLURM-%j-%x.err
#SBATCH --account=nn10082k
#
# RESOURCE ALLOCATION
#SBATCH --partition=bigmem
#SBATCH --nodes=1
#SBATCH --tasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=64G
#SBATCH --time=02:00:00

# User definitions (see triangulaR documentation and triangulaR.R script)
INPUT_VCF_PATH=
OUTPUT_DIR=
POPMAP_RDS_PATH=
PARENTAL_POP_A=
PARENTAL_POP_B=
DIFFERENCE_THRESHOLD=1 # 1 = fixed differences

# Path to companion R script triangulaR.R
R_SCRIPT= # ..../eggs/hpc_scripts/pop_analyses/triangulaR.R

# Prepare environment
set -o errexit
set -o nounset
module --quiet purge

# Load modules
module load R/4.4.1-gfbf-2023b
module list

# Work start
echo "User definitions:"
echo ""
echo "Input VCF:" $INPUT_VCF_PATH
echo "Writing output to directory:" $OUTPUT_DIR
echo "Reading popmap from RDA file:" $POPMAP_RDS_PATH
echo "ID of parental population A:" $PARENTAL_POP_A
echo "ID of parental population B:" $PARENTAL_POP_B
echo "Difference threshold:" $DIFFERENCE_THRESHOLD
echo ""

Rscript $R_SCRIPT --args $INPUT_VCF_PATH $OUTPUT_DIR \
$POPMAP_RDS_PATH $PARENTAL_POP_A $PARENTAL_POP_B $DIFFERENCE_THRESHOLD > ${OUTPUT_DIR}/triangulaR.Rout

# Work end
