# rsmith

[![Build Status](https://travis-ci.org/hadley/rsmith.png)](https://travis-ci.org/hadley/rsmith)

rsmith is inspired by [metalsmith](http://www.metalsmith.io/), which is a static site generator for node with a very simple API, based almost entirely on plugins.
rsmith has a functional API, which when combined with [magrittr](https://github.com/smbache/magrittr), provides a pretty nice declarative specification:

```R
rsmith("src", "dest") %>%
  use(markdown()) %>%
  use(whisker()) %>%
  build()
```

Possibly the coolest feature is that it uses Shiny's reactivity to cache interim results. This means that if you use `watch()` instead of `build()`, rsmith will watch for changes on disk and will do the minimal amount of work to update the site:

```R
rsmith("src", "dest") %>%
  use(markdown()) %>%
  use(whisker()) %>%
  watch()
```

## Plugins

* `markdown()`: render `.md` to `.html` with the
  [markdown](http://cran.r-project.org/web/packages/markdown) package.

* `rmarkdown()`: render `.Rmd` to `.html`, `.pdf` or `.doc` with
  [rmarkdown](http://rmarkdown.rstudio.com/).

* use `brew()` or `whisker()` templates

* `ignore_draft()`, `ignore_files()`: ignore files based on either metadata
  or path

## Main differences

Rsmith adheres to the spirit of metalsmith, but is written in idiomatic R. This means that it:

* Has a more functional flavour so you can use it with the pipe operation
  from [magrittr](https://github.com/smbache/magrittr).

* Stores the file path in the metadata rather than as the object name.
  This makes it easier to use `lapply()` rather than for loops.

* More plugins are built-in to the package because R packages are usually
  heavier than npm packages.
