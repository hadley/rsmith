#' Create collections of files
#'
#' Finds all files that match a given pattern, sorts them
#' according to some criteria and adds 'next' and 'previous' links
#' to them.
#'
#' @param pattern Regular expression to select files into the collection.
#' @param sortby Field to sort by.
#' @param reverse Whether to sort in decreasing order.
#' @export
#' @examples
#' rmarkdown_demo <- rsmith_demo("rmarkdown")
#' rmarkdown_demo %>%
#'   use(collections(pattern=".Rmd")) %>%
#'   use(rmarkdown()) %>%
#'   preview()

collections <- function(pattern, sortby = "date", reverse = TRUE) {

  init <- function(rsmith) {
    rsmith
  }

  add_refs <- function(files) {
    for (i in seq_along(files)) {
      if (i != 1) {
        files[[i]]$metadata$previous <- files[[i-1]]$metadata$.path
      }
      if (i != length(files)) {
        files[[i]]$metadata$`next` <- files[[i+1]]$metadata$.path
      }
    }
    files
  }

  sort_files <- function(files) {
    fields <- sapply(files, function(x) x$metadata[[sortby]])
    files[order(fields, decreasing=reverse)]
  }
  
  process <- function(files, rsmith) {

    init(rsmith)
    
    # Find files that match the pattern
    matching_files <- sapply(files, function(x) grepl(pattern, path(x)))
    
    # Sort them
    files[matching_files] <- sort_files(files[matching_files])

    # Add 'next' and 'previous' references
    files[matching_files] <- add_refs(files[matching_files])

    list(files=files, rsmith=rsmith)    
  }

  plugin("collections", process)
}
