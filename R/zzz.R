# BSD_2_clause

.onLoad <- function(libname, pkgname) {
  gs_cmd <- "which gs"
  conv_cmd <- "which convert"
  pdftk_cmd <- "which pdftk"
  tess_cmd <- "which tesseract"
  checks <- c(gs_cmd, conv_cmd, pdftk_cmd, tess_cmd)
  for(i in checks) {
    if(grepl(system(i, intern = TRUE), "not found")) {
      cmd <- gsub(i, pattern = "which ", replacement = "")
      warning(paste(cmd, "is not installed or is not on your $PATH;",
                 "please check and try to load again"))
    }
  }

  # create the tempdir() directories
  make_main_dirs()

  # set some options
  op <- options()
  op.pdftext <- list(
    pdftext.tess_conf = ""
  )
  toset <- !(names(op.pdftext) %in% names(op))
  if(any(toset)) options(op.pdftext[toset])

  invisible()
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "\npdftext is attached. To use a custom config file, run\n",
    "\n",
    "    set_tess_conf('name_of_conf')\n",
    "\n",
    "where 'name_of_conf' is a file located in $TESS_DATA/configs. See\n",
    "https://goo.gl/QGDFP2 for more information. An example config can\n",
    "be seen with data(asciimostly).\n"
  )
}

.onUnload <- function(libname) {
  answer <- readline("Do you want to copy files from the tempdir? [Y/N/C] ")
  if(answer == "Y") {
    msg <- "Which directories should be copied? [images/pages/text; separate with spaces] "
    witch <- readline(msg)
    saves <- stringr::str_split(witch, pattern = " ")
    if("images" %in% saves) {
      img_loc <- readline("Where to save images? [path/to/save/dir] ")
      save_imgs(img_loc)
    }
    if("pages" %in% saves) {
      pgs_loc <- readline("Where to save pages of text? [path/to/save/dir] ")
      save_pages(pgs_loc)
    }
    if("text" %in% saves) {
      txt_loc <- readline("Where to save concatenated text? [path/to/save/dir] ")
      save_txts(txt_loc)
    }
  } else if(answer == "C") {
    message(paste0("Sorry, can't cancel now; files are at: ", tempdir()))
  } else {
    message(paste0("OK, the files and directories are at: ", tempdir()))
  }
}
