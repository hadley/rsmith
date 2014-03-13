# rsmith

[![Build Status](https://travis-ci.org/hadley/rsmith.png)](https://travis-ci.org/hadley/rsmith)

rsmith is a port of the node static site generator [metalsmith](http://www.metalsmith.io/).

## Main differences

Rsmith adheres to the spirit of metalsmith, but is written in idiomatic R. This means that it:

* Has a more functional flavour so you can use it with the pipe operation
  from [magrittr](https://github.com/smbache/magrittr).

* Stores the file path in the metadata rather than as the object name.
  This makes it easier to use `lapply()` rather than for loops.

* More plugins are built-in to the package because R packages are usually
  heavier than npm packages.
