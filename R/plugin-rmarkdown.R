#' Convert rmarkdown to html
#'
#' Use the \pkg{rmarkdown} package. You can set options that apply to all
#' files in the global metadata field \code{rmarkdown}.
#'
#' @param pattern Regular expression used to identify Rmarkdown files.
#' @export
#' @examples
#' rmarkdown_demo <- rsmith_demo("rmarkdown")
#' rmarkdown_demo %>% preview()
#' rmarkdown_demo %>% use(rmarkdown()) %>% preview()
rmarkdown <- function(pattern = "\\.Rmd$") {
  if (!is_installed("rmarkdown")) {
    stop("Please install the rmarkdown package", call. = FALSE)
  }

  read_all_files <- function(path) {
    if (!file.exists(path) || !file.info(path)$isdir) return(list())

    file_names <- dir(path, full.names=TRUE, recursive=TRUE)
    lapply(file_names, read_file_with_metadata, quiet = TRUE)
  }

  global <- NULL
  init <- function(rsmith) {
    global <<- rsmith$metadata$rmarkdown %||% list()

    rsmith
  }

  process <- function(files, rsmith) {

    init(rsmith)

    tmp_dir <- tempfile()
    dir.create(tmp_dir)
    on.exit(unlink(tmp_dir, recursive = TRUE), add = TRUE)
    old <- setwd(tmp_dir)
    on.exit(setwd(old), add=TRUE)

    lib_dir <- "lib"
    dir.create(lib_dir)

    files <- lapply(files, function(file) {
      if (!grepl(pattern, path(file))) return(file)

      metadata <- modifyList(global, file$metadata)

      # Save file to temporary location
      in_file <- file.path(tmp_dir, basename(path(file)))
      cat("---\n", yaml::as.yaml(metadata), "---\n\n", file = in_file, sep = "")
      writeBin(file$contents, con <- file(in_file, open="w+b"))
      close(con)

      # Render with rmarkdown
      out <- rmarkdown::render(in_file, NULL, quiet = TRUE,
        output_options = list(self_contained = FALSE, lib_dir = lib_dir))

      # Update file object
      file$contents <- read_file(out)
      path <- tools::file_path_sans_ext(file$metadata$.path)
      file$metadata$.path <- paste0(path, ".", tools::file_ext(out))

      file_list <- list(file)

      # Collect other output files
      x_dir <- paste0(path, "_files")
      x_files <- read_all_files(x_dir)

      c(file_list, x_files)
    })

    files <- compact(unlist(files, recursive = FALSE))

    # Plus the lib files
    lib_files <- read_all_files("lib")

    list(files=c(files, lib_files), rsmith=rsmith)
  }

  plugin("rmarkdown", process)
}
