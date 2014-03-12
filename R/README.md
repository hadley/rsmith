# rsmith

rsmith is a port of the node static site generator [metalsmith](http://www.metalsmith.io/).

## Main differences

Rsmith adheres to the basic metasmith principle that everything should be a plugin, but:


* Has a more functional flavour so you can use it with the pipe operation
  from [magrittr](https://github.com/smbache/magrittr).

* Stores the file path in the metadata rather than as the object name.
  This makes it easier to use `lapply()` rather than for loops.

* More plugins are built-in to the package because R packages are usually
  heavier than npm packages.
