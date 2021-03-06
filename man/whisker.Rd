% Generated by roxygen2 (4.0.0): do not edit by hand
\name{whisker}
\alias{whisker}
\title{Render whisker templates.}
\usage{
whisker(pattern = "\\\\.html$", template_dir = "templates")
}
\arguments{
  \item{pattern}{Regular expression describing patterns to
  process.}

  \item{template_dir}{Directory in which to look for
  templates. Relative to site base directory.}
}
\description{
Any files matching \code{pattern}, and containing a template entry
in their metadata will have their contents replaced by the template
processed by \code{\link[whisker]{whisker.render}}.
}
\details{
Metadata in the page metadata is available as is. Site metadata
is available with the prefix \code{site.}.

Uses moustache syntax: \url{http://mustache.github.io/}.
}
\examples{
static_site <- rsmith_demo("static-site")
static_site \%>\% use(markdown()) \%>\% preview()
static_site \%>\% use(markdown()) \%>\% use(whisker(".html")) \%>\% preview()
}

