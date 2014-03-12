rsmith <- function(src = "src", dest = "build") {
  metadata <- list(.src = src, .dest = dest)

  paths <- dir(src, recursive = TRUE, full.names = TRUE)
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

  files <- paste(vapply(x$files, path, character(1)), collapse = ", ")
  cat(strwrap(files, indent = 2, exdent = 2), sep = "\n")
}
