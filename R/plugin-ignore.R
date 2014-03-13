#' @include plugin.R
NULL

#' Ignore files that match a pattern.
#'
#' @param pattern A regular expression to match against the file paths.
#'   Any files matching the pattern will be dropped.
#' @param ... Additional arguments passed to \code{\link{grepl}}
#' @return An \code{\link{plugin}}
#' @export
#' @family plugins
#' @examples
#' static_site <- rsmith_demo("static-site")
#' ignore_files(static_site, "first")
#' ignore_files(static_site, "post")
ignore_files <- function(pattern, ...) {
  plugin("ignore_files", function(file) {
    if (grepl(pattern, file$metadata$.path, ...)) return()

    file
  })
}

#' Remove draft file.
#'
#' Any file with \code{draft: true} in the metadata will be removed.
#'
#' @return An \code{\link{plugin}}
#' @export
#' @family plugins
#' @examples
#' static_site <- rsmith_demo("static-site")
#' ignore_drafts(static_site)
ignore_drafts <- function() {
  plugin("ignore_drafts", function(file) {
    if (isTRUE(file$metadata$draft)) return()
    file
  })
}
