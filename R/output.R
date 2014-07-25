#' Save rsmith output.
#'
#' \code{build} will build the site once, while \code{watch} listens for
#' changes, re-outputing every time an input file changes. \code{preview}
#' prints output on screen.
#'
#' @param rsmith An object created by \code{\link{rsmith}}.
#' @export
#' @examples
#' static_site <- rsmith_demo("rmarkdown")
#' static_site %>% build()
#' \dontrun{
#' static_site %>% watch()
#' }
build <- function(rsmith) {
  files <- read_src(rsmith, read_file_with_metadata, quiet = TRUE)

  for (plugin in rsmith$plugins) {
    tmp <- plugin$process(files = files, rsmith = rsmith)
    rsmith <- tmp$rsmith
    files <- tmp$files
  }

  write(rsmith, files)
}

#' @rdname build
#' @export
preview <- function(rsmith) {
  files <- read_src(rsmith, read_file_with_metadata, quiet = TRUE)

  for (plugin in rsmith$plugins) {
    tmp <- plugin$process(files = files, rsmith = rsmith)
    rsmith <- tmp$rsmith
    files <- tmp$files
  }

  for(file in files) {
    message(file$metadata$.path)
    cat(file$content, "\n", sep = "")
  }
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

  shiny::reactive({
    for (plugin in rsmith$plugins) {
      tmp <- plugin$process(files = files, rsmith = rsmith)
      rsmith <- tmp$rsmith
      files <- tmp$files
    }
  })

  obs <- shiny::observe({
    output <- lapply(files, function(r) r())
    write(rsmith, output, quiet = TRUE)
  })
  on.exit(obs$suspend(), add = TRUE)

  while(TRUE) {
    Sys.sleep(interval / 10)
    if (shiny:::timerCallbacks$executeElapsed()) shiny:::flushReact()
  }
}
