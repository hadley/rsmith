#' Remove draft file.
#'
#' Any file with \code{draft: true} in the metadata will be removed.
#'
#' @param rsmith An  \code{\link{rsmith}} object.
#' @return An modified \code{\link{rsmith}} object.
#' @export
#' @family plugins
#' @examples
#' static_site <- rsmith_demo("static-site")
#' static_site$files[[1]]$metadata$draft <- TRUE
#' remove_drafts(static_site)
remove_drafts <- function(rsmith) {
  is_draft <- vapply(rsmith$files, function(x) isTRUE(x$metadata$draft),
    logical(1))
  rsmith$files <- rsmith$files[!is_draft]

  rsmith
}
