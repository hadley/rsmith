#' Convert rmarkdown to html
#'
#' Use the \pkg{rmarkdown} package. You can set options that apply to all
#' files in the global metadata field \code{rmarkdown}.
#'
#' @param pattern Regular expression used to identify Rmarkdown files.
#' @export
#' @examples
#' rmarkdown_demo <- rsmith_demo("rmarkdown")
#' rmarkdown_demo %>% preview()
#' rmarkdown_demo %>% use(rmarkdown()) %>% preview()
rmarkdown <- function(pattern = "\\.Rmd$") {
  if (!is_installed("rmarkdown")) {
    stop("Please install the rmarkdown package", call. = FALSE)
  }

  global <- NULL
  init <- function(rsmith) {
    global <<- rsmith$metadata$rmarkdown %||% list()

    rsmith
  }

  process <- function(files) {

    files <- lapply(files, function(file) {
      if (!grepl(pattern, path(file))) return(file)

      metadata <- modifyList(global, file$metadata)

      # Save file to temporary location
      tmp_in <- tempfile(fileext=".Rmd")
      on.exit(unlink(tmp_in), add = TRUE)
      cat("---\n", yaml::as.yaml(metadata), "---\n\n", file = tmp_in, sep = "")
      cat(file$contents, file = tmp_in, append = TRUE)

      # Render with rmarkdown
      out <- rmarkdown::render(tmp_in, NULL, quiet = TRUE,
        output_options = list(self_contained = FALSE))
      on.exit(unlink(out), add = TRUE)

      # Update file object
      file$contents <- read_file(out)
      path <- tools::file_path_sans_ext(file$metadata$.path)
      file$metadata$.path <- paste0(path, ".", tools::file_ext(out))

      file
    })

    compact(files)
  }

  plugin_with_init("rmarkdown", init, process)
}
