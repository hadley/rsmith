rsmith <- function(src = "", dest = "_site") {
  metadata <- list(.src = src, .dest = dest)

  paths <- dir(src, recursive = TRUE, full.names = TRUE)
  files <- lapply(paths, read_file)
  names(files) <- paths

  rsmith_obj(metadata, files)
}

rsmith_obj <- function(metadata, files) {
  out <- list(metdata = metadata, files = files)
  class(out) <- "rsmith"

  out
}

#' @export
print.rsmith <- function(x, ...) {
  cat("<rsmith> ", x$metadata$.src , " -> ", x$metadata$.dest, "\n")

  files <- paste(names(x$files), collapse = ", ")
  cat(strwrap(files, indent = 2, exdent = 2), sep = "\n")
}
