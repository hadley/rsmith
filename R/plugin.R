#' Add a plugin.
#'
#' You can use one of the pre-built functions or create your own with
#' \code{\link{plugin}}.
#'
#' @param rsmith \code{\link{rsmith}} object
#' @param plugin object created by \code{\link{plugin}}
#' @return a modified rsmith \code{\link{rsmith}} object.
#' @export
#' @family plugins
add_plugin <- function(rsmith, plugin) {
  rsmith$plugins <- append(rsmith$plugins, list(plugin))
  rsmith
}

#' Create your own plugin.
#'
#' @param name of the plugin
#' @param process function called to process each file
#' @param init function called once with site metadata
#' @export
plugin <- function(name, process) {
  plugin_with_init(name, function(x) x, process)
}

#' @rdname plugin
#' @export
plugin_with_init <- function(name, init, process) {
  structure(list(name = name, init = init, process = process),
    class = "rsmith_plugin")
}

#' @export
print.rsmith_plugin <- function(x, ...) {
  cat("<rsmith_plugin> ", x$name, "\n", sep = "")
}
