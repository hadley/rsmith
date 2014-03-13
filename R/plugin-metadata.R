#' Add additional global metadata.
#'
#' @param rsmith An  \code{\link{rsmith}} object.
#' @param ... Additional named arguments to add to metadata/
#' @return An modified \code{\link{rsmith}} object.
#' @export
#' @family plugins
#' @examples
#' static_site <- rsmith_demo("static-site")
#' add_metadata(static_site, test = 1, foo = "bar")
add_metadata <- function(rsmith, ...) {
  new <- list(...)
  rsmith$metadata <- modifyList(rsmith$metadata, new)

  rsmith
}
