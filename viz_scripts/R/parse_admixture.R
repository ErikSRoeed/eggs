
parse_admixture <- function(admixture_output_dir, sample_ids, sample_group) {

  library(magrittr)

  out_files <- dir(admixture_output_dir, pattern = "*.out", full.names = TRUE)
  p_files <- dir(admixture_output_dir, pattern = "*.P", full.names = TRUE)
  q_files <- dir(admixture_output_dir, pattern = "*.Q", full.names = TRUE)

  admixture_results <- list()

  for (file_number in 1 :length(out_files)) {

    out_file <- out_files[file_number]
    assignments_file <- q_files[file_number]

    # Cross validation error and K are on second to last line of log file
    cv_error_line <- readLines(out_file) %>% .[[length(.) - 1]]

    # Find value of K in log file, formatted as "(K=etc.)"
    k_starts <- (cv_error_line %>% stringr::str_locate("\\=") + 1)[2]
    k_ends <- (cv_error_line %>% stringr::str_locate("\\)") - 1)[2]

    # Find cross validation error in log file, which starts after "(K=etc.): "
    cv_starts <- k_ends + 4

    cv_error <- cv_error_line %>% stringr::str_sub(cv_starts) %>% as.numeric()
    k <- cv_error_line %>% stringr::str_sub(k_starts, k_ends) %>% as.numeric()

    # Sample groups and sample ids assumed in same order
    assignments <- sample_group %>%
      cbind(sample_ids) %>%
      cbind(read.table(assignments_file))

    admixture_results %<>% append(
      list(
        list(
          "k" = k,
          "cv_error" = cv_error,
          "assignments" = assignments
        )
      )
    )
  }

  return(admixture_results)
}
