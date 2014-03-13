#' Save rsmith output.
#'
#' \code{build} will build the site once, while \code{watch} listens for
#' changes, re-outputing every time an input file changes.
#'
#' @param rsmith An object created by \code{\link{rsmith}}.
#' @export
#' @examples
#' static_site <- rsmith_demo("static-site")
#' static_site %>% build()
#' \dontrun{
#' static_site %>% watch()
#' }
build <- function(rsmith) {
  files <- read_src(rsmith, read_file_with_metadata, quiet = TRUE)

  for (plugin in rsmith$plugins) {
    rsmith <- plugin$init(rsmith)
    files <- lapply(files, plugin$process)
  }

  write(rsmith, files)
}

#' @rdname build
#' @param interval How often to check for changes, in seconds.
#' @export
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
