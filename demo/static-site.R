library(rsmith)

rsmith_demo("static-site") %>%
  add_metadata(
    title = "My Blog",
    description = "My second, super-cool blog."
  ) %>%
  use_plugin(rmarkdown()) %>%
  use_plugin(whisker()) %>%
  build()
