#' Render brew templates.
#'
#' Any files matching \code{pattern}, and containing a template entry
#' in their metadata will have their contents replaced by the template
#' processed by \code{\link[brew]{brew}}.
#'
#' Metadata in the page metadata is available as is. Site metadata
#' is available with the prefix \code{site.}.
#'
#' @param pattern Regular expression describing patterns to process.
#' @param template_dir Directory in which to look for templates. Relative
#'   to site base directory.
#' @export
#' @examples
#' brew_site <- rsmith_demo("brew")
#' brew_site %>% use(brew()) %>% preview()
brew <- function(pattern = "\\.R?.+$", template_dir = "templates") {
  render <- function(template, metadata) {
    brew::brew(text = template,
      envir = list2env(metadata, parent = globalenv()))
  }

  template_plugin("brew", render, pattern = pattern,
    template_dir = template_dir)
}
