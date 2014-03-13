#' Render whisker templates.
#'
#' Any files matching \code{pattern}, and containing a template entry
#' in their metadata will have their contents replaced by the template
#' processed by \code{\link[whisker]{whisker.render}}.
#'
#' Metadata in the page metadata is available as is. Site metadata
#' is available with the prefix \code{site.}.
#'
#' Uses moustache syntax: \url{http://mustache.github.io/}.
#'
#' @examples
#' static_site <- rsmith_demo("static-site")
#' use_whisker(static_site)
use_whisker <- function(rsmith, pattern = "\\.R?md$",
                        template_dir = "templates") {
  if (!is_installed("whisker")) {
    stop("Please install the whisker package", call. = FALSE)
  }

  old <- setwd(dirname(rsmith$metadata$.src))
  on.exit(setwd(old), add = TRUE)

  templates <- load_templates(template_dir)
  whisker_one <- function(file, rsmith) {
    if (!grepl(pattern, path(file))) return(file)
    if (is.null(file$metadata$template)) return(file)

    file$contents <- render_template(file, templates, rsmith)
    file$template <- NULL
    file
  }
  transform_each(rsmith, whisker_one)
}

load_templates <- function(path) {
  template_paths <- dir(path, full.names = TRUE)
  if (length(template_paths) == 0) {
    stop("No templates found", call. = FALSE)
  }
  templates <- lapply(template_paths, function(x) {
    reactiveFileReader(250, NULL, x, read_file)
  })
  names(templates) <- basename(template_paths)

  templates
}

render_template <- function(file, templates, rsmith) {
  template <- templates[file$metadata$template]
  if (is.na(template)) {
    warning("Couldn't find template ", file$metadata$template, " in ",
      path(file), call. = FALSE)
    return(file$contents)
  }

  metadata <- file$metadata
  metadata$contents <- file$contents
  metadata[paste0("site.", names(rsmith$metadata))] <- rsmith$metadata

  whisker::whisker.render(template, metadata)
}
