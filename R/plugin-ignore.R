#' Ignore files that match a pattern.
#'
#' @param rsmith An  \code{\link{rsmith}} object.
#' @param pattern A regular expression to match against the file paths.
#'   Any files matching the pattern will be dropped.
#' @param ... Additional arguments passed to \code{\link{grepl}}
#' @return An modified \code{\link{rsmith}} object.
#' @export
#' @family plugins
#' @examples
#' static_site <- rsmith_demo("static-site")
#' ignore_files(static_site, "first")
#' ignore_files(static_site, "post")
ignore_files <- function(rsmith, pattern, ...) {
  paths <- vapply(rsmith$files, path, character(1))
  keep <- !grepl(pattern, paths, ...)

  rsmith$files <- rsmith$files[keep]
  rsmith
}

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
#' ignore_drafts(static_site)
ignore_drafts <- function(rsmith) {
  is_draft <- function(x) isTRUE(isolate(x()$metadata$draft))
  drafts <- vapply(rsmith$files, is_draft, logical(1))

  rsmith$files <- rsmith$files[!drafts]
  rsmith
}
