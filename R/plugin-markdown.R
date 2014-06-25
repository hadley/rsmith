#' Convert markdown to html
#'
#' Use the \pkg{markdown} package. Markdown inputs are converted to html
#' and their extension changed to \code{.html}.
#'
#' @param pattern Regular expression used to identify markdown files.
#' @export
#' @examples
#' static_site <- rsmith_demo("static-site")
#' static_site %>% preview()
#' static_site %>% use(markdown()) %>% preview()
markdown <- function(pattern = "\\.md$") {
  if (!is_installed("markdown")) {
    stop("Please install the markdown package", call. = FALSE)
  }

  plugin("markdown", function(files, rsmith) {
    files <- lapply(files, function(file) {
      if (!grepl(pattern, path(file))) return(file)

      contents <- rawToChar(file$contents)
      if (nzchar(contents)) {
        html <- markdown::markdownToHTML(text = contents, fragment.only = TRUE)
        file$contents <- charToRaw(html)
      }

      path <- tools::file_path_sans_ext(file$metadata$.path)
      file$metadata$.path <- paste0(path, ".html")

      file
    })

    list(files=compact(files), rsmith=rsmith)
  })
}
