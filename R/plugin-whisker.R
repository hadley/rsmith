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
#' @param pattern Regular expression describing patterns to process.
#' @param template_dir Directory in which to look for templates. Relative
#'   to site base directory.
#' @export
#' @examples
#' static_site <- rsmith_demo("static-site")
#' static_site %>% preview()
#' static_site %>% add_plugin(use_whisker()) %>% preview()
use_whisker <- function(pattern = "\\.R?md$", template_dir = "templates") {
  if (!is_installed("whisker")) {
    stop("Please install the whisker package", call. = FALSE)
  }

  templates <- NULL
  global_metadata <- NULL
  init <- function(rsmith) {
    template_path <- file.path(rsmith$metadata$.base, template_dir)
    templates <<- load_templates(template_path)

    global_metadata <<- rsmith$metadata

    rsmith
  }
  process <- function(file) {
    if (!grepl(pattern, path(file))) return(file)
    if (is.null(file$metadata$template)) return(file)

    file$contents <- render_template(file, templates, global_metadata)
    file$template <- NULL
    file
  }

  plugin_with_init("whisker", init, process)
}

load_templates <- function(path) {
  template_paths <- dir(path, full.names = TRUE)
  if (length(template_paths) == 0) {
    stop("No templates found", call. = FALSE)
  }
  templates <- lapply(template_paths, read_file)
  names(templates) <- basename(template_paths)

  templates
}

render_template <- function(file, templates, global_metadata) {
  template <- templates[file$metadata$template]
  if (is.na(template)) {
    warning("Couldn't find template ", file$metadata$template, " in ",
      path(file), call. = FALSE)
    return(file$contents)
  }

  metadata <- file$metadata
  metadata$contents <- file$contents
  metadata[paste0("site.", names(global_metadata))] <- global_metadata

  whisker::whisker.render(template, metadata)
}
