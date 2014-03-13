#' Initialise rsmith.
#'
#' RSmith is a static site generator for R. This function provides
#' basic metadata about the site. You then \code{\link{add_plugin}}s to do
#' manipulate the source files, and finally use \code{\link{build}} or
#' \code{\link{watch}} to save the results to disk.
#'
#' @param src,dest Source and destination directories
#' @param base Base directory - should usually be set to the parent of the src.
#' @export
#' @examples
#' rsmith_demo("static-site") %>% build()
rsmith <- function(src = "src", dest = "build", base = ".") {
  base <- normalizePath(base, mustWork = TRUE)

  metadata <- list(.base = base, .src = src, .dest = dest)
  plugins <- list()

  out <- list(metadata = metadata, plugins = plugins)
  class(out) <- "rsmith"

  out
}

read_src <- function(rsmith, f, ...) {
  old <- setwd(rsmith$metadata$.base)
  on.exit(setwd(old))
  setwd(rsmith$metadata$.src)

  paths <- dir(recursive = TRUE, full.names = TRUE)
  paths <- gsub("^\\./", "", paths)

  lapply(paths, f, ...)
}

#' @export
print.rsmith <- function(x, ...) {
  cat("<rsmith> ", x$metadata$.src , " -> ", x$metadata$.dest, "\n", sep = "")
  # print_metadata(metadata)

  cat("Files:\n")
  paths <- vapply(x$files, path, character(1))
  cat(strwrap(paste(paths, collapse = ", "), indent = 2, exdent = 2),
    sep = "\n")
}

is.rsmith <- function(x) inherits(x, "rsmith")

#' Easily access rsmith demo sites.
#'
#' @param name Name of demo.
#' @keywords internal
#' @export
#' @examples
#' system.path("demo", package = "rsmith")
#' rsmith_demo("static-site")
rsmith_demo <- function(name, ...) {
  path <- system.file("demo", name, package = "rsmith")

  old <- setwd(path)
  on.exit(setwd(old))

  rsmith(dest = tempfile(), ...)
}
