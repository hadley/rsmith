
# static-site

This example uses rsmith to make a static site. To test it out yourself just run:

```R
library(rsmith)
library(magrittr)

rsmith() %>%
  add_metadata(
    title = "My Blog",
    description = "My second, super-cool blog."
  ) %>%
  use(markdown()) %>%
  use(whisker()) %>%
  build()
```
