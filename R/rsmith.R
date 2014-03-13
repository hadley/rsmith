#' @examples
#' rsmith_demo("static-site")
rsmith <- function(src = "src", dest = "build") {
  src <- normalizePath(src, mustWork = TRUE)
  dest <- normalizePath(dest, mustWork = FALSE)
  metadata <- reactiveValues(.src = src, .dest = dest)

  paths <- dir(src, recursive = TRUE, full.names = TRUE)
  paths <- sub("^\\./", "", paths)
  files <- lapply(paths, function(x) {
    reactiveFileReader(250, NULL, x, read_file_with_metadata)
  })

  rsmith_obj(metadata, files)
}

rsmith_obj <- function(metadata, files) {
  out <- list(metadata = metadata, files = files)
  class(out) <- "rsmith"

  out
}

#' @export
print.rsmith <- function(x, ...) {
  isolate(cat("<rsmith> ", x$metadata$.src , " -> ", x$metadata$.dest, "\n",
    sep = ""))
  # print_metadata(metadata)

  cat("Files:\n")
  files <- isolate(lapply(x$files, function(f) f()))
  paths <- paste(vapply(files, path, character(1)), collapse = ", ")
  cat(strwrap(paths, indent = 2, exdent = 2), sep = "\n")
}

is.rsmith <- function(x) inherits(x, "rsmith")

rsmith_demo <- function(name, ...) {
  path <- system.file("demo", name, package = "rsmith")

  old <- setwd(path)
  on.exit(setwd(old))

  rsmith(dest = tempfile(), ...)
}
