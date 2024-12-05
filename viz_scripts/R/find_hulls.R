find_hulls <- function(data_frame, x_dim, y_dim, group_by = NULL) {

  if (! is.null(group_by)) {
    hulls <- plyr::ddply(data_frame, group_by, find_hulls, x_dim, y_dim)
    return(hulls)
  }

  hull <- data_frame[chull(data_frame[[x_dim]], data_frame[[y_dim]]), ]
  return(hull)
}
