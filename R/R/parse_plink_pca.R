
parse_plink_pca <- function(eigenvec_file, eigenval_file) {
  
  eigenvectors <- readr::read_table(eigenvec_file, col_names = FALSE)[ , -1]
  eigenvalues <- scan(eigenval_file)
  
  n_pc <- ncol(eigenvectors) - 1
  pc_names <- paste("pc", 1 : n_pc, sep = "")
  names(eigenvectors)[2 : ncol(eigenvectors)] <- pc_names
  names(eigenvectors)[1] <- "sample_id"
  
  variance_explained <- data.frame(
    pc = pc_names,
    variance = signif(eigenvalues / sum(eigenvalues), 3)
  )
  
  return(list(samples = eigenvectors, variances = variance_explained))
}
