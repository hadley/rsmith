rsmith <- function(src = "src", dest = "build") {
  src <- normalizePath(src, mustWork = TRUE)
  dest <- normalizePath(dest, mustWork = FALSE)
  metadata <- list(.src = src, .dest = dest)

  old <- setwd(src)
  on.exit(setwd(old))

  paths <- dir(recursive = TRUE, full.names = TRUE)
  paths <- sub("^\\./", "", paths)
  files <- lapply(paths, read_file_with_metadata)

  rsmith_obj(metadata, files)
}

rsmith_obj <- function(metadata, files) {
  out <- list(metadata = metadata, files = files)
  class(out) <- "rsmith"

  out
}

#' @export
print.rsmith <- function(x, ...) {
  cat("<rsmith> ", x$metadata$.src , " -> ", x$metadata$.dest, "\n", sep = "")
  print_metadata(x$metadata)

  cat("Files:\n")
  files <- paste(vapply(x$files, path, character(1)), collapse = ", ")
  cat(strwrap(files, indent = 2, exdent = 2), sep = "\n")
}

is.rsmith <- function(x) inherits(x, "rsmith")


rsmith_demo <- function(name, ...) {
  path <- system.file("demo", name, package = "rsmith")

  old <- setwd(path)
  on.exit(setwd(old))

  rsmith(dest = tempfile(), ...)
}
