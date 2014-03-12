
draft <- function(file, rsmith) {
  if (isTRUE(file$metadata$draft)) return(NULL)
  file
}

