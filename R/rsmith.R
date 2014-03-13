#' Generate a reactive site.
#'
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

add_plugin <- function(rsmith, plugin) {
  rsmith$plugins <- append(rsmith$plugins, plugin)
  rsmith
}

build <- function(rsmith) {
  files <- read_src(rsmith, read_file_with_metadata, quiet = TRUE)

  for (plugin in rsmith$plugins) {
    rsmith <- plugin$init(rsmith)
    files <- lapply(files, plugin$process)
  }

  write(rsmith, files)
}

watch <- function(rsmith, interval = 0.25) {
  if (!is_installed("whisker")) {
    stop("Please install the whisker package", call. = FALSE)
  }

  message("Watching for changes. Press Escape to stop.")

  files <- read_src(rsmith, reactive_file_with_metadata)

  for (plugin in rsmith$plugins) {
    rsmith <- plugin$init(rsmith)
    files <- lapply(files, function(x) shiny::reactive(plugin$process(x)))
  }

  shiny::observe({
    output <- lapply(rsmith$files, function(r) shiny::isolate(r()))
    write(rsmith, output)
  })

  while(TRUE) {
    Sys.sleep(interval / 10)
    shiny:::flushReact()
  }
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

rsmith_demo <- function(name, ...) {
  path <- system.file("demo", name, package = "rsmith")

  old <- setwd(path)
  on.exit(setwd(old))

  rsmith(dest = tempfile(), ...)
}
