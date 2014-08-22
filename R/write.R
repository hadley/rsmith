write <- function(rsmith, files, quiet = FALSE) {
  if (!quiet) message("Writing output")

  old <- setwd(rsmith$metadata$.base)
  on.exit(setwd(old), add = TRUE)

  dest <- rsmith$metadata$.dest
  if (!file.exists(dest)) {
    dir.create(dest)
  }
  setwd(dest)

  for (file in files) {
    file_dir <- dirname(file$metadata$.path)
    if (!file.exists(file_dir)) dir.create(file_dir, recursive = TRUE)
    write_if_different(file$metadata$.path, file$contents)
  }

  invisible(dest)
}

write_if_different <- function(path, contents) {
  if (same_contents(path, contents)) return(invisible(FALSE))

  message("Writing ", path)

  name <- basename(path)
  if (is.raw(contents)) {
    writeBin(contents, con <- file(path, open = "wb"))
    close(con)
  } else {
    writeLines(contents, path, sep = "")
  }

  invisible(TRUE)
}

same_contents <- function(path, contents) {
  if (!file.exists(path)) return(FALSE)

  text_hash <- digest::digest(contents, serialize = FALSE)
  file_hash <- digest::digest(file = path)

  identical(text_hash, file_hash)
}
