#' @examples
#' static_site <- rsmith_demo("static-site")
#' build(use_whisker(static_site))
#' build(static_site)
build <- function(rsmith, ...) {
  dest <- rsmith$metadata$.dest

  if (!file.exists(dest)) {
    dir.create(dest)
  }

  old <- setwd(dest)
  on.exit(setwd(old), add = TRUE)

  for (file in rsmith$files) {
    write_if_different(file$metadata$.path, file$contents)
  }

  invisible(dest)
}

write_if_different <- function(path, contents) {
  if (same_contents(path, contents)) return(invisible(FALSE))

  message("Writing ", path)

  name <- basename(path)
  writeLines(contents, path)

  invisible(TRUE)
}

same_contents <- function(path, contents) {
  if (!file.exists(path)) return(FALSE)

  contents <- paste0(contents, "\n")

  text_hash <- digest::digest(contents, serialize = FALSE)
  file_hash <- digest::digest(file = path)

  identical(text_hash, file_hash)
}
