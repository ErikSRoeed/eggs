# Read arguments from command line
arguments <- commandArgs(trailingOnly = TRUE)
for (argument in arguments) {
  cat(argument, "\n")
}

input_vcf_path <- arguments[2] |> as.character()
output_directory <- arguments[3] |> as.character()
popmap_rds_path <- arguments[4] |> as.character()
parental_pop_a <- arguments[5] |> as.character()
parental_pop_b <- arguments[6] |> as.character()
difference_threshold <- arguments[7] |> as.numeric()
r_library_path <- arguments[8] |> as.character()

# Setup
.libPaths(c(r_library_path, .libPaths()))
library(triangulaR)
library(vcfR)

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
