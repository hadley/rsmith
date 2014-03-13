#' Add a plugin.
#'
#' You can use one of the pre-built functions or create your own with
#' \code{\link{plugin}}.
#'
#' @param rsmith \code{\link{rsmith}} object
#' @param plugin object created by \code{\link{plugin}}
#' @param a modified rsmith \code{\link{rsmith}} object.
#' @export
#' @family plugins
add_plugin <- function(rsmith, plugin) {
  rsmith$plugins <- append(rsmith$plugins, plugin)
  rsmith
}

plugin <- function(name, process) {
  plugin_with_init(name, function(x) x, process)
}

plugin_with_init <- function(name, init, process) {
  structure(list(name = name, init = init, process = process), class = "rsmith_plugin")
}

print.rsmith_plugin <- function(x, ...) {
  cat("<rsmith_plugin> ", x$name, "\n", sep = "")
}
