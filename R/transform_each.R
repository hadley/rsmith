#'
#' \code{transform_each()} is a helper to make it easier to write functions
#' that operate on files independently. More complex plugins should operate
#' directly on the rsmith object.
#'
#' @param plugin A plugin is a function with two arguments, which
#'   returns a modified file or NULL.
transform_each <- function(rsmith, plugin) {
  stopifnot(is.rsmith(rsmith), is.function(plugin))

  # Use compact so plugins can remove files by return NULL
  rsmith$files <- compact(lapply(rsmith$files, plugin,
    rsmith = rsmith$metadata))

  rsmith
}
