compact <- function(x) {
  is_null <- vapply(x, is.null, logical(1))
  x[!is_null]
}

is_installed <- function(pkg) {
  system.file(package = pkg) != ""
}

print_metadata <- function(x) {
  if (is.null(x)) return()

  cat("Metadata:\n")
  str(x, no.list = TRUE)
}

combine_paths <- function(x, y) {
  if (substr(y, 1, 1) == "/") return(y)

  normalizePath(file.path(x, y))
}
