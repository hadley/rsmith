plugin <- function(name, process) {
  plugin_with_init(name, function(x) x, process)
}

plugin_with_init <- function(name, init, process) {
  structure(list(name = name, init = init, process = process), class = "rsmith_plugin")
}

print.rsmith_plugin <- function(x, ...) {
  cat("<rsmith_plugin> ", x$name, "\n", sep = "")
}
