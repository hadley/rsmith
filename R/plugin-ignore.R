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
#' static_site %>% use(ignore_files("first")) %>% preview()
#' static_site %>% use(ignore_files("post")) %>% preview()
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
#' static_site %>% use(ignore_drafts()) %>% preview()
ignore_drafts <- function() {
  plugin("ignore_drafts", function(file) {
    if (isTRUE(file$metadata$draft)) return()
    file
  })
}
