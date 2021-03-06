% Generated by roxygen2 (4.0.0): do not edit by hand
\name{ignore_files}
\alias{ignore_files}
\title{Ignore files that match a pattern.}
\usage{
ignore_files(pattern, ...)
}
\arguments{
  \item{pattern}{A regular expression to match against the
  file paths.  Any files matching the pattern will be
  dropped.}

  \item{...}{Additional arguments passed to
  \code{\link{grepl}}}
}
\value{
An \code{\link{plugin}}
}
\description{
Ignore files that match a pattern.
}
\examples{
static_site <- rsmith_demo("static-site")
static_site \%>\% use(ignore_files("first")) \%>\% preview()
static_site \%>\% use(ignore_files("post")) \%>\% preview()
}
\seealso{
Other plugins: \code{\link{add_metadata}};
  \code{\link{ignore_drafts}}; \code{\link{use}}
}

