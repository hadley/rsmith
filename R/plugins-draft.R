
use_draft <- function(rsmith) transform_each(draft)

draft <- function(file, rsmith) {
  if (isTRUE(file$metadata$draft)) return(NULL)
  file
}

