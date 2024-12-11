#' Class for parsing results of Admixture analysis
#'
#' @field sample_ids Ordered character vector of sample IDs
#' @field directory Path to directory holding Admixture output files
#' @field id_name Name to use for sample ID column in output
#'
admixture_parser <- R6::R6Class(

  classname = "Admixture Parser",

  public = list(

    #' Initialize by establishing values of fields
    #'
    #' @param admixture_directory Character singleton with path to Admixture output directory
    #' @param sample_ids Character vector (in order) containing IDs of analysed samples
    #' @param id_name Character singleton with name to use for sample ID column in output
    #'
    #' @returns Void.
    #'
    initialize = function(admixture_directory, sample_ids, id_name) {
      private$directory <- admixture_directory
      private$sample_ids <- sample_ids
      private$id_name <- id_name
    },

    #' Get table of Admixture cluster assignments
    #'
    #' @param k Integer singleton. Value of K to get assignments for
    #'
    #' @returns A tibble with one column of IDs and K columns with assignments probabilities.
    #'
    get_assignments = function(k = self$k_min_error) {
      qfile <- private$get_admixture_files(k = k)$qfiles
      assignments <- private$parse_qfile(qfile)
      return(assignments)
    }

  ),

  active = list(

    #' Get K with least CV error in Admixture output
    #'
    #' @returns An integer singleton.
    #'
    k_min_error = function() {
      self$k_values[which.min(self$cv_errors)]
    },

    #' Get all tried values of K in Admixture output
    #'
    #' @returns An integer vector.
    #'
    k_values = function() {
      vapply(private$parse_all_outfiles(), function(parsed) parsed$k, integer(1))
    },

    #' Get CV errors for each value of K in Admixture output
    #'
    #' @returns A floating point vector.
    #'
    cv_errors = function() {
      vapply(private$parse_all_outfiles(), function(parsed) parsed$cv_error, double(1))
    }

  ),

  private = list(

    directory = NULL,
    sample_ids = NULL,
    id_name = NULL,

    #' Identify and list Admixture output files in private$directory
    #'
    #' @param k An integer singleton. Get files only with K value of k, or for all K-values (NULL).
    #'
    #' @returns A list of two character vectors: outfiles holds paths to Admixture .out-files
    #' and qfiles holds paths to Admixture .Q-files. If k is specified, outfiles and qfiles will
    #' be character singletons. If k is NULL, outfiles and qfiles will hold the paths to output for
    #' all values of K in the Admixture output.
    #'
    get_admixture_files = function(k = NULL) {
      search_all_k <- is.null(k)
      if (search_all_k) {
        k <- "*"
      }
      outfiles <- dir(private$directory, pattern = paste(k, ".out", sep = ""), full.names = TRUE)
      qfiles <- dir(private$directory, pattern = paste(k, ".Q", sep = ""), full.names = TRUE)
      return(list(outfiles = outfiles, qfiles = qfiles))
    },

    #' Easily parse all outfiles to obtain all K-values and CV errors
    #'
    #' @returns A list where each item corresponds to an outfile. The outfile items are each a
    #' vector with named values for K and CV error.
    #'
    parse_all_outfiles = function() {
      all_outfiles <- private$get_admixture_files()$outfiles
      parsed_outfiles <- lapply(all_outfiles, private$parse_outfile)
      return(parsed_outfiles)
    },

    #' Parse an Admixture .out-file to read K and CV error
    #'
    #' @description In Admixture .out-files, K and CV error are provided in-text on the second
    #' last line. That line is formatted like e.g. "CV error (K=3): 0.28344". In other words,
    #' the value of K is obtained between "=" and ")", whereas the CV error is obtained from
    #' the fourth character after ")" until the end of the line.
    #'
    #' @param outfile Character singleton. Path to an Admixture .out-file
    #'
    #' @returns A list with one integer singleton (K) and one floating point singleton (CV error).
    #'
    parse_outfile = function(outfile) {
      outfile_lines <- readLines(outfile)
      second_last_line <- outfile_lines[[length(outfile_lines) - 1]]
      k_starts <- (stringr::str_locate(second_last_line, "\\=") + 1)[2]
      k_ends <- (stringr::str_locate(second_last_line, "\\)") - 1)[2]
      cv_starts <- k_ends + 4

      k <- as.integer(stringr::str_sub(second_last_line, k_starts, k_ends))
      cv_error <-  as.numeric(stringr::str_sub(second_last_line, cv_starts))

      return(list(k = k, cv_error = cv_error))
    },

    #' Parse an Admixture .Q-file to read cluster assignment table
    #'
    #' @description Admixture outputs cluster assignment tables in .Q-files. Each row represents
    #' a sample (in the same order as in the PLINK data set used as input), and each column a
    #' cluster. When read, columns are named V1, V2, V3 ... etc. The value in each cell is the
    #' cluster assignment probability of the individual (row) in that cluster (column).
    #'
    #' @param qfile Character singleton. Path to an Admixture .Q-file.
    #'
    #' @returns A dplyr tibble. The first column holds the sample IDs provided when the object is
    #' instantiated with self$initialize(). The remaining K columns holds assignment probabilities.
    #'
    parse_qfile = function(qfile) {
      assignments <- read.table(qfile)
      identified_assignments <- cbind(private$sample_ids, assignments)
      colnames(identified_assignments)[1] <- private$id_name
      return(dplyr::as_tibble(identified_assignments))
    }

  )

)

#' Function to instantiate new admixture_parser
#'
#' @param admixture_directory Character singleton. Directory holding Admixture output files.
#' @param sample_ids Character vector. The IDs of the samples input to Admixture from PLINK.
#' @param id_name Character singleton. Name to use for sample ID column in output
#'
#' @returns An object of class admixture_parser
#'
parse_admixture <- function(admixture_directory, sample_ids, id_name = "ID") {
  parser <- admixture_parser$new(admixture_directory, sample_ids, id_name)
  return(parser)
}
