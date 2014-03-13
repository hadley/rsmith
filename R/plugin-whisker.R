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
#' static_site %>% use(markdown()) %>% preview()
#' static_site %>% use(markdown()) %>% use(whisker(".html")) %>% preview()
whisker <- function(pattern = "\\.html$", template_dir = "templates") {
  template_plugin("whisker", whisker::whisker.render, pattern = pattern,
    template_dir = template_dir)
}
