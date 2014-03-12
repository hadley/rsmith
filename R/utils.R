compact <- function(x) {
  is_null <- vapply(x, is.null, logical(1))
  x[!is_null]
}

is_installed <- function(pkg) {
  system.file(package = pkg) != ""
}
