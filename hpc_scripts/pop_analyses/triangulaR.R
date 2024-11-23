# Edit R library path as needed
.libPaths(c("/cluster/home/user/your-user-r-library-name", .libPaths()))
library(triangulaR)
library(vcfR)

# Read arguments from command line
arguments <- commandArgs(trailingOnly = TRUE)
input_vcf_path <- arguments[1] |> as.character()
output_directory <- arguments[2] |> as.character()
popmap_rds_path <- arguments[3] |> as.character()
parental_pop_a <- arguments[4] |> as.character()
parental_pop_b <- arguments[5] |> as.character()
difference_threshold <- arguments[6] |> as.numeric()

# Load VCF and population map
input_vcfR <- vcfR::read.vcfR(input_vcf_path)
popmap <- readRDS(popmap_rds_path)

# Find AIMs and save
triangulaR_aims_vcfR <- triangulaR::alleleFreqDiff(
  vcfR = input_vcfR,
  pm = popmap,
  p1 = parental_pop_a,
  p2 = parental_pop_b,
  difference = difference_threshold
)

vcf_outpath <- paste(output_directory, "triangulaR_AIMs.vcf.gz", sep = "_")
vcfR::write.vcf(triangulaR_aims_vcfR, file = vcf_outpath)

# Calculate heterozygosity and hybrid index and save
triangulaR_results <- triangulaR::hybridIndex(
  vcfR = triangulaR_aims_vcfR,
  pm = popmap,
  p1 = parental_pop_a,
  p2 = parental_pop_b
)

results_outpath <- paste(output_directory, "triangulaR_results.RDS", sep = "_")
saveRDS(triangulaR_results, file = results_outpath)
