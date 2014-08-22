read_file <- function(path) {
  contents <- read_file_raw(path)
  if (is_binary_raw(contents)) {
    contents
  } else {
    text <- rawToChar(contents)
    Encoding(text) <- "UTF-8"
    text
  }
}

read_file_with_metadata <- function(path, quiet = FALSE) {
  if (!file.exists(path)) {
    warning(path, " does not exist", call. = FALSE)
    return(NULL)
  }
  if (!quiet) {
    message("Loading ", path)
  }

  text <- read_file(path)

  if (!is.raw(text)) {
    yaml_loc <- locate_metadata(text)
    if (is.null(yaml_loc)) {
      metadata <- list()
      contents <- text
    } else {
      yaml <- substr(text, yaml_loc[1, 2], yaml_loc[2, 1])
      metadata <- yaml::yaml.load(yaml)
      contents <- substr(text, yaml_loc[2, 2] + 1, nchar(text))
    }
  }

  metadata$.path <- path
  rsmith_file(metadata, contents)
}

# Has yaml metadata if first line if starts with "---\n"
# and has another \n---\n in file.
locate_metadata <- function(text) {
  stopifnot(is.character(text), length(text) == 1, !is.na(text))

  yaml_start <- locate(text, "^---\n")
  if (is.null(yaml_start)) return(NULL)

  yaml_next <- locate(text, "\n---(\n|$)")
  if (is.null(yaml_next)) return(NULL)

  rbind(yaml_start, yaml_next)
}

reactive_file_with_metadata <- function(path, ..., interval = 1) {
  norm_path <- normalizePath(path)

  shiny::reactivePoll(
    interval * 1000,
    NULL,
    function() {
      info <- file.info(norm_path)
      return(paste(info$mtime, info$size))
    },
    function() {
      message("Loading ", path)
      out <- read_file_with_metadata(norm_path, ..., quiet = TRUE)
      out$metadata$.path <- path
      out
    }
  )
}

locate <- function(x, pattern) {
  match <- regexpr(pattern, x)
  if (match[[1]] == -1) return(NULL)

  c(match[[1]], match[[1]] + attr(match, "match.length"))
}

rsmith_file <- function(metadata, contents) {
  out <- list(metadata = metadata, contents = contents)
  class(out) <- "rsmith_file"
  out
}

#' @export
print.rsmith_file <- function(x, ...) {
  cat("<rsmith_file>\n")
  print_metadata(x$metadata)
  cat("Contents: ", cont_len(x$contents), " bytes\n", sep = "")
}

path <- function(x) {
  x$metadata$.path
}

is_binary_raw <- function(raw) {
  any(raw == 0)
}

is_binary <- function(x) {
  is.raw(x$contents)
}

cont_len <- function(x) {
  if (is_binary(x)) {
    length(x$contents)
  } else {
    nchar(x$contents)
  }
}
