template_plugin <- function(package, render, pattern = "\\.R?md$",
                            template_dir = "templates") {
  if (!is_installed(package)) {
    stop("Please install the ", package, " package", call. = FALSE)
  }

  templates <- NULL
  global_metadata <- NULL
  init <- function(rsmith) {
    template_path <- file.path(rsmith$metadata$.base, template_dir)
    templates <<- load_templates(template_path)

    global_metadata <<- rsmith$metadata

    rsmith
  }
  process <- function(files) {
    files <- lapply(files, function(file) {
      if (!grepl(pattern, path(file))) return(file)
      if (is.null(file$metadata$template)) return(file)

      file$contents <- render_template(file, render, templates, global_metadata)
      file$template <- NULL
      file
    })
    compact(files)
  }

  plugin_with_init(package, init, process)
}

load_templates <- function(path) {
  template_paths <- dir(path, full.names = TRUE)
  if (length(template_paths) == 0) {
    stop("No templates found", call. = FALSE)
  }
  templates <- lapply(template_paths, read_file)
  names(templates) <- basename(template_paths)

  templates
}

render_template <- function(file, method, templates, global_metadata) {
  template <- templates[[file$metadata$template]]
  if (is.null(template)) {
    warning("Couldn't find template ", file$metadata$template, " in ",
      path(file), call. = FALSE)
    return(file$contents)
  }

  metadata <- build_metadata(file, global_metadata)
  method(template, metadata)
}

build_metadata <- function(file, global) {
  metadata <- file$metadata
  metadata$contents <- file$contents
  metadata[paste0("site.", names(global))] <- global

  metadata
}
