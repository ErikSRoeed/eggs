#' Parse PCA output files from PLINK
#'
#' @param eigenval_path Path to PLINK output with .eigenval extension
#' @param eigenvec_path Path to PLINK output with .eigenvec extension
#' @param pc_prefix Prefix to use for principal component column names in output
#' @param id_name Name to use for sample ID column in output
#'
#' @returns A list containing one tibble (eigenvec) with sample IDs and principal component
#' values, and a vector (variance) of variances explained by each principal component.
#'
parse_plink_pca <- function(eigenval_path, eigenvec_path, pc_prefix, id_name) {
  eigenvec <- load_plink_eigenvec(eigenvec_path)
  eigenvec <- rename_plink_eigenvec(eigenvec, id_name, pc_prefix)
  eigenval <- load_plink_eigenval(eigenval_path)
  variance <- calculate_variance_explained(eigenval)
  return(list(eigenvec, variance))
}


#' Load PLINK .eigenvec file
#'
#' @param file_path Path to PLINK output with .eigenvec extension
#'
#' @returns A tibble containing sample IDs and eigenvector values
#'
load_plink_eigenvec <- function(file_path) {
  eigenvec <- readr::read_table(file_path, col_names = FALSE) |> dplyr::as_tibble()
  return(eigenvec)
}


#' Load PLINK .eigenval file
#'
#' @param file_path Path to PLINK output with .eigenval extension
#'
#' @returns A vector of eigenvalues for each principal component
#'
load_plink_eigenval <- function(file_path) {
  eigenval <- scan(file_path)
  return(eigenval)
}


#' Rename columns in eigenvector tibble from PLINK
#'
#' @param eigenvec An eigenvector tibble imported from PLINK
#' @param pc_prefix Prefix to use before principal component number
#' @param id_name Name to use for sample ID column in output
#'
#' @returns The input eigenvector tibble, renamed.
#'
rename_plink_eigenvec <- function(eigenvec, pc_prefix = "PC", id_name = "ID") {
  ID_INDEX <- 1

  pc_count <- ncol(eigenvec[-ID_INDEX])
  pc_columns <- seq(from = ID_INDEX + 1, to = pc_count)
  pc_names <- paste(pc_prefix, seq(pc_count), sep = "")

  names(eigenvec)[ID_INDEX] <- id_name
  names(eigenvec)[pc_columns] <- pc_names
  return(eigenvec)
}

#' Calculate variance explained by each principal component
#'
#' @param eigenval Vector of eigenvalues loaded from PLINK
#'
#' @returns A vector of variances explained per principal component
#'
calculate_variance_explained <- function(eigenval) {
  variance_explained <- eigenval / sum(eigenval)
  return(variance_explained)
}
